import 'dart:convert';

class FlightReport {
  final String id;
  final DateTime date;
  final String flightNo;
  final String sector;
  final String acType; // A320 or A321
  final String acReg;
  final int paxCount;
  final String departureTimeLocal;
  final String arrivalTimeLocal;
  final int timezoneOffset; // e.g. 4 for SHJ
  final String specials;
  final Map<String, String> calculatedTimingsLocal;
  final Map<String, String> calculatedTimingsUtc;
  final String forwardSeals;
  final String aftSeals;
  final String delayOutbound;
  final String delayInbound;
  final String cabinDefects;

  FlightReport({
    required this.id,
    required this.date,
    required this.flightNo,
    required this.sector,
    required this.acType,
    required this.acReg,
    required this.paxCount,
    required this.departureTimeLocal,
    required this.arrivalTimeLocal,
    required this.timezoneOffset,
    required this.specials,
    required this.calculatedTimingsLocal,
    required this.calculatedTimingsUtc,
    this.forwardSeals = '',
    this.aftSeals = '',
    this.delayOutbound = '',
    this.delayInbound = '',
    this.cabinDefects = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'flightNo': flightNo,
      'sector': sector,
      'acType': acType,
      'acReg': acReg,
      'paxCount': paxCount,
      'departureTimeLocal': departureTimeLocal,
      'arrivalTimeLocal': arrivalTimeLocal,
      'timezoneOffset': timezoneOffset,
      'specials': specials,
      'calculatedTimingsLocal': json.encode(calculatedTimingsLocal),
      'calculatedTimingsUtc': json.encode(calculatedTimingsUtc),
      'forwardSeals': forwardSeals,
      'aftSeals': aftSeals,
      'delayOutbound': delayOutbound,
      'delayInbound': delayInbound,
      'cabinDefects': cabinDefects,
    };
  }

  factory FlightReport.fromMap(Map<String, dynamic> map) {
    return FlightReport(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      flightNo: map['flightNo'] ?? '',
      sector: map['sector'] ?? '',
      acType: map['acType'] ?? '',
      acReg: map['acReg'] ?? '',
      paxCount: map['paxCount'] ?? 0,
      departureTimeLocal: map['departureTimeLocal'] ?? '',
      arrivalTimeLocal: map['arrivalTimeLocal'] ?? '',
      timezoneOffset: map['timezoneOffset'] ?? 0,
      specials: map['specials'] ?? '',
      calculatedTimingsLocal: Map<String, String>.from(json.decode(map['calculatedTimingsLocal'] ?? '{}')),
      calculatedTimingsUtc: Map<String, String>.from(json.decode(map['calculatedTimingsUtc'] ?? '{}')),
      forwardSeals: map['forwardSeals'] ?? '',
      aftSeals: map['aftSeals'] ?? '',
      delayOutbound: map['delayOutbound'] ?? '',
      delayInbound: map['delayInbound'] ?? '',
      cabinDefects: map['cabinDefects'] ?? '',
    );
  }
}
