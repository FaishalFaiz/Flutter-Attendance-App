/// Remote datasource for Firestore operations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../domain/entities/attendance.dart';
import '../../../../domain/entities/leave_request.dart';
import '../../../../domain/entities/organization.dart';
import '../../../../domain/entities/organization_member.dart';
import '../../../../domain/entities/shift.dart';
import '../../../core/constants/app_constants.dart';

class FirestoreRemoteDataSource {
  FirestoreRemoteDataSource._();
  static final FirestoreRemoteDataSource _instance = FirestoreRemoteDataSource._();
  factory FirestoreRemoteDataSource() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  // ============ Organizations ============

  Future<List<Organization>> getMyOrganizations() async {
    try {
      // Query organizations where user is a member
      final memberQuery = await _firestore
          .collectionGroup('members')
          .where('userId', isEqualTo: _currentUserId)
          .get();

      final orgIds = memberQuery.docs.map((doc) {
        // doc reference path: organizations/{orgId}/members/{userId}
        return doc.reference.parent.parent?.id;
      }).whereType<String>().toSet();

      final organizations = <Organization>[];
      for (final orgId in orgIds) {
        final doc = await _firestore.collection('organizations').doc(orgId).get();
        if (doc.exists) {
          organizations.add(Organization.fromJson(doc.data()!));
        }
      }
      organizations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return organizations;
    } catch (e) {
      throw FirestoreException(message: 'Failed to get organizations: $e');
    }
  }

  Future<Organization> createOrganization({
    required String name,
    required String ownerId,
  }) async {
    try {
      final code = _generateInviteCode();
      final now = DateTime.now();
      final org = Organization(
        id: _firestore.collection('organizations').doc().id,
        name: name,
        code: code,
        ownerId: ownerId,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection('organizations')
          .doc(org.id)
          .set(org.toJson());

      // Create owner membership
      await _firestore
          .collection('organizations')
          .doc(org.id)
          .collection('members')
          .doc(ownerId)
          .set({
        'organizationId': org.id,
        'userId': ownerId,
        'role': 'owner',
        'employeeId': 'EMP001',
        'department': '',
        'position': '',
        'status': 'active',
        'joinDate': now.toIso8601String(),
        'faceVerified': false,
        'notificationTokens': [],
      });

      // Create default settings
      await _firestore
          .collection('organizations')
          .doc(org.id)
          .collection('settings')
          .doc('default')
          .set({
        'faceThreshold': AppConstants.defaultFaceThreshold,
        'requireFaceForCheckIn': true,
        'requireFaceForCheckOut': true,
        'allowManualLocation': false,
        'maxBreakMinutes': 60,
        'createdAt': now.toIso8601String(),
      });

      return org;
    } catch (e) {
      if (e is FirestoreException) rethrow;
      throw FirestoreException(message: 'Failed to create organization: $e');
    }
  }

  Future<Organization> joinOrganization({
    required String inviteCode,
    required String userId,
  }) async {
    try {
      // Find organization by code
      final query = await _firestore
          .collection('organizations')
          .where('code', isEqualTo: inviteCode)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw NotFoundException(message: 'Invalid invite code.');
      }

      final orgDoc = query.docs.first;
      final org = Organization.fromJson(orgDoc.data());

      // Check if user is already a member
      final memberDoc = await _firestore
          .collection('organizations')
          .doc(org.id)
          .collection('members')
          .doc(userId)
          .get();

      if (memberDoc.exists) {
        throw ValidationException(message: 'You are already a member of this organization.');
      }

      // Add member
      final now = DateTime.now();
      await _firestore
          .collection('organizations')
          .doc(org.id)
          .collection('members')
          .doc(userId)
          .set({
        'organizationId': org.id,
        'userId': userId,
        'role': 'member',
        'employeeId': 'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(-4)}',
        'department': '',
        'position': '',
        'status': 'active',
        'joinDate': now.toIso8601String(),
        'faceVerified': false,
        'notificationTokens': [],
      });

      return org;
    } catch (e) {
      if (e is AppException) rethrow;
      throw FirestoreException(message: 'Failed to join organization: $e');
    }
  }

  Future<Organization> getOrganization(String orgId) async {
    try {
      final doc = await _firestore.collection('organizations').doc(orgId).get();
      if (!doc.exists) {
        throw NotFoundException(message: 'Organization not found.');
      }
      return Organization.fromJson(doc.data()!);
    } catch (e) {
      if (e is AppException) rethrow;
      throw FirestoreException(message: 'Failed to get organization: $e');
    }
  }

  Future<void> updateOrganizationSettings({
    required String orgId,
    required Map<String, dynamic> settings,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(orgId)
          .update({'settings': settings, 'updatedAt': DateTime.now().toIso8601String()});
    } catch (e) {
      throw FirestoreException(message: 'Failed to update organization settings: $e');
    }
  }

