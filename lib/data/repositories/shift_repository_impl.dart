/// Shift repository implementation

import '../../../domain/entities/shift.dart';
import '../../../domain/repositories/shift_repository.dart';
import '../../datasources/remote/firestore_remote_datasource.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  ShiftRepositoryImpl._();
  static final ShiftRepositoryImpl _instance = ShiftRepositoryImpl._();
  factory ShiftRepositoryImpl() => _instance;

  final _remote = FirestoreRemoteDataSource();

  @override
  Future<List<Shift>> getShifts(String organizationId) async {
    return await _remote.getShifts(organizationId);
  }

  @override
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
  }) async {
    return await _remote.createShift(
      organizationId: organizationId,
      name: name,
      startTime: startTime,
      endTime: endTime,
      daysOfWeek: daysOfWeek,
      gracePeriodMinutes: gracePeriodMinutes,
      isOvernight: isOvernight,
      color: color,
      isDefault: isDefault,
    );
  }

  @override
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
  }) async {
    await _remote.updateShift(
      shiftId: shiftId,
      organizationId: organizationId,
      name: name,
      startTime: startTime,
      endTime: endTime,
      daysOfWeek: daysOfWeek,
      gracePeriodMinutes: gracePeriodMinutes,
      isOvernight: isOvernight,
      color: color,
      isDefault: isDefault,
    );
  }

  @override
  Future<void> deleteShift({
    required String shiftId,
    required String organizationId,
  }) async {
    await _remote.deleteShift(shiftId: shiftId, organizationId: organizationId);
  }

  @override
  Future<Shift?> getDefaultShift(String organizationId) async {
    return await _remote.getDefaultShift(organizationId);
  }

  @override
  Stream<List<Shift>> watchShifts(String organizationId) {
    return _remote.watchShifts(organizationId);
  }
}