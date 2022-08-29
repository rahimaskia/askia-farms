import 'dart:convert';

class Address {
  final String country;
  final String state;
  final String city;
  final String line1;
  final String? line2;
  Address({
    required this.country,
    required this.state,
    required this.city,
    required this.line1,
    this.line2,
  });

  Address copyWith({
    String? country,
    String? state,
    String? city,
    String? line1,
    String? line2,
  }) {
    return Address(
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'state': state,
      'city': city,
      'line1': line1,
      'line2': line2,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      country: map['country'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      line1: map['line1'] as String,
      line2: map['line2'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => '''
Address(country: $country, state: $state, 
city: $city, line1: $line1, line2: $line2?)''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.country == country &&
        other.state == state &&
        other.city == city &&
        other.line1 == line1 &&
        other.line2 == line2;
  }

  @override
  int get hashCode {
    return country.hashCode ^
        state.hashCode ^
        city.hashCode ^
        line1.hashCode ^
        line2.hashCode;
  }
}
