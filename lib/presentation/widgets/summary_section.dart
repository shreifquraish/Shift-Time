import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/cubit/shift_cubit.dart';
import '../../logic/cubit/shift_state.dart';
import '../../data/models/record_model.dart';
import 'glass_card.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftCubit, ShiftState>(
      builder: (context, state) {
        double totalHours = 0.0;
        double totalWithdrawals = 0.0;

        for (var item in state.history) {
          if (item.type == 'shift') {
            totalHours += item.totalDurationHrs ?? 0.0;
          } else if (item.type == 'withdrawal') {
            totalWithdrawals += item.amount;
          }
        }

        // الحساب الديناميكي بناءً على السعر الحالي المدخل
        double totalEarnings = totalHours * state.hourlyRate;
        double netTotal = totalEarnings - totalWithdrawals;

        return Column(
          children: [
            // صف يحتوي على إجمالي الساعات وإجمالي الأرباح
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        children: [
                          const Text("⏱️ إجمالي الساعات", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text(
                            RecordModel.formatHoursToCustom(totalHours),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        children: [
                          const Text("💰 إجمالي الأرباح", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text(
                            "${totalEarnings.toStringAsFixed(2)} ج.م",
                            style: const TextStyle(color: AppColors.successColor, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // صف يحتوي على إجمالي السلف وصافي الربح
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        children: [
                          const Text("💸 إجمالي السلف", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text(
                            "${totalWithdrawals.toStringAsFixed(2)} ج.م",
                            style: const TextStyle(color: AppColors.dangerColor, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        children: [
                          const Text("💎 صافي الربح", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text(
                            "${netTotal.toStringAsFixed(2)} ج.م",
                            style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}