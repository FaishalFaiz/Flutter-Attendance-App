import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  Color _getColor(String status) {
    switch (status) {
      case 'present':
        return AppTheme.statusPresent;
      case 'late':
        return AppTheme.statusLate;
      case 'leave':
        return AppTheme.statusLeave;
      case 'absent':
        return AppTheme.statusAbsent;
      case 'pending':
        return AppTheme.statusPending;
      case 'approved':
        return AppTheme.statusPresent;
      case 'rejected':
        return AppTheme.statusAbsent;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getLabel(String status, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case 'present': return l10n.t('status_present');
      case 'late': return l10n.t('status_late');
      case 'leave': return l10n.t('status_leave');
      case 'absent': return l10n.t('status_absent');
      case 'pending': return l10n.t('status_pending');
      case 'approved': return l10n.t('status_approved');
      case 'rejected': return l10n.t('status_rejected');
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _getLabel(status, context),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
