import 'package:hive_flutter/hive_flutter.dart';
import '../models/flight_report.dart';
import '../models/crew_note.dart';
import '../models/defect.dart';

class SajnaDatabase {
  static const String boxReports = 'sajna_reports';
  static const String boxNotes = 'sajna_notes';
  static const String boxDefects = 'sajna_defects';
  static const String boxChecklists = 'sajna_checklists';
  static const String boxPrefs = 'sajna_preferences';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Open storage boxes
    await Hive.openBox(boxReports);
    await Hive.openBox(boxNotes);
    await Hive.openBox(boxDefects);
    await Hive.openBox(boxChecklists);
    await Hive.openBox(boxPrefs);
  }

  // --- Flight Reports Box Operations ---
  static List<FlightReport> getReports() {
    final box = Hive.box(boxReports);
    final List<FlightReport> list = [];
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null && data is Map) {
        // Cast keys/values to dynamic
        final map = Map<String, dynamic>.from(data);
        list.add(FlightReport.fromMap(map));
      }
    }
    // Sort reports by date (descending)
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  static Future<void> saveReport(FlightReport report) async {
    final box = Hive.box(boxReports);
    await box.put(report.id, report.toMap());
  }

  static Future<void> clearReports() async {
    await Hive.box(boxReports).clear();
  }

  // --- Crew Notes Box Operations ---
  static List<CrewNote> getNotes() {
    final box = Hive.box(boxNotes);
    final List<CrewNote> list = [];
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null && data is Map) {
        final map = Map<String, dynamic>.from(data);
        list.add(CrewNote.fromMap(map));
      }
    }
    // Pinned notes first, then alphabetical/descending
    list.sort((a, b) {
      if (a.pinned && !b.pinned) return -1;
      if (!a.pinned && b.pinned) return 1;
      return b.id.compareTo(a.id);
    });
    return list;
  }

  static Future<void> saveNote(CrewNote note) async {
    final box = Hive.box(boxNotes);
    await box.put(note.id, note.toMap());
  }

  static Future<void> deleteNote(String id) async {
    final box = Hive.box(boxNotes);
    await box.delete(id);
  }

  // --- Defect Log Box Operations ---
  static List<Defect> getDefects() {
    final box = Hive.box(boxDefects);
    final List<Defect> list = [];
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null && data is Map) {
        final map = Map<String, dynamic>.from(data);
        list.add(Defect.fromMap(map));
      }
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  static Future<void> saveDefect(Defect defect) async {
    final box = Hive.box(boxDefects);
    await box.put(defect.id, defect.toMap());
  }

  static Future<void> deleteDefect(String id) async {
    final box = Hive.box(boxDefects);
    await box.delete(id);
  }

  // --- Checklist State Operations ---
  static List<bool> getChecklistState(String checklistKey, int length) {
    final box = Hive.box(boxChecklists);
    final List? state = box.get(checklistKey);
    if (state != null) {
      return List<bool>.from(state);
    }
    return List<bool>.filled(length, false);
  }

  static Future<void> saveChecklistState(String checklistKey, List<bool> state) async {
    final box = Hive.box(boxChecklists);
    await box.put(checklistKey, state);
  }

  static Future<void> resetAllChecklists() async {
    await Hive.box(boxChecklists).clear();
  }

  // --- AI Preference Settings ---
  static String getAiMode() {
    final box = Hive.box(boxPrefs);
    return box.get('ai_mode', defaultValue: 'auto');
  }

  static Future<void> saveAiMode(String mode) async {
    final box = Hive.box(boxPrefs);
    await box.put('ai_mode', mode);
  }

  static bool isDarkMode() {
    final box = Hive.box(boxPrefs);
    return box.get('dark_mode', defaultValue: true);
  }

  static Future<void> saveThemeMode(bool isDark) async {
    final box = Hive.box(boxPrefs);
    await box.put('dark_mode', isDark);
  }
}
