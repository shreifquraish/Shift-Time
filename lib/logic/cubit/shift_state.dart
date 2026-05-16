import '../../data/models/record_model.dart';

class ShiftState {
  final double hourlyRate;
  final List<RecordModel> history;

  ShiftState({required this.hourlyRate, required this.history});

  // 1. حساب إجمالي الساعات لكل فترات الدوام المضافة
  double get totalHours => history
      .where((r) => r.type == 'shift')
      .fold(0.0, (sum, r) => sum + (r.totalDurationHrs ?? 0.0));

  // 2. حساب إجمالي الأرباح ديناميكياً بناءً على السعر الحالي اللي مدخله المستخدم
  double get totalEarnings => totalHours * hourlyRate;

  // 3. حساب إجمالي السلف والمسحوبات
  double get totalWithdrawals => history
      .where((r) => r.type == 'withdrawal')
      .fold(0.0, (sum, r) => sum + r.amount);

  // 4. حساب صافي الربح (الأرباح الحالية - السلف الحالية)
  double get netTotal => totalEarnings - totalWithdrawals;

  ShiftState copyWith({double? hourlyRate, List<RecordModel>? history}) {
    return ShiftState(
      hourlyRate: hourlyRate ?? this.hourlyRate,
      history: history ?? this.history,
    );
  }
}