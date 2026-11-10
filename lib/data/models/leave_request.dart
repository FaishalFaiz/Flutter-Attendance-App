class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String type;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  String status; // pending, approved, rejected
  final String? attachmentUrl;
  final DateTime createdAt;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.attachmentUrl,
    required this.createdAt,
  });
}
