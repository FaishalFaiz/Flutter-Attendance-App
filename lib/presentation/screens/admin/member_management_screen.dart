/// Member Management Screen - kelola karyawan dan role

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_theme.dart';

class MemberManagementScreen extends StatefulWidget {
  const MemberManagementScreen({super.key});

  @override
  State<MemberManagementScreen> createState() => _MemberManagementScreenState();
}

class _MemberManagementScreenState extends State<MemberManagementScreen> {
  final List<Map<String, dynamic>> _members = [
    {
      'name': 'Budi Santoso',
      'email': 'budi@company.com',
      'employeeId': 'EMP001',
      'role': 'Owner',
      'roleColor': AppTheme.primary,
      'status': 'Active',
      'statusColor': AppTheme.secondary,
      'faceVerified': true,
    },
    {
      'name': 'Siti Rahayu',
      'email': 'siti@company.com',
      'employeeId': 'EMP002',
      'role': 'Admin',
      'roleColor': Color(0xFF8B5CF6),
      'status': 'Active',
      'statusColor': AppTheme.secondary,
      'faceVerified': true,
    },
    {
      'name': 'Ahmad Fauzi',
      'email': 'ahmad@company.com',
      'employeeId': 'EMP003',
      'role': 'Member',
      'roleColor': AppTheme.textSecondary,
      'status': 'Active',
      'statusColor': AppTheme.secondary,
      'faceVerified': false,
    },
    {
      'name': 'Dewi Lestari',
      'email': 'dewi@company.com',
      'employeeId': 'EMP004',
      'role': 'Member',
      'roleColor': AppTheme.textSecondary,
      'status': 'Suspended',
      'statusColor': AppTheme.danger,
      'faceVerified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manajemen Anggota'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Header with Stats and Add Button
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Anggota',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_members.length} anggota',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_rounded, size: 18),
                  label: const Text('Undang Anggota'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Member List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        (member['name'] as String).substring(0, 1),
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      member['name'] as String,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              member['employeeId'] as String,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.textMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              (member['email'] as String).split('@').first,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (member['roleColor'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                          ),
                          child: Text(
                            member['role'] as String,
                            style: TextStyle(
                              color: member['roleColor'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (member['statusColor'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                          ),
                          child: Text(
                            member['status'] as String,
                            style: TextStyle(
                              color: member['statusColor'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Icon(
                          (member['faceVerified'] as bool)
                              ? Icons.face_rounded
                              : Icons.face_retouching_off_rounded,
                          color: (member['faceVerified'] as bool)
                              ? AppTheme.secondary
                              : AppTheme.textMuted,
                          size: 18,
                        ),
                      ],
                    ),
                    onTap: () => context.push('/member-detail/${member['employeeId']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person_add_rounded),
      ),
    );
  }
}
