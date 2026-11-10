import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';
import 'package:attendance_app/data/dummy_data.dart';
import 'package:attendance_app/widgets/shared/status_chip.dart';

class AdminLeaveApprovalScreen extends StatefulWidget {
  const AdminLeaveApprovalScreen({super.key});

  @override
  State<AdminLeaveApprovalScreen> createState() => _AdminLeaveApprovalScreenState();
}

class _AdminLeaveApprovalScreenState extends State<AdminLeaveApprovalScreen> {
  void _approve(String id) {
    setState(() {
      final req = DummyData.leaveRequests.firstWhere((r) => r.id == id);
      req.status = 'approved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pengajuan disetujui'),
        backgroundColor: AppTheme.statusPresent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _reject(String id) {
    setState(() {
      final req = DummyData.leaveRequests.firstWhere((r) => r.id == id);
      req.status = 'rejected';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pengajuan ditolak'),
        backgroundColor: AppTheme.statusAbsent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pending = DummyData.leaveRequests.where((r) => r.status == 'pending').toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: Text('Persetujuan Cuti')),
      body: pending.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.approval_rounded,
                    size: 64,
                    color: AppTheme.textMuted.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada pengajuan tertunda',
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
              itemCount: pending.length,
              itemBuilder: (context, index) {
                final req = pending[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    req.employeeName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${req.type} • ${DummyData.formatDate(req.startDate)} - ${DummyData.formatDate(req.endDate)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusChip(status: req.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                req.reason,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => _reject(req.id),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.statusAbsent,
                                side: const BorderSide(color: AppTheme.statusAbsent),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(l10n.t('reject')),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _approve(req.id),
                              child: Text(l10n.t('approve')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
