import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class EggCollection {
  final int numberOfEggs;
  final int broken;
  final Timestamp date;
  final String time;
  EggCollection({
    required this.numberOfEggs,
    required this.broken,
    required this.date,
    required this.time,
  });

  EggCollection copyWith({
    int? numberOfEggs,
    int? broken,
    Timestamp? date,
    String? time,
  }) {
    return EggCollection(
      numberOfEggs: numberOfEggs ?? this.numberOfEggs,
      broken: broken ?? this.broken,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'numberOfEggs': numberOfEggs,
      'broken': broken,
      'date': date,
      'time': time,
    };
  }

  factory EggCollection.fromMap(Map<String, dynamic> map) {
    return EggCollection(
      numberOfEggs: map['numberOfEggs'] as int,
      broken: map['broken'] as int,
      date: map['date'] as Timestamp,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EggCollection.fromJson(String source) =>
      EggCollection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => '''
      EggCollection(numberOfEggs: $numberOfEggs,
      broken: $broken, date: $date, time: $time)
    ''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EggCollection &&
        other.numberOfEggs == numberOfEggs &&
        other.broken == broken &&
        other.time == time &&
        other.date == date;
  }

  @override
  int get hashCode =>
      numberOfEggs.hashCode ^ broken.hashCode ^ date.hashCode ^ time.hashCode;

  int get total => numberOfEggs - broken;
}
