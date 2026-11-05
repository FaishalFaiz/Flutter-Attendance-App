/// Attendance record entity

enum AttendanceType {
  checkIn,
  checkOut,
  breakStart,
  breakEnd,
  overtimeStart,
  overtimeEnd,
  leave,
}

enum AttendanceStatus {
  onTime,
  late,
  earlyLeave,
  approved,
  pending,
  rejected,
}

class Attendance {
  final String id;
  final String userId;
  final String organizationId;
  final AttendanceType type;
  final AttendanceStatus status;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final bool faceVerified;
  final double? faceConfidence;
  final double? faceMatchScore;
  final String? shiftId;
  final String? notes;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime? syncedAt; // for offline sync tracking
  final bool isSynced;

  const Attendance({
    required this.id,
    required this.userId,
    required this.organizationId,
    required this.type,
    required this.status,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.locationName,
    this.faceVerified = false,
    this.faceConfidence,
    this.faceMatchScore,
    this.shiftId,
    this.notes,
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
    this.syncedAt,
    this.isSynced = false,
  });

  Attendance copyWith({
    String? id,
    String? userId,
    String? organizationId,
    AttendanceType? type,
    AttendanceStatus? status,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? locationName,
    bool? faceVerified,
    double? faceConfidence,
    double? faceMatchScore,
    String? shiftId,
    String? notes,
    String? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? syncedAt,
    bool? isSynced,
  }) {
    return Attendance(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      faceVerified: faceVerified ?? this.faceVerified,
      faceConfidence: faceConfidence ?? this.faceConfidence,
      faceMatchScore: faceMatchScore ?? this.faceMatchScore,
      shiftId: shiftId ?? this.shiftId,
      notes: notes ?? this.notes,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'organizationId': organizationId,
    'type': type.name,
    'status': status.name,
    'timestamp': timestamp.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'locationName': locationName,
    'faceVerified': faceVerified,
    'faceConfidence': faceConfidence,
    'faceMatchScore': faceMatchScore,
    'shiftId': shiftId,
    'notes': notes,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'syncedAt': syncedAt?.toIso8601String(),
    'isSynced': isSynced,
  };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json['id'] as String,
    userId: json['userId'] as String,
    organizationId: json['organizationId'] as String,
    type: AttendanceType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AttendanceType.checkIn,
    ),
    status: AttendanceStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => AttendanceStatus.pending,
    ),
    timestamp: DateTime.parse(json['timestamp'] as String),
    latitude: json['latitude'] as double?,
    longitude: json['longitude'] as double?,
    locationName: json['locationName'] as String?,
    faceVerified: json['faceVerified'] as bool? ?? false,
    faceConfidence: json['faceConfidence'] as double?,
    faceMatchScore: json['faceMatchScore'] as double?,
    shiftId: json['shiftId'] as String?,
    notes: json['notes'] as String?,
    approvedBy: json['approvedBy'] as String?,
    approvedAt: json['approvedAt'] != null
        ? DateTime.parse(json['approvedAt'] as String)
        : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    syncedAt: json['syncedAt'] != null
        ? DateTime.parse(json['syncedAt'] as String)
        : null,
    isSynced: json['isSynced'] as bool? ?? false,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attendance && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get typeDisplayName {
    switch (type) {
      case AttendanceType.checkIn: return 'Check In';
      case AttendanceType.checkOut: return 'Check Out';
      case AttendanceType.breakStart: return 'Break Start';
      case AttendanceType.breakEnd: return 'Break End';
      case AttendanceType.overtimeStart: return 'Overtime Start';
      case AttendanceType.overtimeEnd: return 'Overtime End';
      case AttendanceType.leave: return 'Leave';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case AttendanceStatus.onTime: return 'On Time';
      case AttendanceStatus.late: return 'Late';
      case AttendanceStatus.earlyLeave: return 'Early Leave';
      case AttendanceStatus.approved: return 'Approved';
      case AttendanceStatus.pending: return 'Pending';
      case AttendanceStatus.rejected: return 'Rejected';
    }
  }
}