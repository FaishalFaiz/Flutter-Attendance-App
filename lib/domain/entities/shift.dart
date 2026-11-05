/// Shift entity - work schedule definition

class Shift {
  final String id;
  final String organizationId;
  final String name;
  final String startTime; // HH:mm
  final String endTime; // HH:mm
  final int gracePeriodMinutes;
  final List<int> daysOfWeek; // 1=Monday ... 7=Sunday
  final bool isOvernight;
  final String color;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Shift({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.gracePeriodMinutes = 15,
    required this.daysOfWeek,
    this.isOvernight = false,
    this.color = '#2563EB',
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Shift copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? startTime,
    String? endTime,
    int? gracePeriodMinutes,
    List<int>? daysOfWeek,
    bool? isOvernight,
    String? color,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Shift(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      gracePeriodMinutes: gracePeriodMinutes ?? this.gracePeriodMinutes,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isOvernight: isOvernight ?? this.isOvernight,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organizationId': organizationId,
    'name': name,
    'startTime': startTime,
    'endTime': endTime,
    'gracePeriodMinutes': gracePeriodMinutes,
    'daysOfWeek': daysOfWeek,
    'isOvernight': isOvernight,
    'color': color,
    'isDefault': isDefault,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    id: json['id'] as String,
    organizationId: json['organizationId'] as String,
    name: json['name'] as String,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    gracePeriodMinutes: json['gracePeriodMinutes'] as int? ?? 15,
    daysOfWeek: List<int>.from(json['daysOfWeek'] ?? [1, 2, 3, 4, 5]),
    isOvernight: json['isOvernight'] as bool? ?? false,
    color: json['color'] as String? ?? '#2563EB',
    isDefault: json['isDefault'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Shift && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}