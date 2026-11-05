/// Overtime Request Screen - pengajuan lembur karyawan

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_theme.dart';

class OvertimeRequestScreen extends StatefulWidget {
  const OvertimeRequestScreen({super.key});

  @override
  State<OvertimeRequestScreen> createState() => _OvertimeRequestScreenState();
}

class _OvertimeRequestScreenState extends State<OvertimeRequestScreen> {
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  double _plannedHours = 2.0;
  bool _isSubmitting = false;

  final List<double> _hourOptions = [1.0, 1.5, 2.0, 3.0, 4.0, 5.0, 6.0, 8.0];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitOvertime() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal lembur wajib dipilih.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alasan lembur wajib diisi.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // TODO: Connect to LeaveRepositoryImpl.submitOvertime
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengajuan lembur berhasil dikirim.'),
          backgroundColor: AppTheme.secondary,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengajukan lembur: $e'), backgroundColor: AppTheme.danger),
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
        title: const Text('Pengajuan Lembur'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengajuan Lembur',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            Text(
              'Ajukan lembur untuk persetujuan atasan.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.spaceXl),

            // Date
            const Text(
              'Tanggal Lembur',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    hintText: _selectedDate != null
                        ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                        : 'Pilih tanggal',
                    hintStyle: TextStyle(color: AppTheme.textMuted),
                    prefixIcon: const Icon(Icons.calendar_today_rounded,
                        color: AppTheme.primary),
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
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Planned Hours
            const Text(
              'Durasi Lembur',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Wrap(
              spacing: AppTheme.spaceSm,
              runSpacing: AppTheme.spaceSm,
              children: _hourOptions.map((hours) {
                final isSelected = _plannedHours == hours;
                return FilterChip(
                  label: Text('${hours.toStringAsFixed(1)} jam'),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _plannedHours = hours),
                  backgroundColor: AppTheme.surface,
                  selectedColor: Color(0xFFDBEAFE),
                  checkmarkColor: AppTheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Reason
            const Text(
              'Alasan Lembur',
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
                hintText:
                    'Detail alasan lembur, tugas yang dikerjakan, atau deadline proyek...',
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
                onPressed: _isSubmitting ? null : _submitOvertime,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Ajukan Lembur'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