  Future<List<OrganizationMember>> getMembers(String orgId) async {
    try {
      final query = await _firestore
          .collection('organizations')
          .doc(orgId)
          .collection('members')
          .get();

      return query.docs.map((doc) => OrganizationMember.fromJson(doc.data())).toList();
    } catch (e) {
      throw FirestoreException(message: 'Failed to get members: $e');
    }
  }

  Future<void> inviteMember({
    required String orgId,
    required String userId,
    required String role,
    required String employeeId,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(orgId)
          .collection('members')
          .doc(userId)
          .set({
        'organizationId': orgId,
        'userId': userId,
        'role': role,
        'employeeId': employeeId,
        'department': '',
        'position': '',
        'status': 'active',
        'joinDate': DateTime.now().toIso8601String(),
        'faceVerified': false,
        'notificationTokens': [],
      });
    } catch (e) {
      throw FirestoreException(message: 'Failed to invite member: $e');
    }
  }

  Future<void> updateMemberRole({
    required String orgId,
    required String userId,
    required String role,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(orgId)
          .collection('members')
          .doc(userId)
          .update({'role': role});
    } catch (e) {
      throw FirestoreException(message: 'Failed to update member role: $e');
    }
  }

  Future<void> removeMember({
    required String orgId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(orgId)
          .collection('members')
          .doc(userId)
          .delete();
    } catch (e) {
      throw FirestoreException(message: 'Failed to remove member: $e');
    }
  }

  Future<void> setMemberStatus({
    required String orgId,
    required String userId,
    required String status,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(orgId)
          .collection('members')
          .doc(userId)
          .update({'status': status});
    } catch (e) {
      throw FirestoreException(message: 'Failed to update member status: $e');
    }
  }

