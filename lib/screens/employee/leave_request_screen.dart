import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EmployeeLeaveRequestScreen extends StatefulWidget {
  const EmployeeLeaveRequestScreen({super.key});

  @override
  State<EmployeeLeaveRequestScreen> createState() =>
      _EmployeeLeaveRequestScreenState();
}

class _EmployeeLeaveRequestScreenState
    extends State<EmployeeLeaveRequestScreen> {
  final _reasonController = TextEditingController();
  String _selectedType = 'Cuti Tahunan';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _leaveTypes = [
    'Cuti Tahunan',
    'Cuti Sakit',
    'Cuti Pribadi',
    'Cuti Melahirkan',
    'Cuti Kahwin',
    'Izin',
  ];

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (_reasonController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan lengkapi semua kolom'),
          backgroundColor: AppTheme.statusAbsent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pengajuan cuti berhasil dikirim'),
        backgroundColor: AppTheme.statusPresent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: Text(l10n.t('leave'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.t('leave_type'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: _leaveTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (val) => setState(() => _selectedType = val ?? ''),
              value: _selectedType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.t('start_date'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDate(context, true),
              child: IgnorePointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _startDate == null
                        ? 'Pilih tanggal mulai'
                        : DateFormat('dd MMM yyyy').format(_startDate!),
                    prefixIcon: const Icon(Icons.calendar_today_rounded),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.t('end_date'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDate(context, false),
              child: IgnorePointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _endDate == null
                        ? 'Pilih tanggal selesai'
                        : DateFormat('dd MMM yyyy').format(_endDate!),
                    prefixIcon: const Icon(Icons.calendar_today_rounded),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.t('leave_reason'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis alasan cuti Anda...',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(l10n.t('submit')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
