/// Leave request entity

enum LeaveType { sick, annual, emergency, wfh, custom }
enum LeaveRequestStatus { pending, approved, rejected, cancelled }

class LeaveRequest {
  final String id;
  final String organizationId;
  final String userId;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final List<String> attachmentUrls;
  final LeaveRequestStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LeaveRequest({
    required this.id,
    required this.organizationId,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.attachmentUrls = const [],
    this.status = LeaveRequestStatus.pending,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  LeaveRequest copyWith({
    String? id,
    String? organizationId,
    String? userId,
    LeaveType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    List<String>? attachmentUrls,
    LeaveRequestStatus? status,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organizationId': organizationId,
    'userId': userId,
    'type': type.name,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'reason': reason,
    'attachmentUrls': attachmentUrls,
    'status': status.name,
    'reviewedBy': reviewedBy,
    'reviewedAt': reviewedAt?.toIso8601String(),
    'reviewNotes': reviewNotes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
    id: json['id'] as String,
    organizationId: json['organizationId'] as String,
    userId: json['userId'] as String,
    type: LeaveType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => LeaveType.custom,
    ),
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    reason: json['reason'] as String,
    attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
    status: LeaveRequestStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => LeaveRequestStatus.pending,
    ),
    reviewedBy: json['reviewedBy'] as String?,
    reviewedAt: json['reviewedAt'] != null
        ? DateTime.parse(json['reviewedAt'] as String)
        : null,
    reviewNotes: json['reviewNotes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaveRequest && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get typeDisplayName {
    switch (type) {
      case LeaveType.sick: return 'Sick Leave';
      case LeaveType.annual: return 'Annual Leave';
      case LeaveType.emergency: return 'Emergency / Permit';
      case LeaveType.wfh: return 'Work From Home';
      case LeaveType.custom: return 'Custom';
    }
  }
}