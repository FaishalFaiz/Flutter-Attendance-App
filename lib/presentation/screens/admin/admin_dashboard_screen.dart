/// Admin Dashboard - Overview untuk admin/owner organisasi

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: false,
      ),
      body: const _OverviewTab(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/shift'),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

// ============ Overview Tab ============

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Organisasi',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLg),
          // Quick Action Buttons
          const Text(
            'Aksi Cepat',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            mainAxisSpacing: AppTheme.spaceMd,
            crossAxisSpacing: AppTheme.spaceMd,
            children: [
              _buildQuickActionCard(
                context: context,
                title: 'Manajemen Shift',
                subtitle: 'Atur jadwal kerja',
                icon: Icons.schedule_rounded,
                color: AppTheme.primary,
                onTap: () => context.push('/admin/shift'),
              ),
              _buildQuickActionCard(
                context: context,
                title: 'Manajemen Anggota',
                subtitle: 'Kelola karyawan',
                icon: Icons.people_rounded,
                color: AppTheme.secondary,
                onTap: () => context.push('/admin/members'),
              ),
              _buildQuickActionCard(
                context: context,
                title: 'Persetujuan Absensi',
                subtitle: 'Setujui/tolak absensi',
                icon: Icons.fingerprint_rounded,
                color: AppTheme.accent,
                onTap: () => context.push('/admin/attendance-approval'),
              ),
              _buildQuickActionCard(
                context: context,
                title: 'Laporan',
                subtitle: 'Export data absensi',
                icon: Icons.bar_chart_rounded,
                color: Color(0xFF8B5CF6),
                onTap: () => context.push('/admin/reports'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceXl),
          // KPI Cards
          const Text(
            'Statistik',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Row(
            children: [
              _buildKPICard(
                title: 'Total Karyawan',
                value: '24',
                subtitle: '15 aktif, 9 nonaktif',
                color: AppTheme.primary,
                icon: Icons.people_rounded,
              ),
              const SizedBox(width: AppTheme.spaceMd),
              _buildKPICard(
                title: 'Hadir Hari Ini',
                value: '18',
                subtitle: '75% dari total',
                color: AppTheme.secondary,
                icon: Icons.check_circle_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Row(
            children: [
              _buildKPICard(
                title: 'Terlambat',
                value: '3',
                subtitle: 'Perlu perhatian',
                color: AppTheme.accent,
                icon: Icons.access_time_rounded,
              ),
              const SizedBox(width: AppTheme.spaceMd),
              _buildKPICard(
                title: 'Cuti Pending',
                value: '2',
                subtitle: 'Menunggu persetujuan',
                color: AppTheme.warning,
                icon: Icons.pending_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceXl),
          // Recent Attendance
          const Text(
            'Absensi Terbaru',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Card(
            child: Column(
              children: List.generate(5, (index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.primaryLight,
                    child: Icon(Icons.person_rounded, color: AppTheme.primary),
                  ),
                  title: const Text(
                    'Budi Santoso',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Check In • 08:15',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.statusOnTime.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: const Text(
                      'Tepat Waktu',
                      style: TextStyle(
                        color: AppTheme.statusOnTime,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spaceXs),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceSm),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spaceXs),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
