/// Shift Management Screen - pengaturan jadwal kerja

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_theme.dart';

class ShiftManagementScreen extends StatefulWidget {
  const ShiftManagementScreen({super.key});

  @override
  State<ShiftManagementScreen> createState() => _ShiftManagementScreenState();
}

class _ShiftManagementScreenState extends State<ShiftManagementScreen> {
  final List<Map<String, dynamic>> _shifts = [
    {
      'name': 'Shift Pagi',
      'start': '08:00',
      'end': '17:00',
      'days': 'Senin - Jumat',
      'color': AppTheme.primary,
      'isDefault': true,
    },
    {
      'name': 'Shift Siang',
      'start': '14:00',
      'end': '23:00',
      'days': 'Senin - Jumat',
      'color': AppTheme.secondary,
      'isDefault': false,
    },
    {
      'name': 'Shift Malam',
      'start': '22:00',
      'end': '07:00',
      'days': 'Senin - Minggu',
      'color': AppTheme.accent,
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manajemen Shift'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Header with Add Button
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Shift',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Tambah Shift'),
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
          // Shift List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
              itemCount: _shifts.length,
              itemBuilder: (context, index) {
                final shift = _shifts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (shift['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: Icon(
                        Icons.access_time_rounded,
                        color: shift['color'] as Color,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      shift['name'] as String,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${shift['start']} - ${shift['end']}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          shift['days'] as String,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: shift['isDefault'] as bool
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                color: AppTheme.secondary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.edit_rounded,
                                color: AppTheme.textMuted, size: 20),
                            onPressed: () {},
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
