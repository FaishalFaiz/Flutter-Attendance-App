/// Core application constants for Attendance App SaaS Platform

abstract class AppConstants {
  // --- App Info ---
  static const String appName = 'Attendance App';
  static const String appVersion = '1.0.0+1';

  // --- Hive Box Names ---
  static const String boxAuth = 'auth_box';
  static const String boxUser = 'user_box';
  static const String boxOrganization = 'organization_box';
  static const String boxAttendance = 'attendance_box';
  static const String boxShift = 'shift_box';
  static const String boxLeave = 'leave_box';
  static const String boxFaceEmbedding = 'face_embedding_box';

  // --- Face Verification ---
  static const double defaultFaceThreshold = 0.75;
  static const int maxFaceVerificationRetries = 3;
  static const int faceRegistrationAngles = 5; // front, left, right, up, down

  // --- Invite Code ---
  static const int inviteCodeLength = 6;

  // --- API Endpoints ---
  static const String firebaseStorageBasePath = 'attendance_app';

  // --- Storage Paths ---
  static String faceImagePath(String orgId, String userId) =>
      'organizations/$orgId/faces/$userId/face.jpg';

  static String profileImagePath(String userId) =>
      'users/$userId/profile.jpg';

  static String leaveAttachmentPath(String orgId, String requestId) =>
      'organizations/$orgId/leave/$requestId/';

  // --- Session Keys ---
  static const String sessionKeyUserId = 'user_id';
  static const String sessionKeyToken = 'auth_token';
  static const String sessionKeyRefreshToken = 'refresh_token';
  static const String sessionKeyLastOrgId = 'last_org_id';

  // --- Status ---
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusActive = 'active';
  static const String statusSuspended = 'suspended';

  // --- Attendance Types ---
  static const String typeCheckIn = 'check_in';
  static const String typeCheckOut = 'check_out';
  static const String typeBreakStart = 'break_start';
  static const String typeBreakEnd = 'break_end';
  static const String typeOvertimeStart = 'overtime_start';
  static const String typeOvertimeEnd = 'overtime_end';
  static const String typeLeave = 'leave';

  // --- Member Roles ---
  static const String roleOwner = 'owner';
  static const String roleAdmin = 'admin';
  static const String roleMember = 'member';

  // --- Leave Types ---
  static const String leaveSick = 'sick';
  static const String leaveAnnual = 'annual';
  static const String leaveEmergency = 'emergency';
  static const String leaveWFH = 'wfh';
  static const String leaveCustom = 'custom';

  // --- Encryption ---
  static const String encryptionKey = 'attendance_app_encryption_key_2024'; // 32 chars for AES-256
}