class CrewNote {
  final String id;
  final String title;
  final String category; // "Operational", "Catering", "Safety", "Briefing"
  final String flight;
  final String content;
  final String date;
  final String time;
  final bool pinned;

  CrewNote({
    required this.id,
    required this.title,
    required this.category,
    required this.flight,
    required this.content,
    required this.date,
    required this.time,
    this.pinned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'flight': flight,
      'content': content,
      'date': date,
      'time': time,
      'pinned': pinned ? 1 : 0,
    };
  }

  factory CrewNote.fromMap(Map<String, dynamic> map) {
    return CrewNote(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? 'Operational',
      flight: map['flight'] ?? '',
      content: map['content'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      pinned: (map['pinned'] == 1 || map['pinned'] == true),
    );
  }

  CrewNote copyWith({
    String? id,
    String? title,
    String? category,
    String? flight,
    String? content,
    String? date,
    String? time,
    bool? pinned,
  }) {
    return CrewNote(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      flight: flight ?? this.flight,
      content: content ?? this.content,
      date: date ?? this.date,
      time: time ?? this.time,
      pinned: pinned ?? this.pinned,
    );
  }
}
