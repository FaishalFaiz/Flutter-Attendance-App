import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';
import 'package:attendance_app/data/dummy_data.dart';

class AdminShiftManagementScreen extends StatelessWidget {
  const AdminShiftManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: Text(l10n.t('shift_management'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.employees.length,
        itemBuilder: (context, index) {
          final emp = DummyData.employees[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(emp.photoUrl),
                backgroundColor: AppTheme.primaryBlueLight,
                child: Text(emp.initials),
              ),
              title: Text(
                emp.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        '${emp.shift} - ${emp.shiftTime}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlue,
                  side: const BorderSide(color: AppTheme.primaryBlue),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Edit', style: TextStyle(fontSize: 12)),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
