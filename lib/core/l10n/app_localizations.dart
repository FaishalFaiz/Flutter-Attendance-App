import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final deviceLocale = Localizations.localeOf(context);
    return AppLocalizations(deviceLocale);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Indonesian
  static const Map<String, String> _id = {
    'app_title': 'Kehadiran Karyawan',
    'login': 'Masuk',
    'welcome': 'Selamat Datang',
    'welcome_sub': 'Aplikasi presensi karyawan modern',
    'username': 'Nama Pengguna / NIK',
    'password': 'Kata Sandi',
    'login_as': 'Masuk sebagai',
    'role_employee': 'Karyawan',
    'role_admin': 'Admin / HR',
    'forgot_password': 'Lupa kata sandi?',
    'home': 'Beranda',
    'attendance': 'Presensi',
    'leave': 'Cuti & Izin',
    'profile': 'Profil',
    'settings': 'Pengaturan',
    'notifications': 'Notifikasi',
    'logout': 'Keluar',
    'dashboard': 'Dasbor',
    'employees': 'Karyawan',
    'approvals': 'Persetujuan',
    'reports': 'Laporan',
    'shift_management': 'Pengaturan Shift',
    'check_in': 'Masuk',
    'check_out': 'Keluar',
    'status_present': 'Hadir',
    'status_late': 'Terlambat',
    'status_leave': 'Izin / Cuti',
    'status_absent': 'Tidak Hadir',
    'status_pending': 'Menunggu',
    'status_approved': 'Disetujui',
    'status_rejected': 'Ditolak',
    'today': 'Hari Ini',
    'date': 'Tanggal',
    'time': 'Waktu',
    'location': 'Lokasi',
    'office_location': 'Lokasi Kantor',
    'geofence_radius': 'Radius 100m dari Kantor',
    'selfie': 'Selfie',
    'take_selfie': 'Ambil Selfie',
    'shift': 'Shift',
    'shift_time': 'Waktu Shift',
    'department': 'Departemen',
    'position': 'Jabatan',
    'nik': 'NIK',
    'employee_name': 'Nama Karyawan',
    'leave_type': 'Jenis Cuti',
    'leave_reason': 'Alasan Cuti',
    'start_date': 'Tanggal Mulai',
    'end_date': 'Tanggal Selesai',
    'overtime': 'Lembur',
    'overtime_hours': 'Jam Lembur',
    'overtime_reason': 'Alasan Lembur',
    'submit': 'Kirim',
    'approve': 'Setujui',
    'reject': 'Tolak',
    'pending': 'Menunggu Persetujuan',
    'no_data': 'Belum Ada Data',
    'no_notifications': 'Belum Ada Notifikasi',
    'export_pdf': 'Export PDF',
    'edit_profile': 'Edit Profil',
    'change_language': 'Ganti Bahasa',
    'language': 'Bahasa',
    'indonesian': 'Indonesia',
    'english': 'English',
    'biometric': 'Biometrik',
    'enable_biometric': 'Aktifkan Biometrik',
    'notifications_enabled': 'Aktifkan Notifikasi',
    'version': 'Versi',
    'search': 'Cari',
    'filter': 'Filter',
    'all': 'Semua',
    'present': 'Hadir',
    'late': 'Terlambat',
    'on_leave': 'Cuti / Izin',
    'absent': 'Alpa',
  };

  // English
  static const Map<String, String> _en = {
    'app_title': 'Employee Attendance',
    'login': 'Login',
    'welcome': 'Welcome',
    'welcome_sub': 'Modern employee attendance app',
    'username': 'Username / NIK',
    'password': 'Password',
    'login_as': 'Login as',
    'role_employee': 'Employee',
    'role_admin': 'Admin / HR',
    'forgot_password': 'Forgot password?',
    'home': 'Home',
    'attendance': 'Attendance',
    'leave': 'Leave & Overtime',
    'profile': 'Profile',
    'settings': 'Settings',
    'notifications': 'Notifications',
    'logout': 'Logout',
    'dashboard': 'Dashboard',
    'employees': 'Employees',
    'approvals': 'Approvals',
    'reports': 'Reports',
    'shift_management': 'Shift Management',
    'check_in': 'Check In',
    'check_out': 'Check Out',
    'status_present': 'Present',
    'status_late': 'Late',
    'status_leave': 'Leave / Absent',
    'status_absent': 'Absent',
    'status_pending': 'Pending',
    'status_approved': 'Approved',
    'status_rejected': 'Rejected',
    'today': 'Today',
    'date': 'Date',
    'time': 'Time',
    'location': 'Location',
    'office_location': 'Office Location',
    'geofence_radius': '100m Radius from Office',
    'selfie': 'Selfie',
    'take_selfie': 'Take Selfie',
    'shift': 'Shift',
    'shift_time': 'Shift Time',
    'department': 'Department',
    'position': 'Position',
    'nik': 'NIK',
    'employee_name': 'Employee Name',
    'leave_type': 'Leave Type',
    'leave_reason': 'Leave Reason',
    'start_date': 'Start Date',
    'end_date': 'End Date',
    'overtime': 'Overtime',
    'overtime_hours': 'Overtime Hours',
    'overtime_reason': 'Overtime Reason',
    'submit': 'Submit',
    'approve': 'Approve',
    'reject': 'Reject',
    'pending': 'Pending Approval',
    'no_data': 'No Data Available',
    'no_notifications': 'No Notifications',
    'export_pdf': 'Export PDF',
    'edit_profile': 'Edit Profile',
    'change_language': 'Change Language',
    'language': 'Language',
    'indonesian': 'Indonesian',
    'english': 'English',
    'biometric': 'Biometric',
    'enable_biometric': 'Enable Biometric',
    'notifications_enabled': 'Enable Notifications',
    'version': 'Version',
    'search': 'Search',
    'filter': 'Filter',
    'all': 'All',
    'present': 'Present',
    'late': 'Late',
    'on_leave': 'On Leave',
    'absent': 'Absent',
  };

  String translate(String key) {
    if (locale.languageCode == 'en') {
      return _en[key] ?? key;
    }
    return _id[key] ?? key;
  }

  String t(String key) => translate(key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['id', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
