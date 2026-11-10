import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';
import 'package:attendance_app/screens/auth/login_screen.dart';

class EmployeeSettingsScreen extends StatefulWidget {
  const EmployeeSettingsScreen({super.key});

  @override
  State<EmployeeSettingsScreen> createState() => _EmployeeSettingsScreenState();
}

class _EmployeeSettingsScreenState extends State<EmployeeSettingsScreen> {
  bool _notifications = true;
  String _language = 'id';

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Keluar',
                style: TextStyle(color: AppTheme.statusAbsent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: Text(l10n.t('settings'))),
      body: ListView(
        children: [
          _buildSectionTitle(context, l10n.t('notifications')),
          SwitchListTile(
            title: Text(l10n.t('notifications_enabled')),
            subtitle: const Text('Terima notifikasi presensi dan cuti'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            activeColor: AppTheme.primaryBlue,
          ),
          const Divider(),
          _buildSectionTitle(context, l10n.t('language')),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(_language == 'id' ? l10n.t('indonesian') : l10n.t('english')),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              setState(() => _language = _language == 'id' ? 'en' : 'id');
            },
          ),
          const Divider(),
          _buildSectionTitle(context, l10n.t('biometric')),
          ListTile(
            leading: const Icon(Icons.fingerprint_rounded),
            title: Text(l10n.t('enable_biometric')),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const Divider(),
          _buildSectionTitle(context, 'Info'),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('Versi Aplikasi'),
            trailing: const Text('1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppTheme.statusAbsent),
            title: const Text('Keluar'),
            titleTextStyle: const TextStyle(color: AppTheme.statusAbsent),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }
}
