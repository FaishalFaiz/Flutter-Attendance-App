import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'di/service_locator.dart';
import 'di/seed_demo_data.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize service locator (Hive, etc.)
  await ServiceLocator.hiveService.init();
  await SeedDemoData.initIfEmpty();
  await ServiceLocator.syncManager.syncAll();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
