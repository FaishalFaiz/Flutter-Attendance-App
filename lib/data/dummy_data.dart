import 'package:attendance_app/data/models/attendance_record.dart';
import 'package:attendance_app/data/models/employee.dart';
import 'package:attendance_app/data/models/leave_request.dart';
import 'package:attendance_app/data/models/notification_item.dart';
import 'package:attendance_app/data/models/overtime_request.dart';
import 'package:intl/intl.dart';

class DummyData {
  static const String officeLocation = 'Gedung Utama, Jl. Sudirman No. 123, Jakarta';
  static const double officeLatitude = -6.2088;
  static const double officeLongitude = 106.8456;
  static const double geofenceRadius = 100; // meters

  static List<Employee> employees = [
    Employee(
      id: 'EMP001',
      name: 'Ahmad Rizki',
      nik: 'EMP-2024-001',
      position: 'Software Engineer',
      department: 'Engineering',
      shift: 'Shift Pagi',
      shiftTime: '08:00 - 17:00',
      photoUrl: 'https://i.pravatar.cc/150?u=ahmad',
      email: 'ahmad@company.com',
      phone: '+62 812-3456-7890',
      joinDate: '15 Jan 2023',
    ),
    Employee(
      id: 'EMP002',
      name: 'Siti Nurhaliza',
      nik: 'EMP-2024-002',
      position: 'UI/UX Designer',
      department: 'Design',
      shift: 'Shift Pagi',
      shiftTime: '08:00 - 17:00',
      photoUrl: 'https://i.pravatar.cc/150?u=siti',
      email: 'siti@company.com',
      phone: '+62 813-4567-8901',
      joinDate: '20 Mar 2022',
    ),
    Employee(
      id: 'EMP003',
      name: 'Budi Santoso',
      nik: 'EMP-2024-003',
      position: 'HR Manager',
      department: 'HR',
      shift: 'Shift Siang',
      shiftTime: '09:00 - 18:00',
      photoUrl: 'https://i.pravatar.cc/150?u=budi',
      email: 'budi@company.com',
      phone: '+62 814-5678-9012',
      joinDate: '05 Jul 2021',
    ),
    Employee(
      id: 'EMP004',
      name: 'Dewi Lestari',
      nik: 'EMP-2024-004',
      position: 'Marketing Lead',
      department: 'Marketing',
      shift: 'Shift Pagi',
      shiftTime: '08:00 - 17:00',
      photoUrl: 'https://i.pravatar.cc/150?u=dewi',
      email: 'dewi@company.com',
      phone: '+62 815-6789-0123',
      joinDate: '10 Nov 2020',
    ),
    Employee(
      id: 'EMP005',
      name: 'Rudi Hartono',
      nik: 'EMP-2024-005',
      position: 'Finance Staff',
      department: 'Finance',
      shift: 'Shift Siang',
      shiftTime: '09:00 - 18:00',
      photoUrl: 'https://i.pravatar.cc/150?u=rudi',
      email: 'rudi@company.com',
      phone: '+62 816-7890-1234',
      joinDate: '02 Mar 2024',
    ),
    Employee(
      id: 'EMP006',
      name: 'Maya Sari',
      nik: 'EMP-2024-006',
      position: 'Operations Manager',
      department: 'Operations',
      shift: 'Shift Malam',
      shiftTime: '18:00 - 03:00',
      photoUrl: 'https://i.pravatar.cc/150?u=maya',
      email: 'maya@company.com',
      phone: '+62 817-8901-2345',
      joinDate: '18 Sep 2023',
    ),
  ];

  static Employee currentEmployee = employees[0];

  static List<AttendanceRecord> attendanceRecords = [
    AttendanceRecord(
      id: 'ATT001',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'present',
      checkInTime: '07:55',
      checkOutTime: '17:05',
      location: 'Gedung Utama, Jakarta',
      isSelfieTaken: true,
      shift: 'Shift Pagi',
    ),
    AttendanceRecord(
      id: 'ATT002',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'late',
      checkInTime: '08:15',
      checkOutTime: '17:10',
      location: 'Gedung Utama, Jakarta',
      isSelfieTaken: true,
      shift: 'Shift Pagi',
    ),
    AttendanceRecord(
      id: 'ATT003',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'present',
      checkInTime: '07:58',
      checkOutTime: '17:00',
      location: 'Gedung Utama, Jakarta',
      isSelfieTaken: true,
      shift: 'Shift Pagi',
    ),
    AttendanceRecord(
      id: 'ATT004',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'leave',
      checkInTime: null,
      checkOutTime: null,
      location: '-',
      isSelfieTaken: false,
      shift: 'Shift Pagi',
    ),
    AttendanceRecord(
      id: 'ATT005',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'present',
      checkInTime: '08:00',
      checkOutTime: '17:02',
      location: 'Gedung Utama, Jakarta',
      isSelfieTaken: true,
      shift: 'Shift Pagi',
    ),
  ];

  static List<LeaveRequest> leaveRequests = [
    LeaveRequest(
      id: 'LV001',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      type: 'Cuti Tahunan',
      reason: 'Liburan keluarga ke Bali',
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 14)),
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    LeaveRequest(
      id: 'LV002',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      type: 'Sakit',
      reason: 'Demam dan pilek',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().subtract(const Duration(days: 14)),
      status: 'approved',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    LeaveRequest(
      id: 'LV003',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      type: 'Pribadi',
      reason: 'Urusan keluarga mendesak',
      startDate: DateTime.now().subtract(const Duration(days: 40)),
      endDate: DateTime.now().subtract(const Duration(days: 38)),
      status: 'rejected',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  static List<OvertimeRequest> overtimeRequests = [
    OvertimeRequest(
      id: 'OT001',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: '18:00',
      endTime: '21:00',
      hours: 3,
      reason: 'Selesaikan proyek deadline',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    OvertimeRequest(
      id: 'OT002',
      employeeId: 'EMP001',
      employeeName: 'Ahmad Rizki',
      date: DateTime.now().subtract(const Duration(days: 10)),
      startTime: '18:00',
      endTime: '20:00',
      hours: 2,
      reason: 'Bug fixing production',
      status: 'approved',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  static List<NotificationItem> notifications = [
    NotificationItem(
      id: 'N001',
      title: 'Pengingat Presensi',
      body: 'Waktu masuk shift Anda pukul 08:00 WIB. Jangan lupa absen!',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'attendance',
    ),
    NotificationItem(
      id: 'N002',
      title: 'Cuti Disetujui',
      body: 'Pengajuan cuti sakit Anda telah disetujui oleh HR.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: 'leave',
    ),
    NotificationItem(
      id: 'N003',
      title: 'Lembur Menunggu',
      body: 'Pengajuan lembur Anda menunggu persetujuan manajer.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      type: 'overtime',
    ),
  ];

  // Admin: all employees attendance today
  static List<AttendanceRecord> getAllTodayAttendance() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return employees.expand((emp) {
      return attendanceRecords.where(
        (att) => att.employeeId == emp.id &&
            att.date.isAfter(todayStart.subtract(const Duration(days: 1))) &&
            att.date.isBefore(todayStart.add(const Duration(days: 1))),
      );
    }).toList();
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'id_ID').format(date);
  }
}
