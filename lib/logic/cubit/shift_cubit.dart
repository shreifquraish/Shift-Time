import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/record_model.dart';
import 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  ShiftCubit() : super(ShiftState(hourlyRate: 50.0, history: []));

  void updateHourlyRate(double rate) {
    emit(state.copyWith(hourlyRate: rate));
  }

  void addShift({
    required DateTime date,
    required String dateStr,
    required List<Period> periods,
  }) {
    final double totalHrs = periods.fold(0.0, (sum, p) => sum + p.durationHrs);

    final newShift = RecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'shift',
      date: date,
      dateStr: dateStr,
      amount: 0.0, // الحساب هيبقى ديناميكي بناءً على السعر الحالي
      periods: periods,
      totalDurationHrs: totalHrs,
    );
    
    final updatedHistory = List<RecordModel>.from(state.history)..insert(0, newShift);
    emit(state.copyWith(history: updatedHistory));
  }

  void addWithdrawal({required DateTime date, required String dateStr, required double amount}) {
    final newWithdrawal = RecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'withdrawal',
      date: date,
      dateStr: dateStr,
      amount: amount,
    );

    final updatedHistory = List<RecordModel>.from(state.history)..insert(0, newWithdrawal);
    emit(state.copyWith(history: updatedHistory));
  }

  void deleteRecord(String id) {
    final updatedHistory = state.history.where((r) => r.id != id).toList();
    emit(state.copyWith(history: updatedHistory));
  }

  void clearAllHistory() {
    emit(state.copyWith(history: []));
  }
}