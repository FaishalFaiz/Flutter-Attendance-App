/// Settings Screen - konfigurasi organisasi

import 'package:flutter/material.dart';

import '../../../core/design/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _faceThreshold = 0.75;
  bool _requireFaceCheckIn = true;
  bool _requireFaceCheckOut = true;
  int _lateTolerance = 15;
  int _maxBreakMinutes = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Pengaturan Organisasi'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Face Verification Settings
            _buildSection(
              title: 'Verifikasi Wajah',
              subtitle: 'Pengaturan biometrik absensi',
              children: [
                _buildSliderSetting(
                  title: 'Face Verification Threshold',
                  subtitle: 'Tingkat kepercayaan minimum (0.0 - 1.0)',
                  value: _faceThreshold,
                  min: 0.5,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (val) => setState(() => _faceThreshold = val),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _buildToggleSetting(
                  title: 'Wajibkan Wajah untuk Check In',
                  subtitle: 'Karyawan harus memindai wajah saat check in',
                  value: _requireFaceCheckIn,
                  onChanged: (val) => setState(() => _requireFaceCheckIn = val),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _buildToggleSetting(
                  title: 'Wajibkan Wajah untuk Check Out',
                  subtitle: 'Karyawan harus memindai wajah saat check out',
                  value: _requireFaceCheckOut,
                  onChanged: (val) => setState(() => _requireFaceCheckOut = val),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Attendance Settings
            _buildSection(
              title: 'Pengaturan Absensi',
              subtitle: 'Aturan jadwal dan toleransi',
              children: [
                _buildNumberSetting(
                  title: 'Toleransi Terlambat (menit)',
                  subtitle: 'Batas waktu sebelum dianggap terlambat',
                  value: _lateTolerance,
                  onChanged: (val) => setState(() => _lateTolerance = val),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _buildNumberSetting(
                  title: 'Maksimum Istirahat (menit)',
                  subtitle: 'Durasi maksimal istirahat per hari',
                  value: _maxBreakMinutes,
                  onChanged: (val) => setState(() => _maxBreakMinutes = val),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Danger Zone
            _buildSection(
              title: 'Zona Bahaya',
              subtitle: 'Tindakan yang tidak dapat diurungkan',
              icon: Icons.warning_rounded,
              iconColor: AppTheme.danger,
              children: [
                _buildDangerButton(
                  title: 'Reset Semua Data Absensi',
                  subtitle: 'Menghapus semua riwayat absensi',
                  onPressed: () {},
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _buildDangerButton(
                  title: 'Keluar dari Organisasi',
                  subtitle: 'Meninggalkan organisasi ini',
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceXxl),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Simpan Pengaturan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
    IconData? icon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppTheme.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(icon, color: iconColor ?? AppTheme.primary, size: 20),
              ),
              const SizedBox(width: AppTheme.spaceSm),
            ],
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: AppTheme.spaceMd),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppTheme.primary,
          inactiveColor: AppTheme.divider,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      ),
      value: value,
      activeColor: AppTheme.primary,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildNumberSetting({
    required String title,
    required String subtitle,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$value',
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: value == _maxBreakMinutes ? 120 : 60,
                divisions: value == _maxBreakMinutes ? 12 : 6,
                activeColor: AppTheme.primary,
                inactiveColor: AppTheme.divider,
                onChanged: (val) => onChanged(val.round()),
              ),
            ),
            const SizedBox(width: AppTheme.spaceMd),
            TextButton(
              onPressed: () {},
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDangerButton({
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return ListTile(
      leading: Icon(Icons.delete_rounded, color: AppTheme.danger, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.danger,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppTheme.textMuted, size: 20),
      onTap: onPressed,
    );
  }
}
