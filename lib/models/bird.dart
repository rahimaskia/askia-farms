import 'dart:convert';

class Bird {
  final int tag;
  final String type;
  Bird({
    required this.tag,
    required this.type,
  });

  Bird copyWith({
    int? tag,
    String? type,
  }) {
    return Bird(
      tag: tag ?? this.tag,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tag': tag,
      'type': type,
    };
  }

  factory Bird.fromMap(Map<String, dynamic> map) {
    return Bird(
      tag: map['tag'] as int,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Bird.fromJson(String source) =>
      Bird.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Bird(tag: $tag, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bird && other.tag == tag && other.type == type;
  }

  @override
  int get hashCode => tag.hashCode ^ type.hashCode;
}
