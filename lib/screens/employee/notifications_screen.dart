import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';
import 'package:attendance_app/data/dummy_data.dart';

class EmployeeNotificationsScreen extends StatelessWidget {
  const EmployeeNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: Text(l10n.t('notifications'))),
      body: DummyData.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 64,
                    color: AppTheme.textMuted.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.t('no_notifications'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: DummyData.notifications.length,
              itemBuilder: (context, index) {
                final notif = DummyData.notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlueLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        notif.type == 'attendance'
                            ? Icons.access_time_rounded
                            : notif.type == 'leave'
                                ? Icons.event_rounded
                                : Icons.work_rounded,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    title: Text(
                      notif.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      notif.body,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    trailing: notif.isRead
                        ? const Icon(Icons.done_all_rounded,
                            color: AppTheme.textMuted, size: 16)
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
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
