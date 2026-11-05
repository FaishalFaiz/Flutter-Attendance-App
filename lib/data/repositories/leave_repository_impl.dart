/// Leave repository implementation

import '../../../domain/entities/leave_request.dart';
import '../../../domain/repositories/leave_repository.dart';
import '../../datasources/remote/firestore_remote_datasource.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  LeaveRepositoryImpl._();
  static final LeaveRepositoryImpl _instance = LeaveRepositoryImpl._();
  factory LeaveRepositoryImpl() => _instance;

  final _remote = FirestoreRemoteDataSource();

  @override
  Future<LeaveRequest> submitLeave({
    required String organizationId,
    required String userId,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    List<String> attachmentUrls = const [],
  }) async {
    return await _remote.createLeaveRequest(
      organizationId: organizationId,
      userId: userId,
      type: type.name,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      attachmentUrls: attachmentUrls,
    );
  }

  @override
  Future<List<LeaveRequest>> getUserLeaveRequests({
    required String organizationId,
    required String userId,
  }) async {
    return await _remote.getLeaveRequests(
      organizationId: organizationId,
      userId: userId,
    );
  }

  @override
  Future<List<LeaveRequest>> getOrganizationLeaveRequests(String organizationId) async {
    return await _remote.getLeaveRequests(organizationId: organizationId);
  }

  @override
  Future<void> reviewLeaveRequest({
    required String leaveRequestId,
    required String organizationId,
    required bool approved,
    required String reviewedBy,
    String? notes,
  }) async {
    await _remote.reviewLeaveRequest(
      leaveRequestId: leaveRequestId,
      organizationId: organizationId,
      approved: approved,
      reviewedBy: reviewedBy,
      notes: notes,
    );
  }

  @override
  Future<void> cancelLeaveRequest({
    required String leaveRequestId,
    required String organizationId,
    required String userId,
  }) async {
    try {
      await _remote.reviewLeaveRequest(
        leaveRequestId: leaveRequestId,
        organizationId: organizationId,
        approved: false,
        reviewedBy: userId,
        notes: 'Cancelled by user',
      );
    } catch (e) {
      throw FirestoreException(message: 'Failed to cancel leave request: $e');
    }
  }

  @override
  Stream<List<LeaveRequest>> watchLeaveRequests(String organizationId) {
    return _remote.watchLeaveRequests(organizationId);
  }
}