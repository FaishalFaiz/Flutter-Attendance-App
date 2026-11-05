/// Local datasource for organization data (Hive)

import 'package:hive/hive.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../domain/entities/organization.dart';
import '../../../../domain/entities/organization_member.dart';
import '../../datasources/local/hive_service.dart;

class OrganizationLocalDataSource {
  OrganizationLocalDataSource._();
  static final OrganizationLocalDataSource _instance = OrganizationLocalDataSource._();
  factory OrganizationLocalDataSource() => _instance;

  Future<void> saveOrganization(Organization org) async {
    try {
      final box = HiveService().organizationBox;
      await box.put(org.id, org);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to save organization: $e');
    }
  }

  Future<List<Organization>> getOrganizations() async {
    try {
      final box = HiveService().organizationBox;
      return box.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get organizations: $e');
    }
  }

  Future<Organization?> getOrganization(String orgId) async {
    try {
      final box = HiveService().organizationBox;
      return box.get(orgId);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get organization: $e');
    }
  }

  Future<void> saveMember(OrganizationMember member) async {
    try {
      final box = HiveService().memberBox;
      await box.put('${member.organizationId}_${member.userId}', member);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to save member: $e');
    }
  }

  Future<List<OrganizationMember>> getMembers(String orgId) async {
    try {
      final box = HiveService().memberBox;
      return box.values
          .where((m) => m.organizationId == orgId)
          .toList();
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get members: $e');
    }
  }

  Future<void> clearOrganizations() async {
    try {
      final box = HiveService().organizationBox;
      await box.clear();
    } catch (e) {
      throw LocalStorageException(message: 'Failed to clear organizations: $e');
    }
  }
}