  Stream<List<Organization>> watchMyOrganizations() {
    return _firestore
        .collectionGroup('members')
        .where('userId', isEqualTo: _currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      final orgIds = snapshot.docs.map((doc) {
        return doc.reference.parent.parent?.id;
      }).whereType<String>().toSet();

      final organizations = <Organization>[];
      for (final orgId in orgIds) {
        final doc = await _firestore.collection('organizations').doc(orgId).get();
        if (doc.exists) {
          organizations.add(Organization.fromJson(doc.data()!));
        }
      }
      organizations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return organizations;
    });
  }

  Stream<List<OrganizationMember>> watchMembers(String orgId) {
    return _firestore
        .collection('organizations')
        .doc(orgId)
        .collection('members')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrganizationMember.fromJson(doc.data()))
            .toList());
  }

  // ============ Shifts ============

  Future<List<Shift>> getShifts(String organizationId) async {
    try {
      final query = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('shifts')
          .get();

      return query.docs.map((doc) => Shift.fromJson(doc.data())).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      throw FirestoreException(message: 'Failed to get shifts: $e');
    }
  }

  Future<Shift> createShift({
    required String organizationId,
    required String name,
    required String startTime,
    required String endTime,
    required List<int> daysOfWeek,
    int gracePeriodMinutes = 15,
    bool isOvernight = false,
    String color = '#2563EB',
    bool isDefault = false,
  }) async {
    try {
      final now = DateTime.now();
      final shift = Shift(
        id: _firestore
            .collection('organizations')
            .doc(organizationId)
            .collection('shifts')
            .doc()
            .id,
        organizationId: organizationId,
        name: name,
        startTime: startTime,
        endTime: endTime,
        gracePeriodMinutes: gracePeriodMinutes,
        daysOfWeek: daysOfWeek,
        isOvernight: isOvernight,
        color: color,
        isDefault: isDefault,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('shifts')
          .doc(shift.id)
          .set(shift.toJson());

      return shift;
    } catch (e) {
      throw FirestoreException(message: 'Failed to create shift: $e');
    }
  }

  Future<void> updateShift({
    required String shiftId,
    required String organizationId,
    String? name,
    String? startTime,
    String? endTime,
    List<int>? daysOfWeek,
    int? gracePeriodMinutes,
    bool? isOvernight,
    String? color,
    bool? isDefault,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('shifts')
          .doc(shiftId)
          .update({
        if (name != null) 'name': name,
        if (startTime != null) 'startTime': startTime,
        if (endTime != null) 'endTime': endTime,
        if (daysOfWeek != null) 'daysOfWeek': daysOfWeek,
        if (gracePeriodMinutes != null) 'gracePeriodMinutes': gracePeriodMinutes,
        if (isOvernight != null) 'isOvernight': isOvernight,
        if (color != null) 'color': color,
        if (isDefault != null) 'isDefault': isDefault,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw FirestoreException(message: 'Failed to update shift: $e');
    }
  }

  Future<void> deleteShift({
    required String shiftId,
    required String organizationId,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('shifts')
          .doc(shiftId)
          .delete();
    } catch (e) {
      throw FirestoreException(message: 'Failed to delete shift: $e');
    }
  }

  Future<Shift?> getDefaultShift(String organizationId) async {
    try {
      final query = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('shifts')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      return Shift.fromJson(query.docs.first.data());
    } catch (e) {
      throw FirestoreException(message: 'Failed to get default shift: $e');
    }
  }

  Stream<List<Shift>> watchShifts(String organizationId) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('shifts')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Shift.fromJson(doc.data()))
            .toList());
  }

  // ============ Attendance ============

  Future<Attendance> createAttendanceRecord({
    required String userId,
    required String organizationId,
    required AttendanceType type,
    required AttendanceStatus status,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required String locationName,
    required bool faceVerified,
    required double faceConfidence,
    required double faceMatchScore,
    String? shiftId,
    String? notes,
  }) async {
    try {
      final id = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('attendance')
          .doc()
          .id;

      final now = DateTime.now();
      final record = Attendance(
        id: id,
        userId: userId,
        organizationId: organizationId,
        type: type,
        status: status,
        timestamp: timestamp,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        faceVerified: faceVerified,
        faceConfidence: faceConfidence,
        faceMatchScore: faceMatchScore,
        shiftId: shiftId,
        notes: notes,
        createdAt: now,
        isSynced: true,
      );

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('attendance')
          .doc(id)
          .set(record.toJson());

      return record;
    } catch (e) {
      throw FirestoreException(message: 'Failed to create attendance record: $e');
    }
  }

  Future<List<Attendance>> getAttendanceHistory({
    required String organizationId,
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true);

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Attendance.fromJson(doc.data())).toList();
    } catch (e) {
      throw FirestoreException(message: 'Failed to get attendance history: $e');
    }
  }

  Future<List<Attendance>> getOrganizationAttendance({
    required String organizationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('attendance')
          .orderBy('timestamp', descending: true);

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Attendance.fromJson(doc.data())).toList();
    } catch (e) {
      throw FirestoreException(message: 'Failed to get organization attendance: $e');
    }
  }

  Future<void> approveAttendance({
    required String attendanceId,
    required String organizationId,
    required bool approved,
    required String approvedBy,
    String? notes,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('attendance')
          .doc(attendanceId)
          .update({
        'approvedBy': approvedBy,
        'approvedAt': DateTime.now().toIso8601String(),
        'status': approved ? 'approved' : 'rejected',
        if (notes != null) 'notes': notes,
      });
    } catch (e) {
      throw FirestoreException(message: 'Failed to approve attendance: $e');
    }
  }

  Stream<List<Attendance>> watchAttendance(String organizationId) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('attendance')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Attendance.fromJson(doc.data()))
            .toList());
  }

  // ============ Leave Requests ============

  Future<LeaveRequest> createLeaveRequest({
    required String organizationId,
    required String userId,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    List<String> attachmentUrls = const [],
  }) async {
    try {
      final id = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leaveRequests')
          .doc()
          .id;

      final now = DateTime.now();
      final request = LeaveRequest(
        id: id,
        organizationId: organizationId,
        userId: userId,
        type: LeaveType.values.firstWhere(
          (e) => e.name == type,
          orElse: () => LeaveType.custom,
        ),
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        attachmentUrls: attachmentUrls,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leaveRequests')
          .doc(id)
          .set(request.toJson());

      return request;
    } catch (e) {
      throw FirestoreException(message: 'Failed to create leave request: $e');
    }
  }

  Future<List<LeaveRequest>> getLeaveRequests({
    required String organizationId,
    String? userId,
  }) async {
    try {
      var query = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leaveRequests')
          .orderBy('createdAt', descending: true);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => LeaveRequest.fromJson(doc.data())).toList();
    } catch (e) {
      throw FirestoreException(message: 'Failed to get leave requests: $e');
    }
  }

  Future<void> reviewLeaveRequest({
    required String leaveRequestId,
    required String organizationId,
    required bool approved,
    required String reviewedBy,
    String? notes,
  }) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leaveRequests')
          .doc(leaveRequestId)
          .update({
        'status': approved ? 'approved' : 'rejected',
        'reviewedBy': reviewedBy,
        'reviewedAt': DateTime.now().toIso8601String(),
        'reviewNotes': notes,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw FirestoreException(message: 'Failed to review leave request: $e');
    }
  }

  Stream<List<LeaveRequest>> watchLeaveRequests(String organizationId) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leaveRequests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaveRequest.fromJson(doc.data()))
            .toList());
  }

  // ============ Users ============

  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw FirestoreException(message: 'Failed to update user profile: $e');
    }
  }

  Future<void> saveFaceEmbeddingToFirestore({
    required String userId,
    required String encryptedVector,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'faceEmbeddingEncrypted': encryptedVector,
        'faceVerified': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw FirestoreException(message: 'Failed to save face embedding: $e');
    }
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final code = List.generate(
      AppConstants.inviteCodeLength,
      (_) => chars[DateTime.now().millisecondsSinceEpoch % chars.length],
    ).join();
    return code;
  }
}