class Period {
  final String startStr;
  final String endStr;
  final double durationHrs;

  Period({
    required this.startStr,
    required this.endStr,
    required this.durationHrs,
  });
}

class RecordModel {
  final String id;
  final String type; // 'shift' أو 'withdrawal'
  final DateTime date;
  final String dateStr;
  final double amount; 
  final List<Period>? periods;
  final double? totalDurationHrs;

  RecordModel({
    required this.id,
    required this.type,
    required this.date,
    required this.dateStr,
    required this.amount,
    this.periods,
    this.totalDurationHrs,
  });

  // الدالة السحرية لتحويل الكسر (مثال: 3.41) إلى صيغة مفهومة (3 س : 25 د)
  static String formatHoursToCustom(double duration) {
    if (duration <= 0) return "0 س : 0 د";
    int hours = duration.toInt();
    int minutes = ((duration - hours) * 60).round();
    
    if (minutes == 60) {
      hours += 1;
      minutes = 0;
    }
    return "$hours س : $minutes د";
  }
}