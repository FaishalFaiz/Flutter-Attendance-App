import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';
import 'package:attendance_app/data/dummy_data.dart';
import 'package:attendance_app/widgets/shared/stat_card.dart';
import 'package:attendance_app/widgets/shared/attendance_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = DummyData.getAllTodayAttendance();

    final present = today.where((r) => r.status == 'present').length;
    final late = today.where((r) => r.status == 'late').length;
    final absent = today.where((r) => r.status == 'absent').length;
    final leave = today.where((r) => r.status == 'leave').length;
    final total = DummyData.employees.length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: Text(l10n.t('dashboard'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.t('today'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 24) / 3;
                final compact = cardWidth < 140;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: StatCard(
                          compact: compact,
                          title: 'Total Karyawan',
                          value: total.toString(),
                          icon: Icons.people_rounded,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          compact: compact,
                          title: l10n.t('status_present'),
                          value: present.toString(),
                          icon: Icons.check_circle_rounded,
                          color: AppTheme.statusPresent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          compact: compact,
                          title: l10n.t('status_late'),
                          value: late.toString(),
                          icon: Icons.access_time_rounded,
                          color: AppTheme.statusLate,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 12) / 2;
                final compact = cardWidth < 140;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: StatCard(
                          compact: compact,
                          title: l10n.t('on_leave'),
                          value: leave.toString(),
                          icon: Icons.event_busy_rounded,
                          color: AppTheme.statusLeave,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          compact: compact,
                          title: l10n.t('status_absent'),
                          value: absent.toString(),
                          icon: Icons.event_available_rounded,
                          color: AppTheme.statusAbsent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Persetujuan Tertunda',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Lihat Semua',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                children: [
                  _buildPendingRow(context, 'Ahmad Rizki', 'Cuti Tahunan', 'pending'),
                  const SizedBox(height: 8),
                  _buildPendingRow(context, 'Maya Sari', 'Lembur 3 Jam', 'pending'),
                  const SizedBox(height: 8),
                  _buildPendingRow(context, 'Budi Santoso', 'Cuti Sakit', 'pending'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kehadiran Terkini',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Lihat Semua',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...today.map((record) => AttendanceCard(record: record)),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRow(BuildContext context, String name, String type, String status) {
    Color statusColor;
    switch (status) {
      case 'pending': statusColor = AppTheme.statusPending; break;
      case 'approved': statusColor = AppTheme.statusPresent; break;
      case 'rejected': statusColor = AppTheme.statusAbsent; break;
      default: statusColor = AppTheme.textSecondary;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status == 'pending' ? 'Menunggu' : status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}
