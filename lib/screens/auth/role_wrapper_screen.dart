import 'package:flutter/material.dart';
import 'package:attendance_app/screens/employee/home_screen.dart';
import 'package:attendance_app/screens/employee/attendance_screen.dart';
import 'package:attendance_app/screens/employee/leave_request_screen.dart';
import 'package:attendance_app/screens/employee/profile_screen.dart';
import 'package:attendance_app/screens/admin/dashboard_screen.dart';
import 'package:attendance_app/screens/admin/employee_management_screen.dart';
import 'package:attendance_app/screens/admin/leave_approval_screen.dart';
import 'package:attendance_app/screens/admin/reports_screen.dart';
import 'package:attendance_app/widgets/shared/bottom_nav_bar.dart';

// Wrapper that handles role-based navigation state
class RoleWrapperScreen extends StatefulWidget {
  final String role; // 'employee' or 'admin'
  final String username;

  const RoleWrapperScreen({
    super.key,
    required this.role,
    required this.username,
  });

  @override
  State<RoleWrapperScreen> createState() => _RoleWrapperScreenState();
}

class _RoleWrapperScreenState extends State<RoleWrapperScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'admin';

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _buildScreens(),
      ),
      bottomNavigationBar: isAdmin
          ? AdminBottomNav(
              initialIndex: _selectedIndex,
              onIndexChanged: (index) => setState(() => _selectedIndex = index),
            )
          : EmployeeBottomNav(
              initialIndex: _selectedIndex,
              onIndexChanged: (index) => setState(() => _selectedIndex = index),
            ),
    );
  }

  List<Widget> _buildScreens() {
    if (widget.role == 'admin') {
      return [
        const AdminDashboardScreen(),
        const AdminEmployeeManagementScreen(),
        const AdminLeaveApprovalScreen(),
        const AdminReportsScreen(),
      ];
    } else {
      return [
        const EmployeeHomeScreen(),
        const EmployeeAttendanceScreen(),
        const EmployeeLeaveRequestScreen(),
        const EmployeeProfileScreen(),
      ];
    }
  }
}
