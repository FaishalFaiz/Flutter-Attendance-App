/// Leave repository contract

import '../entities/leave_request.dart';

abstract class LeaveRepository {
  /// Submit a leave request
  Future<LeaveRequest> submitLeave({
    required String organizationId,
    required String userId,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    List<String> attachmentUrls = const [],
  });

  /// Get leave requests for a user
  Future<List<LeaveRequest>> getUserLeaveRequests({
    required String organizationId,
    required String userId,
  });

  /// Get all leave requests for an organization (admin)
  Future<List<LeaveRequest>> getOrganizationLeaveRequests(String organizationId);

  /// Approve or reject leave request (admin)
  Future<void> reviewLeaveRequest({
    required String leaveRequestId,
    required String organizationId,
    required bool approved,
    required String reviewedBy,
    String? notes,
  });

  /// Cancel a leave request (user)
  Future<void> cancelLeaveRequest({
    required String leaveRequestId,
    required String organizationId,
    required String userId,
  });

  /// Stream of leave requests (real-time)
  Stream<List<LeaveRequest>> watchLeaveRequests(String organizationId);
}