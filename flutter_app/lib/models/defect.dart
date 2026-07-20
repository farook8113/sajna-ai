class Defect {
  final String id;
  final String flightNo;
  final String seat;
  final String priority; // "Low", "Medium", "High"
  final String desc;
  final DateTime date;

  Defect({
    required this.id,
    required this.flightNo,
    required this.seat,
    required this.priority,
    required this.desc,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flightNo': flightNo,
      'seat': seat,
      'priority': priority,
      'desc': desc,
      'date': date.toIso8601String(),
    };
  }

  factory Defect.fromMap(Map<String, dynamic> map) {
    return Defect(
      id: map['id'] ?? '',
      flightNo: map['flightNo'] ?? '',
      seat: map['seat'] ?? '',
      priority: map['priority'] ?? 'Low',
      desc: map['desc'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}
