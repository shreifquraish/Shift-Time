import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/record_model.dart';
import '../../logic/cubit/shift_cubit.dart';
import 'glass_card.dart';

class ShiftForm extends StatefulWidget {
  const ShiftForm({super.key});

  @override
  State<ShiftForm> createState() => _ShiftFormState();
}

class _ShiftFormState extends State<ShiftForm> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, TimeOfDay?>> dynamicPeriods = [
    {'start': null, 'end': null}
  ];

  void _pickTime(int index, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          dynamicPeriods[index]['start'] = picked;
        } else {
          dynamicPeriods[index]['end'] = picked;
        }
      });
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "✍️ إضافة دوام جديد",
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // حقل التاريخ باللون الأخضر الشفاف
          InkWell(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.successInputBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.successColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("📆 تاريخ الدوام:", style: TextStyle(color: AppColors.textSecondary)),
                  Text(
                    "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                    style: const TextStyle(color: AppColors.successColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // الفترات الديناميكية
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dynamicPeriods.length,
            itemBuilder: (context, index) {
              final start = dynamicPeriods[index]['start'];
              final end = dynamicPeriods[index]['end'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTime(index, true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.successInputBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.successColor.withOpacity(0.3)),
                          ),
                          child: Center(
                            child: Text(
                              start == null ? "🕒 وقت البدء" : start.format(context),
                              style: TextStyle(color: start == null ? AppColors.textSecondary : Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTime(index, false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.successInputBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.successColor.withOpacity(0.3)),
          ),
                          child: Center(
                            child: Text(
                              end == null ? "🕒 وقت الانتهاء" : end.format(context),
                              style: TextStyle(color: end == null ? AppColors.textSecondary : Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (dynamicPeriods.length > 1) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.dangerColor),
                        onPressed: () => setState(() => dynamicPeriods.removeAt(index)),
                      )
                    ]
                  ],
                ),
              );
            },
          ),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.successColor.withOpacity(0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => setState(() => dynamicPeriods.add({'start': null, 'end': null})),
                  icon: const Icon(Icons.add, size: 18, color: AppColors.successColor),
                  label: const Text("إضافة فترة أخرى", style: TextStyle(color: AppColors.successColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                List<Period> validatedPeriods = [];
                for (var p in dynamicPeriods) {
                  if (p['start'] == null || p['end'] == null) continue;
                  final start = p['start']!;
                  final end = p['end']!;
                  final startDouble = start.hour + (start.minute / 60.0);
                  final endDouble = end.hour + (end.minute / 60.0);
                  double duration = endDouble - startDouble;
                  if (duration <= 0) duration += 24;

                  validatedPeriods.add(Period(
                    startStr: start.format(context),
                    endStr: end.format(context),
                    durationHrs: duration,
                  ));
                }

                if (validatedPeriods.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("برجاء إدخال فترة واحدة كاملة على الأقل")),
                  );
                  return;
                }

                String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                context.read<ShiftCubit>().addShift(date: selectedDate, dateStr: formattedDate, periods: validatedPeriods);

                setState(() {
                  dynamicPeriods = [{'start': null, 'end': null}];
                  selectedDate = DateTime.now();
                });
              },
              child: const Text("حفظ الدوام بالكامل", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}