import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/cubit/shift_cubit.dart';
import '../../logic/cubit/shift_state.dart';
import '../../data/models/record_model.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftCubit, ShiftState>(
      builder: (context, state) {
        if (state.history.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text("لا توجد سجلات مضافة بعد", style: TextStyle(color: AppColors.textSecondary)),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.history.length,
          itemBuilder: (context, index) {
            final item = state.history[index];
            final isShift = item.type == 'shift';
            
            // حساب الربح للدورة ديناميكياً بناءً على السعر الحالي المكتوب فوق
            final currentAmount = isShift 
                ? (item.totalDurationHrs ?? 0.0) * state.hourlyRate 
                : item.amount;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 1.2),
              ),
              child: Row(
                children: [
                  Icon(
                    isShift ? Icons.access_time_filled_rounded : Icons.money_off_rounded,
                    color: isShift ? AppColors.successColor : AppColors.dangerColor,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.dateStr,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        if (isShift && item.periods != null)
                          ...item.periods!.map((p) => Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  "🕒 من ${p.startStr} إلى ${p.endStr} (${RecordModel.formatHoursToCustom(p.durationHrs)})",
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                ),
                              ))
                        else
                          const Text(
                            "💱 تم سحب مبلغ (سلفة)",
                            style: TextStyle(color: AppColors.dangerColor, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${isShift ? '+' : '-'} ${currentAmount.toStringAsFixed(2)} ج.م",
                            style: TextStyle(
                              color: isShift ? AppColors.successColor : AppColors.dangerColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (isShift)
                            Text(
                              "الإجمالي: ${RecordModel.formatHoursToCustom(item.totalDurationHrs ?? 0.0)}",
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.dangerColor, size: 22),
                        onPressed: () => context.read<ShiftCubit>().deleteRecord(item.id),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}