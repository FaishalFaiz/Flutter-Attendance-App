/// Leave Request Screen - pengajuan cuti/izin karyawan

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_theme.dart';
import '../../di/service_locator.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _reasonController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedType = 'Sick';
  bool _isSubmitting = false;

  static const List<Map<String, dynamic>> _leaveTypes = [
    {'title': 'Sick Leave', 'subtitle': 'Medical rest or recovery', 'icon': Icons.healing_rounded, 'color': AppTheme.primary},
    {'title': 'Annual Leave', 'subtitle': 'Personal time off & holidays', 'icon': Icons.beach_access_rounded, 'color': AppTheme.secondary},
    {'title': 'Emergency / Permit', 'subtitle': 'Urgent family or personal affairs', 'icon': Icons.priority_high_rounded, 'color': AppTheme.accent},
    {'title': 'Work From Home', 'subtitle': 'Remote work assignment', 'icon': Icons.home_work_rounded, 'color': Color(0xFF8B5CF6)},
  ];

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitLeave() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal mulai dan selesai wajib diisi.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alasan cuti wajib diisi.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // TODO: Connect to LeaveRepositoryImpl.submitLeave
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengajuan cuti berhasil dikirim.'),
          backgroundColor: AppTheme.secondary,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengajukan cuti: $e'), backgroundColor: AppTheme.danger),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Pengajuan Cuti'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengajuan Cuti',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            Text(
              'Ajukan cuti atau izin untuk persetujuan admin.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.spaceXl),

            // Leave Type
            const Text(
              'Jenis Cuti',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            ..._leaveTypes.map((type) {
              final isSelected = _selectedType == type['title'];
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type['title'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  decoration: BoxDecoration(
                    color: isSelected ? type['color'].withValues(alpha: 0.1) : AppTheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(
                      color: isSelected ? type['color']! : AppTheme.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? type['color']! : AppTheme.divider,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        child: Icon(
                          type['icon'] as IconData,
                          color: isSelected ? Colors.white : AppTheme.textMuted,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type['title'] as String,
                              style: TextStyle(
                                color: isSelected ? type['color']! : AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spaceXs),
                            Text(
                              type['subtitle'] as String,
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: Colors.green),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: AppTheme.spaceXl),

            // Date Range
            const Text(
              'Tanggal Cuti',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Tanggal Mulai',
                    value: _startDate != null
                        ? DateFormat('dd MMM yyyy').format(_startDate!)
                        : 'Pilih tanggal',
                    icon: Icons.calendar_today_rounded,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: _buildDateField(
                    label: 'Tanggal Selesai',
                    value: _endDate != null
                        ? DateFormat('dd MMM yyyy').format(_endDate!)
                        : 'Pilih tanggal',
                    icon: Icons.calendar_today_rounded,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Reason
            const Text(
              'Alasan & Justifikasi',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            TextField(
              controller: _reasonController,
              maxLines: 5,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Detail alasan cuti, catatan medis, atau rencana kerja...',
                hintStyle: TextStyle(color: AppTheme.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.surface,
                contentPadding: const EdgeInsets.all(AppTheme.spaceMd),
              ),
            ),

            const SizedBox(height: AppTheme.spaceXxl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitLeave,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Ajukan Cuti'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            labelText: label,
            hintText: value,
            hintStyle: TextStyle(color: AppTheme.textMuted),
            prefixIcon: Icon(icon, color: AppTheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppTheme.surface,
            contentPadding: const EdgeInsets.all(AppTheme.spaceMd),
          ),
        ),
      ),
    );
  }
}
