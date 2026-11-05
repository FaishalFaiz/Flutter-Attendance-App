/// Profile screen - manajemen profil pengguna

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_theme.dart';
import '../../../di/service_locator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Pengguna';
  String _email = 'pengguna@perusahaan.com';
  String _role = 'Karyawan';
  String _employeeId = 'EMP001';
  String? _photoBase64;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _faceRegistered = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await ServiceLocator.authRepository.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _name = user?.displayName ?? 'Pengguna';
        _email = user?.email ?? '';
        _photoBase64 = user?.photoUrl;
        _faceRegistered = user?.faceVerified ?? false;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _photoBase64 = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          children: [
            // Profile Photo
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.primaryLight,
                    backgroundImage: _photoBase64 != null && _photoBase64!.isNotEmpty
                        ? MemoryImage(base64Decode(_photoBase64!))
                        : null,
                    child: _photoBase64 == null || _photoBase64!.isEmpty
                        ? const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: AppTheme.primary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 20),
                        onPressed: _pickPhoto,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            // Name
            Text(
              _name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            Text(
              _role,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              _employeeId,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXl),
            // Email
            _buildInfoRow(Icons.email_outlined, 'Email', _email),
            const SizedBox(height: AppTheme.spaceMd),
            _buildInfoRow(Icons.badge_outlined, 'ID Karyawan', _employeeId),
            const SizedBox(height: AppTheme.spaceXl),
            // Face Registration Status
            Card(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _faceRegistered
                        ? AppTheme.secondary.withValues(alpha: 0.1)
                        : AppTheme.textMuted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(
                    _faceRegistered
                        ? Icons.face_rounded
                        : Icons.face_retouching_off_rounded,
                    color: _faceRegistered ? AppTheme.secondary : AppTheme.textMuted,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Verifikasi Wajah',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  _faceRegistered
                      ? 'Wajah telah terdaftar untuk absensi'
                      : 'Belum mendaftar wajah',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: TextButton(
                  onPressed: () => context.go('/face-registration'),
                  child: Text(
                    _faceRegistered ? 'Perbarui' : 'Daftar Wajah',
                    style: const TextStyle(color: AppTheme.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceXl),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () {},
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Simpan Profil'),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () async {
                  await ServiceLocator.authRepository.signOut();
                  if (mounted) context.go('/login');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.danger,
                  side: const BorderSide(color: AppTheme.danger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
                child: const Text('Keluar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.divider),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
