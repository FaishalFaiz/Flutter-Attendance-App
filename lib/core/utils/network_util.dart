/// Network connectivity utilities

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  NetworkUtil._();

  static final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connectivity
  static Future<bool> isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return !results.contains(ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  /// Stream of connectivity changes
  static Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}