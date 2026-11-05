/// Organization member entity - links a user to an organization

enum MemberRole { owner, admin, member }
enum MemberStatus { active, invited, suspended }

class OrganizationMember {
  final String organizationId;
  final String userId;
  final MemberRole role;
  final String employeeId; // badge number, unique per org
  final String? department;
  final String? position;
  final MemberStatus status;
  final DateTime joinDate;
  final bool faceVerified;
  final List<String> notificationTokens;

  const OrganizationMember({
    required this.organizationId,
    required this.userId,
    required this.role,
    required this.employeeId,
    this.department,
    this.position,
    this.status = MemberStatus.active,
    required this.joinDate,
    this.faceVerified = false,
    this.notificationTokens = const [],
  });

  OrganizationMember copyWith({
    String? organizationId,
    String? userId,
    MemberRole? role,
    String? employeeId,
    String? department,
    String? position,
    MemberStatus? status,
    DateTime? joinDate,
    bool? faceVerified,
    List<String>? notificationTokens,
  }) {
    return OrganizationMember(
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      position: position ?? this.position,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      faceVerified: faceVerified ?? this.faceVerified,
      notificationTokens: notificationTokens ?? this.notificationTokens,
    );
  }

  Map<String, dynamic> toJson() => {
    'organizationId': organizationId,
    'userId': userId,
    'role': role.name,
    'employeeId': employeeId,
    'department': department,
    'position': position,
    'status': status.name,
    'joinDate': joinDate.toIso8601String(),
    'faceVerified': faceVerified,
    'notificationTokens': notificationTokens,
  };

  factory OrganizationMember.fromJson(Map<String, dynamic> json) =>
      OrganizationMember(
    organizationId: json['organizationId'] as String,
    userId: json['userId'] as String,
    role: MemberRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => MemberRole.member,
    ),
    employeeId: json['employeeId'] as String,
    department: json['department'] as String?,
    position: json['position'] as String?,
    status: MemberStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => MemberStatus.active,
    ),
    joinDate: DateTime.parse(json['joinDate'] as String),
    faceVerified: json['faceVerified'] as bool? ?? false,
    notificationTokens: List<String>.from(json['notificationTokens'] ?? []),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationMember &&
          runtimeType == other.runtimeType &&
          organizationId == other.organizationId &&
          userId == other.userId;

  @override
  int get hashCode => organizationId.hashCode ^ userId.hashCode;

  String get roleDisplayName {
    switch (role) {
      case MemberRole.owner: return 'Owner';
      case MemberRole.admin: return 'Admin';
      case MemberRole.member: return 'Member';
    }
  }
}