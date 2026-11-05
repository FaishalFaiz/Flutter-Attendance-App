/// Seed demo data into Hive for development testing

import 'package:hive/hive.dart';

import '../core/constants/app_constants.dart';
import '../data/datasources/local/hive_service.dart';
import '../domain/entities/organization.dart';
import '../domain/entities/user.dart';

class SeedDemoData {
  SeedDemoData._();

  static Future<void> initIfEmpty() async {
    // Only seed in development/debug
    final hive = HiveService();
    final userBox = hive.userBox;

    if (userBox.isNotEmpty) return;

    // Create demo user
    final demoUser = User(
      id: 'demo_user_001',
      email: 'demo@attendance.app',
      displayName: 'Demo User',
      authProvider: 'email',
      faceVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await userBox.put(demoUser.id, demoUser);

    // Create demo organization
    final demoOrg = Organization(
      id: 'demo_org_001',
      name: 'Demo Company',
      code: 'ATTND01',
      ownerId: demoUser.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final orgBox = hive.organizationBox;
    await orgBox.put(demoOrg.id, demoOrg);

    // Save current user
    await hive.authBox.put('current_user', demoUser);
  }
}
