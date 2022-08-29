import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Mortality {
  final int mortality;
  final String cause;
  final Timestamp date;
  Mortality({
    required this.mortality,
    required this.cause,
    required this.date,
  });

  Mortality copyWith({
    int? mortality,
    String? cause,
    Timestamp? date,
  }) {
    return Mortality(
      mortality: mortality ?? this.mortality,
      cause: cause ?? this.cause,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mortality': mortality,
      'cause': cause,
      'date': date,
    };
  }

  factory Mortality.fromMap(Map<String, dynamic> map) {
    return Mortality(
      mortality: map['mortality'] as int,
      cause: map['cause'] as String,
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Mortality.fromJson(String source) =>
      Mortality.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Mortality(mortality: $mortality, cause: $cause, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mortality &&
        other.mortality == mortality &&
        other.cause == cause &&
        other.date == date;
  }

  @override
  int get hashCode => mortality.hashCode ^ cause.hashCode ^ date.hashCode;
}
