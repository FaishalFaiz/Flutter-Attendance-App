/// Shift repository contract

import '../entities/shift.dart';

abstract class ShiftRepository {
  /// Get all shifts for an organization
  Future<List<Shift>> getShifts(String organizationId);

  /// Create a new shift
  Future<Shift> createShift({
    required String organizationId,
    required String name,
    required String startTime,
    required String endTime,
    required List<int> daysOfWeek,
    int gracePeriodMinutes = 15,
    bool isOvernight = false,
    String color = '#2563EB',
    bool isDefault = false,
  });

  /// Update a shift
  Future<void> updateShift({
    required String shiftId,
    required String organizationId,
    String? name,
    String? startTime,
    String? endTime,
    List<int>? daysOfWeek,
    int? gracePeriodMinutes,
    bool? isOvernight,
    String? color,
    bool? isDefault,
  });

  /// Delete a shift
  Future<void> deleteShift({
    required String shiftId,
    required String organizationId,
  });

  /// Get default shift for an organization
  Future<Shift?> getDefaultShift(String organizationId);

  /// Stream of shifts (real-time)
  Stream<List<Shift>> watchShifts(String organizationId);
}