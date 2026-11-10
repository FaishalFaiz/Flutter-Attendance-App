import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';
import 'package:attendance_app/data/dummy_data.dart';

class AdminEmployeeManagementScreen extends StatelessWidget {
  const AdminEmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.t('employees')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
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
              ),
              title: Text(
                emp.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Text(
                '${emp.position} • ${emp.department}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlueLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  emp.nik,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
