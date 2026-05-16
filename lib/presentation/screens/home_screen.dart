import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/cubit/shift_cubit.dart';
import '../widgets/summary_section.dart';
import '../widgets/shift_form.dart';
import '../widgets/withdrawal_form.dart';
import '../widgets/history_list.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📅 سجل الدوام", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              Text("أدخل مواعيدك ومسحوباتك واحسب الصافي بدقة", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // كارت تعديل سعر الساعة بنفس ستايل حقل السلفة وبدون أخطاء بوردر
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("💵 سعر ساعة العمل", style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "أدخل السعر الحالي للساعة...",
                        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        suffixText: "جنية",
                        suffixStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)), // تم الإصلاح هنا مباشرة
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      onChanged: (val) {
                        final rate = double.tryParse(val);
                        if (rate != null) context.read<ShiftCubit>().updateHourlyRate(rate);
                      },
                    ),
                  ],
                ),
              ),
              
              const SummarySection(),
              const ShiftForm(),
              WithdrawalForm(),
              
              // سطر عنوان السجلات + زرار مسح السجلات بالكامل
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("📜 سجل العمليات", style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: AppColors.dangerColor),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("مسح كل السجلات؟", style: TextStyle(fontSize: 16)),
                            content: const Text("هل أنت متأكد من حذف السجل بالكامل؟ لا يمكن التراجع عن هذا الأجراء."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
                              TextButton(
                                onPressed: () {
                                  context.read<ShiftCubit>().clearAllHistory();
                                  Navigator.pop(ctx);
                                },
                                child: const Text("مسح الكل", style: TextStyle(color: AppColors.dangerColor)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_sweep, size: 20),
                      label: const Text("مسح بالكامل", style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              
              const HistoryList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}