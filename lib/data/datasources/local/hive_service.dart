/// Hive local database service - initializes Hive and registers adapters

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/entities/attendance.dart';
import '../../../domain/entities/face_embedding.dart';
import '../../../domain/entities/leave_request.dart';
import '../../../domain/entities/organization.dart';
import '../../../domain/entities/organization_member.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/user.dart';
import '../../constants/app_constants.dart';

/// Type adapters for Hive
class _UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User(
      id: reader.readString(),
      email: reader.readString(),
      displayName: reader.readString(),
      photoUrl: reader.readString(),
      authProvider: reader.readString(),
      faceEmbeddingEncrypted: reader.readString(),
      faceImageUrl: reader.readString(),
      defaultOrgId: reader.readString(),
      faceVerified: reader.readBool(),
      createdAt: DateTime.parse(reader.readString()),
      updatedAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.email);
    writer.writeString(obj.displayName);
    writer.writeString(obj.photoUrl ?? '');
    writer.writeString(obj.authProvider);
    writer.writeString(obj.faceEmbeddingEncrypted ?? '');
    writer.writeString(obj.faceImageUrl ?? '');
    writer.writeString(obj.defaultOrgId ?? '');
    writer.writeBool(obj.faceVerified);
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.updatedAt.toIso8601String());
  }
}

class _OrganizationAdapter extends TypeAdapter<Organization> {
  @override
  final int typeId = 1;

  @override
  Organization read(BinaryReader reader) {
    return Organization(
      id: reader.readString(),
      name: reader.readString(),
      code: reader.readString(),
      ownerId: reader.readString(),
      settings: {},
      createdAt: DateTime.parse(reader.readString()),
      updatedAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, Organization obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.code);
    writer.writeString(obj.ownerId);
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.updatedAt.toIso8601String());
  }
}

class _AttendanceAdapter extends TypeAdapter<Attendance> {
  @override
  final int typeId = 2;

  @override
  Attendance read(BinaryReader reader) {
    return Attendance(
      id: reader.readString(),
      userId: reader.readString(),
      organizationId: reader.readString(),
      type: AttendanceType.values[reader.readInt()],
      status: AttendanceStatus.values[reader.readInt()],
      timestamp: DateTime.parse(reader.readString()),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      locationName: reader.readString(),
      faceVerified: reader.readBool(),
      faceConfidence: reader.readDouble(),
      faceMatchScore: reader.readDouble(),
      shiftId: reader.readString(),
      notes: reader.readString(),
      approvedBy: reader.readString(),
      approvedAt: reader.readBool()
          ? DateTime.parse(reader.readString())
          : null,
      createdAt: DateTime.parse(reader.readString()),
      syncedAt: reader.readBool()
          ? DateTime.parse(reader.readString())
          : null,
      isSynced: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Attendance obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.userId);
    writer.writeString(obj.organizationId);
    writer.writeInt(obj.type.index);
    writer.writeInt(obj.status.index);
    writer.writeString(obj.timestamp.toIso8601String());
    writer.writeDouble(obj.latitude ?? 0.0);
    writer.writeDouble(obj.longitude ?? 0.0);
    writer.writeString(obj.locationName ?? '');
    writer.writeBool(obj.faceVerified);
    writer.writeDouble(obj.faceConfidence ?? 0.0);
    writer.writeDouble(obj.faceMatchScore ?? 0.0);
    writer.writeString(obj.shiftId ?? '');
    writer.writeString(obj.notes ?? '');
    writer.writeString(obj.approvedBy ?? '');
    writer.writeBool(obj.approvedAt != null);
    if (obj.approvedAt != null) writer.writeString(obj.approvedAt!.toIso8601String());
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeBool(obj.syncedAt != null);
    if (obj.syncedAt != null) writer.writeString(obj.syncedAt!.toIso8601String());
    writer.writeBool(obj.isSynced);
  }
}

class _ShiftAdapter extends TypeAdapter<Shift> {
  @override
  final int typeId = 3;

  @override
  Shift read(BinaryReader reader) {
    return Shift(
      id: reader.readString(),
      organizationId: reader.readString(),
      name: reader.readString(),
      startTime: reader.readString(),
      endTime: reader.readString(),
      gracePeriodMinutes: reader.readInt(),
      daysOfWeek: reader.readList().cast<int>(),
      isOvernight: reader.readBool(),
      color: reader.readString(),
      isDefault: reader.readBool(),
      createdAt: DateTime.parse(reader.readString()),
      updatedAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, Shift obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.organizationId);
    writer.writeString(obj.name);
    writer.writeString(obj.startTime);
    writer.writeString(obj.endTime);
    writer.writeInt(obj.gracePeriodMinutes);
    writer.writeList(obj.daysOfWeek);
    writer.writeBool(obj.isOvernight);
    writer.writeString(obj.color);
    writer.writeBool(obj.isDefault);
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.updatedAt.toIso8601String());
  }
}

class _LeaveRequestAdapter extends TypeAdapter<LeaveRequest> {
  @override
  final int typeId = 4;

