import 'package:intl/intl.dart';

class TimelineCalculator {
  // A320 Benchmark Buffers (in minutes relative to STD/STA)
  static const Map<String, int> a320Benchmarks = {
    'arriveOffice': -75,      // D-75 (15 mins before sign in at D-60)
    'readyBriefing': -65,     // D-65 (5 mins before sign in)
    'briefingStarts': -60,    // D-60 (Sign In)
    'briefingCompleted': -50, // D-50
    'leaveOffice': -50,       // D-50
    'firstBus': -48,
    'secondBus': -45,
    'crewOnboard': -40,
    'cleaningStart': -38,
    'cleaningDone': -30,
    'boardingClearance': -30,
    'firstPassenger': -30,
    'lastPassenger': -12,     // Boarding duration 18 mins
    'doorClosed': -3,
    'chocksToDoorOpen': 2,    // Landed + 2 min
    'targetDisembarkation': 9, // Door open + 7 min disembark (Landed + 9 min)
    'cleaningOutstation': 18, // Disembark + 9 min clean (Landed + 18 min)
  };

  // A321 Benchmark Buffers
  static const Map<String, int> a321Benchmarks = {
    'arriveOffice': -90,      // D-90 (15 mins before sign in at D-75)
    'readyBriefing': -80,     // D-80 (5 mins before sign in)
    'briefingStarts': -75,    // D-75 (Sign In)
    'briefingCompleted': -60, // D-60
    'leaveOffice': -60,       // D-60
    'firstBus': -58,
    'secondBus': -55,
    'crewOnboard': -50,
    'cleaningStart': -48,
    'cleaningDone': -40,
    'boardingClearance': -40,
    'firstPassenger': -40,
    'lastPassenger': -18,     // Boarding duration 22 mins
    'doorClosed': -3,
    'chocksToDoorOpen': 2,
    'targetDisembarkation': 11, // Door open + 9 min disembark
    'cleaningOutstation': 20, // Disembark + 9 min clean
  };

  static Map<String, Map<String, String>> calculate({
    required DateTime date,
    required String stdLocal, // format "HH:mm"
    required String staLocal, // format "HH:mm"
    required String acType,   // "A320" or "A321"
    required int tzOffset,    // timezone offset e.g. 4 for SHJ
  }) {
    final Map<String, int> benchmark = (acType == 'A321') ? a321Benchmarks : a320Benchmarks;

    final stdFormat = DateFormat("yyyy-MM-dd HH:mm");
    final dateStr = DateFormat("yyyy-MM-dd").format(date);
    
    final stdDateTime = stdFormat.parse("$dateStr $stdLocal");
    var staDateTime = stdFormat.parse("$dateStr $staLocal");
    
    if (staDateTime.isBefore(stdDateTime)) {
      staDateTime = staDateTime.add(const Duration(days: 1));
    }

    final localTimings = <String, String>{};
    final utcTimings = <String, String>{};

    final timeFormatter = DateFormat("HH:mm");

    void addMilestone(String label, DateTime baseTime, int offsetMinutes) {
      final milestoneTime = baseTime.add(Duration(minutes: offsetMinutes));
      localTimings[label] = timeFormatter.format(milestoneTime);
      
      final utcTime = milestoneTime.subtract(Duration(hours: tzOffset));
      utcTimings[label] = timeFormatter.format(utcTime);
    }

    // Departure milestones
    addMilestone("Arrive to Office", stdDateTime, benchmark['arriveOffice']!);
    addMilestone("Ready for Briefing", stdDateTime, benchmark['readyBriefing']!);
    addMilestone("Briefing Starts", stdDateTime, benchmark['briefingStarts']!);
    addMilestone("Briefing Completed", stdDateTime, benchmark['briefingCompleted']!);
    addMilestone("Leave Office (latest)", stdDateTime, benchmark['leaveOffice']!);
    addMilestone("First Bus", stdDateTime, benchmark['firstBus']!);
    addMilestone("Second Bus", stdDateTime, benchmark['secondBus']!);
    addMilestone("Cabin Crew Onboard", stdDateTime, benchmark['crewOnboard']!);
    addMilestone("Cockpit Crew Onboard", stdDateTime, benchmark['crewOnboard']!);
    addMilestone("Cleaning Start", stdDateTime, benchmark['cleaningStart']!);
    addMilestone("Cleaning Done", stdDateTime, benchmark['cleaningDone']!);
    addMilestone("Boarding Clearance", stdDateTime, benchmark['boardingClearance']!);
    addMilestone("First Passenger", stdDateTime, benchmark['firstPassenger']!);
    addMilestone("Last Passenger", stdDateTime, benchmark['lastPassenger']!);
    addMilestone("Door Closed", stdDateTime, benchmark['doorClosed']!);

    // Arrival milestones
    addMilestone("Aircraft Landed", staDateTime, 0);
    addMilestone("Door Open", staDateTime, benchmark['chocksToDoorOpen']!);
    addMilestone("Last Passenger Disembarked", staDateTime, benchmark['targetDisembarkation']!);
    addMilestone("Cleaning Started (Transit)", staDateTime, benchmark['targetDisembarkation']! + 1);
    addMilestone("Cleaning Completed (Transit)", staDateTime, benchmark['cleaningOutstation']!);
    addMilestone("Door Open in Sharjah", staDateTime, benchmark['chocksToDoorOpen']!);

    return {
      'local': localTimings,
      'utc': utcTimings,
    };
  }
}
