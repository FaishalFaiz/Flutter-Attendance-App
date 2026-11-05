/// Organization entity - represents a company/room

class Organization {
  final String id;
  final String name;
  final String code; // 6-char invite code
  final String ownerId;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Organization({
    required this.id,
    required this.name,
    required this.code,
    required this.ownerId,
    this.settings = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Organization copyWith({
    String? id,
    String? name,
    String? code,
    String? ownerId,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      ownerId: ownerId ?? this.ownerId,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'ownerId': ownerId,
    'settings': settings,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    ownerId: json['ownerId'] as String,
    settings: Map<String, dynamic>.from(json['settings'] ?? {}),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Organization && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}