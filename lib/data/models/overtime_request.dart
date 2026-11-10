class OvertimeRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int hours;
  final String reason;
  String status; // pending, approved, rejected
  final DateTime createdAt;

  OvertimeRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.hours,
    required this.reason,
    required this.status,
    required this.createdAt,
  });
}
