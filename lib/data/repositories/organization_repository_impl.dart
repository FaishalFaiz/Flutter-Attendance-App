/// Organization repository implementation

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/organization.dart';
import '../../../domain/entities/organization_member.dart';
import '../../../domain/repositories/organization_repository.dart';
import '../datasources/local/org_local_datasource.dart';
import '../datasources/remote/firestore_remote_datasource.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  OrganizationRepositoryImpl._();
  static final OrganizationRepositoryImpl _instance =
      OrganizationRepositoryImpl._();
  factory OrganizationRepositoryImpl() => _instance;

  final _remote = FirestoreRemoteDataSource();
  final _local = OrganizationLocalDataSource();

  @override
  Future<List<Organization>> getMyOrganizations() async {
    final remote = await _remote.getMyOrganizations();
    // Cache locally
    for (final org in remote) {
      await _local.saveOrganization(org);
    }
    return remote;
  }

  @override
  Future<Organization> createOrganization({
    required String name,
    required String ownerId,
  }) async {
    final org = await _remote.createOrganization(name: name, ownerId: ownerId);
    await _local.saveOrganization(org);
    return org;
  }

  @override
  Future<Organization> joinOrganization({
    required String inviteCode,
    required String userId,
  }) async {
    final org = await _remote.joinOrganization(
      inviteCode: inviteCode,
      userId: userId,
    );
    await _local.saveOrganization(org);
    return org;
  }

  @override
  Future<Organization> getOrganization(String orgId) async {
    // Try local first
    final local = await _local.getOrganization(orgId);
    if (local != null) return local;

    // Fall back to remote
    return await _remote.getOrganization(orgId);
  }

  @override
  Future<void> updateOrganizationSettings({
    required String orgId,
    required Map<String, dynamic> settings,
  }) async {
    await _remote.updateOrganizationSettings(orgId: orgId, settings: settings);
  }

  @override
  Future<List<OrganizationMember>> getMembers(String orgId) async {
    return await _remote.getMembers(orgId);
  }

  @override
  Future<void> inviteMember({
    required String orgId,
    required String userId,
    required MemberRole role,
    required String employeeId,
  }) async {
    await _remote.inviteMember(
      orgId: orgId,
      userId: userId,
      role: role.name,
      employeeId: employeeId,
    );
  }

  @override
  Future<void> updateMemberRole({
    required String orgId,
    required String userId,
    required MemberRole role,
  }) async {
    await _remote.updateMemberRole(
      orgId: orgId,
      userId: userId,
      role: role.name,
    );
  }

  @override
  Future<void> removeMember({
    required String orgId,
    required String userId,
  }) async {
    await _remote.removeMember(orgId: orgId, userId: userId);
  }

  @override
  Future<void> setMemberStatus({
    required String orgId,
    required String userId,
    required MemberStatus status,
  }) async {
    await _remote.setMemberStatus(
      orgId: orgId,
      userId: userId,
      status: status.name,
    );
  }

  @override
  Stream<List<OrganizationMember>> watchMembers(String orgId) {
    return _remote.watchMembers(orgId);
  }

  @override
  Stream<List<Organization>> watchMyOrganizations() {
    return _remote.watchMyOrganizations();
  }
}