/// Organization repository contract

import '../entities/organization.dart';
import '../entities/organization_member.dart';

abstract class OrganizationRepository {
  /// Get all organizations for the current user
  Future<List<Organization>> getMyOrganizations();

  /// Create a new organization
  Future<Organization> createOrganization({
    required String name,
    required String ownerId,
  });

  /// Join an organization by invite code
  Future<Organization> joinOrganization({
    required String inviteCode,
    required String userId,
  });

  /// Get organization by ID
  Future<Organization> getOrganization(String orgId);

  /// Update organization settings
  Future<void> updateOrganizationSettings({
    required String orgId,
    required Map<String, dynamic> settings,
  });

  /// Get members of an organization
  Future<List<OrganizationMember>> getMembers(String orgId);

  /// Invite a member to an organization
  Future<void> inviteMember({
    required String orgId,
    required String userId,
    required MemberRole role,
    required String employeeId,
  });

  /// Update member role
  Future<void> updateMemberRole({
    required String orgId,
    required String userId,
    required MemberRole role,
  });

  /// Remove a member from organization
  Future<void> removeMember({
    required String orgId,
    required String userId,
  });

  /// Suspend or reactivate a member
  Future<void> setMemberStatus({
    required String orgId,
    required String userId,
    required MemberStatus status,
  });

  /// Stream of organization members (real-time)
  Stream<List<OrganizationMember>> watchMembers(String orgId);

  /// Stream of organizations (real-time)
  Stream<List<Organization>> watchMyOrganizations();
}