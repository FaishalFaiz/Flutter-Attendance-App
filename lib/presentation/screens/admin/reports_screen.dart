/// Reports Screen - laporan dan analitik

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/design/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Bulan Ini';

  final List<String> _periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Tahun Ini'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Laporan & Analitik'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan Absensi',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            Text(
              'Lihat dan export data absensi karyawan.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.spaceXl),

            // Period Filter
            const Text(
              'Periode',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Wrap(
              spacing: AppTheme.spaceSm,
              runSpacing: AppTheme.spaceSm,
              children: _periods.map((period) {
                final isSelected = _selectedPeriod == period;
                return FilterChip(
                  label: Text(period),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedPeriod = period),
                  backgroundColor: AppTheme.surface,
                  selectedColor: Color(0xFFDBEAFE),
                  checkmarkColor: AppTheme.primary,
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppTheme.primary : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Summary Cards
            Row(
              children: [
                _buildSummaryCard(
                  'Total Absensi',
                  '142',
                  AppTheme.primary,
                  Icons.login_rounded,
                ),
                const SizedBox(width: AppTheme.spaceMd),
                _buildSummaryCard(
                  'Tepat Waktu',
                  '118',
                  AppTheme.secondary,
                  Icons.check_circle_rounded,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Row(
              children: [
                _buildSummaryCard(
                  'Terlambat',
                  '18',
                  AppTheme.accent,
                  Icons.access_time_rounded,
                ),
                const SizedBox(width: AppTheme.spaceMd),
                _buildSummaryCard(
                  'Cuti',
                  '6',
                  AppTheme.warning,
                  Icons.event_busy_rounded,
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Chart Placeholder
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Grafik Absensi Harian',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceLg),
                    SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart_rounded,
                                size: 48, color: AppTheme.textMuted),
                            const SizedBox(height: 16),
                            Text(
                              'Grafik akan ditampilkan di sini',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Export Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 20),
                label: const Text('Export CSV'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
                label: const Text('Export PDF'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: const BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
