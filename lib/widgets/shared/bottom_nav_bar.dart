import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_theme.dart';
import 'package:attendance_app/core/l10n/app_localizations.dart';

enum AppRole { employee, admin }

class EmployeeBottomNav extends StatefulWidget {
  final int initialIndex;
  final ValueChanged<int> onIndexChanged;

  const EmployeeBottomNav({
    super.key,
    this.initialIndex = 0,
    required this.onIndexChanged,
  });

  @override
  State<EmployeeBottomNav> createState() => _EmployeeBottomNavState();
}

class _EmployeeBottomNavState extends State<EmployeeBottomNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <_NavItem>[
      _NavItem(
        label: l10n.t('home'),
        icon: Icons.home_rounded,
        activeIcon: Icons.home,
      ),
      _NavItem(
        label: l10n.t('attendance'),
        icon: Icons.fingerprint_rounded,
        activeIcon: Icons.fingerprint_rounded,
      ),
      _NavItem(
        label: l10n.t('leave'),
        icon: Icons.event_note_rounded,
        activeIcon: Icons.event_note_rounded,
      ),
      _NavItem(
        label: l10n.t('profile'),
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
      ),
    ];

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        widget.onIndexChanged(index);
      },
      items: items.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon, size: 24),
        activeIcon: Icon(item.activeIcon, size: 24),
        label: item.label,
      )).toList(),
    );
  }
}

class AdminBottomNav extends StatefulWidget {
  final int initialIndex;
  final ValueChanged<int> onIndexChanged;

  const AdminBottomNav({
    super.key,
    this.initialIndex = 0,
    required this.onIndexChanged,
  });

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <_NavItem>[
      _NavItem(
        label: l10n.t('dashboard'),
        icon: Icons.dashboard_rounded,
        activeIcon: Icons.dashboard_rounded,
      ),
      _NavItem(
        label: l10n.t('employees'),
        icon: Icons.people_rounded,
        activeIcon: Icons.people_rounded,
      ),
      _NavItem(
        label: l10n.t('approvals'),
        icon: Icons.approval_rounded,
        activeIcon: Icons.approval_rounded,
      ),
      _NavItem(
        label: l10n.t('reports'),
        icon: Icons.assessment_rounded,
        activeIcon: Icons.assessment_rounded,
      ),
    ];

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        widget.onIndexChanged(index);
      },
      items: items.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon, size: 24),
        activeIcon: Icon(item.activeIcon, size: 24),
        label: item.label,
      )).toList(),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
