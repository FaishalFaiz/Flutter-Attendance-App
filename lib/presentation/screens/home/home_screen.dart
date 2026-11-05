/// Home screen - main dashboard after org selection

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const _DashboardTab(),
    const _AttendanceTab(),
    const _HistoryTab(),
    const _LeaveTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _items.length,
            (index) {
              final item = _items[index];
              final selected = index == _selectedIndex;
              return InkWell(
                onTap: () => setState(() => _selectedIndex = index),
                borderRadius: BorderRadius.circular(100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: selected ? 16 : 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF2563EB) : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: selected ? Colors.white : const Color(0xFF64748B),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 6),
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static const _items = [
    (label: 'Home', icon: Icons.home_rounded),
    (label: 'Scan', icon: Icons.filter_center_focus_rounded),
    (label: 'History', icon: Icons.receipt_long_rounded),
    (label: 'Leave', icon: Icons.description_outlined),
    (label: 'Profile', icon: Icons.person_outline_rounded),
  ];
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard_rounded, size: 64, color: Color(0xFF2563EB)),
          SizedBox(height: 16),
          Text(
            'Attendance Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selamat datang di platform absensi',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_rounded,
              size: 64, color: Color(0xFF2563EB)),
          const SizedBox(height: 16),
          const Text(
            'Absensi Wajah',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scan wajah untuk check in/out',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 32),
          ...AttendanceAction.values.map((action) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: 260,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => context.push(
                  '/attend?action=${action.name}',
                ),
                icon: Icon(_getIcon(action), size: 20),
                label: Text(_getTitle(action)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColor(action),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  IconData _getIcon(AttendanceAction action) {
    switch (action) {
      case AttendanceAction.checkIn: return Icons.login_rounded;
      case AttendanceAction.checkOut: return Icons.logout_rounded;
      case AttendanceAction.breakStart: return Icons.pause_rounded;
      case AttendanceAction.breakEnd: return Icons.play_arrow_rounded;
      case AttendanceAction.overtimeStart: return Icons.schedule_rounded;
      case AttendanceAction.overtimeEnd: return Icons.schedule_rounded;
    }
  }

  String _getTitle(AttendanceAction action) {
    switch (action) {
      case AttendanceAction.checkIn: return 'Check In';
      case AttendanceAction.checkOut: return 'Check Out';
      case AttendanceAction.breakStart: return 'Mulai Istirahat';
      case AttendanceAction.breakEnd: return 'Selesai Istirahat';
      case AttendanceAction.overtimeStart: return 'Mulai Lembur';
      case AttendanceAction.overtimeEnd: return 'Selesai Lembur';
    }
  }

  Color _getColor(AttendanceAction action) {
    switch (action) {
      case AttendanceAction.checkIn: return const Color(0xFF10B981);
      case AttendanceAction.checkOut: return const Color(0xFFEF4444);
      case AttendanceAction.breakStart: return const Color(0xFFF59E0B);
      case AttendanceAction.breakEnd: return const Color(0xFFF59E0B);
      case AttendanceAction.overtimeStart: return const Color(0xFF8B5CF6);
      case AttendanceAction.overtimeEnd: return const Color(0xFF8B5CF6);
    }
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: Color(0xFF2563EB)),
          SizedBox(height: 16),
          Text(
            'Riwayat Absensi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Lihat riwayat absensi Anda',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _LeaveTab extends StatelessWidget {
  const _LeaveTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: Color(0xFF2563EB)),
          SizedBox(height: 16),
          Text(
            'Pengajuan Cuti',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ajukan dan kelola permintaan cuti',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline_rounded,
              size: 64, color: Color(0xFF2563EB)),
          SizedBox(height: 16),
          Text(
            'Profil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kelola profil dan data wajah',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