  @override
  LeaveRequest read(BinaryReader reader) {
    return LeaveRequest(
      id: reader.readString(),
      organizationId: reader.readString(),
      userId: reader.readString(),
      type: LeaveType.values[reader.readInt()],
      startDate: DateTime.parse(reader.readString()),
      endDate: DateTime.parse(reader.readString()),
      reason: reader.readString(),
      attachmentUrls: reader.readList().cast<String>(),
      status: LeaveRequestStatus.values[reader.readInt()],
      reviewedBy: reader.readString(),
      reviewedAt: reader.readBool()
          ? DateTime.parse(reader.readString())
          : null,
      reviewNotes: reader.readString(),
      createdAt: DateTime.parse(reader.readString()),
      updatedAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, LeaveRequest obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.organizationId);
    writer.writeString(obj.userId);
    writer.writeInt(obj.type.index);
    writer.writeString(obj.startDate.toIso8601String());
    writer.writeString(obj.endDate.toIso8601String());
    writer.writeString(obj.reason);
    writer.writeList(obj.attachmentUrls);
    writer.writeInt(obj.status.index);
    writer.writeString(obj.reviewedBy ?? '');
    writer.writeBool(obj.reviewedAt != null);
    if (obj.reviewedAt != null) writer.writeString(obj.reviewedAt!.toIso8601String());
    writer.writeString(obj.reviewNotes ?? '');
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.updatedAt.toIso8601String());
  }
}

class _OrganizationMemberAdapter extends TypeAdapter<OrganizationMember> {
  @override
  final int typeId = 5;

  @override
  OrganizationMember read(BinaryReader reader) {
    return OrganizationMember(
      organizationId: reader.readString(),
      userId: reader.readString(),
      role: MemberRole.values[reader.readInt()],
      employeeId: reader.readString(),
      department: reader.readString(),
      position: reader.readString(),
      status: MemberStatus.values[reader.readInt()],
      joinDate: DateTime.parse(reader.readString()),
      faceVerified: reader.readBool(),
      notificationTokens: reader.readList().cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationMember obj) {
    writer.writeString(obj.organizationId);
    writer.writeString(obj.userId);
    writer.writeInt(obj.role.index);
    writer.writeString(obj.employeeId);
    writer.writeString(obj.department ?? '');
    writer.writeString(obj.position ?? '');
    writer.writeInt(obj.status.index);
    writer.writeString(obj.joinDate.toIso8601String());
    writer.writeBool(obj.faceVerified);
    writer.writeList(obj.notificationTokens);
  }
}

class _FaceEmbeddingAdapter extends TypeAdapter<FaceEmbedding> {
  @override
  final int typeId = 6;

  @override
  FaceEmbedding read(BinaryReader reader) {
    return FaceEmbedding(
      userId: reader.readString(),
      vector: reader.readList().cast<double>(),
      encryptedVector: reader.readString(),
      sampleCount: reader.readInt(),
      createdAt: DateTime.parse(reader.readString()),
      updatedAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, FaceEmbedding obj) {
    writer.writeString(obj.userId);
    writer.writeList(obj.vector);
    writer.writeString(obj.encryptedVector);
    writer.writeInt(obj.sampleCount);
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.updatedAt.toIso8601String());
  }
}

/// Hive service - manages box initialization and access
class HiveService {
  HiveService._();
  static final HiveService _instance = HiveService._();
  factory HiveService() => _instance;

  bool _initialized = false;

  /// Initialize Hive with all adapters and boxes
  Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    // Register adapters
    Hive.registerAdapter(_UserAdapter());
    Hive.registerAdapter(_OrganizationAdapter());
    Hive.registerAdapter(_AttendanceAdapter());
    Hive.registerAdapter(_ShiftAdapter());
    Hive.registerAdapter(_LeaveRequestAdapter());
    Hive.registerAdapter(_OrganizationMemberAdapter());
    Hive.registerAdapter(_FaceEmbeddingAdapter());

    // Open boxes
    await Hive.openBox<User>(AppConstants.boxAuth);
    await Hive.openBox<User>(AppConstants.boxUser);
    await Hive.openBox<Organization>(AppConstants.boxOrganization);
    await Hive.openBox<Attendance>(AppConstants.boxAttendance);
    await Hive.openBox<Shift>(AppConstants.boxShift);
    await Hive.openBox<LeaveRequest>(AppConstants.boxLeave);
    await Hive.openBox<OrganizationMember>(AppConstants.boxFaceEmbedding); // reuse box name pattern
    await Hive.openBox<FaceEmbedding>(AppConstants.boxFaceEmbedding);

    _initialized = true;
  }

  // --- Box accessors ---

  Box<User> get authBox => Hive.box<User>(AppConstants.boxAuth);
  Box<User> get userBox => Hive.box<User>(AppConstants.boxUser);
  Box<Organization> get organizationBox =>
      Hive.box<Organization>(AppConstants.boxOrganization);
  Box<Attendance> get attendanceBox =>
      Hive.box<Attendance>(AppConstants.boxAttendance);
  Box<Shift> get shiftBox => Hive.box<Shift>(AppConstants.boxShift);
  Box<LeaveRequest> get leaveBox => Hive.box<LeaveRequest>(AppConstants.boxLeave);
  Box<OrganizationMember> get memberBox =>
      Hive.box<OrganizationMember>('member_box');
  Box<FaceEmbedding> get faceEmbeddingBox =>
      Hive.box<FaceEmbedding>(AppConstants.boxFaceEmbedding);
}