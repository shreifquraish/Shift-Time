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
        return Column(
          children: [
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
                            RecordModel.formatHoursToCustom(state.totalHours),
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
                            "${state.totalEarnings.toStringAsFixed(2)} ج.م",
                            style: const TextStyle(color: AppColors.successColor, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                            "${state.totalWithdrawals.toStringAsFixed(2)} ج.م",
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
                            "${state.netTotal.toStringAsFixed(2)} ج.م",
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