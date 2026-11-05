/// Attendance Approval Screen - setujui/tolak absensi karyawan

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_theme.dart';

class AttendanceApprovalScreen extends StatefulWidget {
  const AttendanceApprovalScreen({super.key});

  @override
  State<AttendanceApprovalScreen> createState() =>
      _AttendanceApprovalScreenState();
}

class _AttendanceApprovalScreenState extends State<AttendanceApprovalScreen> {
  final List<Map<String, dynamic>> _pendingAttendance = [
    {
      'name': 'Budi Santoso',
      'type': 'Check In',
      'time': '08:15',
      'date': '05 Nov 2026',
      'location': 'Jakarta Selatan',
      'faceScore': 0.94,
      'status': 'Pending',
    },
    {
      'name': 'Siti Rahayu',
      'type': 'Check Out',
      'time': '17:30',
      'date': '05 Nov 2026',
      'location': 'Jakarta Selatan',
      'faceScore': 0.89,
      'status': 'Pending',
    },
    {
      'name': 'Ahmad Fauzi',
      'type': 'Overtime Start',
      'time': '18:00',
      'date': '04 Nov 2026',
      'location': 'Jakarta Selatan',
      'faceScore': 0.91,
      'status': 'Pending',
    },
  ];

  void _approve(Map<String, dynamic> attendance) {
    setState(() {
      attendance['status'] = 'Approved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Absensi disetujui.'),
        backgroundColor: AppTheme.secondary,
      ),
    );
  }

  void _reject(Map<String, dynamic> attendance) {
    setState(() {
      attendance['status'] = 'Rejected';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Absensi ditolak.'),
        backgroundColor: AppTheme.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending = _pendingAttendance.where((a) => a['status'] == 'Pending').toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Persetujuan Absensi'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Stats
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Row(
              children: [
                _buildStatItem('Pending', pending.length.toString(),
                    AppTheme.warning, AppTheme.warningLight),
                const SizedBox(width: AppTheme.spaceMd),
                _buildStatItem('Disetujui',
                    _pendingAttendance
                        .where((a) => a['status'] == 'Approved')
                        .length
                        .toString(),
                    AppTheme.secondary, AppTheme.secondaryLight),
                const SizedBox(width: AppTheme.spaceMd),
                _buildStatItem('Ditolak',
                    _pendingAttendance
                        .where((a) => a['status'] == 'Rejected')
                        .length
                        .toString(),
                    AppTheme.danger, AppTheme.dangerLight),
              ],
            ),
          ),
          // Attendance List
          Expanded(
            child: pending.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 64, color: AppTheme.textMuted),
                        SizedBox(height: 16),
                        Text('Tidak ada absensi yang pending',
                            style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spaceLg),
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final att = pending[index];
                      return Card(
                        margin: const EdgeInsets.only(
                            bottom: AppTheme.spaceMd),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryLight,
                            child: Text(
                              (att['name'] as String).substring(0, 1),
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            att['name'] as String,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    att['type'] == 'Check In'
                                        ? Icons.login_rounded
                                        : att['type'] == 'Check Out'
                                            ? Icons.logout_rounded
                                            : Icons.schedule_rounded,
                                    size: 16,
                                    color: AppTheme.textMuted,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${att['type']} • ${att['time']}',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${att['date']}',
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                att['location'] as String,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.face_rounded,
                                      size: 16,
                                      color: AppTheme.textMuted),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Face Match: ${(att['faceScore'] as double * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 32,
                                child: OutlinedButton(
                                  onPressed: () => _approve(att),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.secondary,
                                    side: const BorderSide(
                                        color: AppTheme.secondary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusMd),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text('Setujui',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 70,
                                height: 32,
                                child: OutlinedButton(
                                  onPressed: () => _reject(att),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.danger,
                                    side: const BorderSide(
                                        color: AppTheme.danger),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusMd),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text('Tolak',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
