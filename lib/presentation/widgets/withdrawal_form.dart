import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/cubit/shift_cubit.dart';
import 'glass_card.dart';

class WithdrawalForm extends StatelessWidget {
  final _amountController = TextEditingController();

  WithdrawalForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("💸 إضافة سلفة / مسحوبات", style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "المبلغ بالجنية",
              labelStyle: TextStyle(color: AppColors.textSecondary),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerColor),
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                if (amount != null && amount > 0) {
                  context.read<ShiftCubit>().addWithdrawal(date: DateTime.now(), amount: amount, dateStr: '');
                  _amountController.clear();
                }
              },
              child: const Text("تسجيل السلفة", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}