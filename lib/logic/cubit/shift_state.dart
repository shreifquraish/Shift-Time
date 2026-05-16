import '../../data/models/record_model.dart';

class ShiftState {
  final double hourlyRate;
  final List<RecordModel> history;

  ShiftState({required this.hourlyRate, required this.history});

  // 1. إجمالي الساعات
  double get totalHours => history
      .where((r) => r.type == 'shift')
      .fold(0.0, (sum, r) => sum + (r.totalDurationHrs ?? 0.0));

  // 2. إجمالي الأرباح يحسب ديناميكياً بناءً على السعر المكتوب حالياً
  double get totalEarnings => totalHours * hourlyRate;

  // 3. إجمالي السلف
  double get totalWithdrawals => history
      .where((r) => r.type == 'withdrawal')
      .fold(0.0, (sum, r) => sum + r.amount);

  // 4. صافي الربح
  double get netTotal => totalEarnings - totalWithdrawals;

  ShiftState copyWith({double? hourlyRate, List<RecordModel>? history}) {
    return ShiftState(
      hourlyRate: hourlyRate ?? this.hourlyRate,
      history: history ?? this.history,
    );
  }
}