class AttendanceRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  String status; // present, late, leave, absent
  final String? checkInTime;
  final String? checkOutTime;
  final String location;
  final bool isSelfieTaken;
  final String shift;

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    required this.location,
    this.isSelfieTaken = false,
    required this.shift,
  });
}
