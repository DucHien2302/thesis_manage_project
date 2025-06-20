import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class GroupRepository {
  final ApiService _apiService;

  GroupRepository({required ApiService apiService}) : _apiService = apiService;

  /// Create a new group
  Future<GroupModel> createGroup(String name) async {
    final response = await _apiService.post(
      '/group',
      body: GroupCreateRequest(name: name).toJson(),
    );
    return GroupModel.fromJson(response);
  }

  /// Get all groups that the current user is a member of
  Future<List<GroupModel>> getMyGroups() async {
    final response = await _apiService.get('/group/my-groups');
    final List<dynamic> data = response;
    return data.map((group) => GroupModel.fromJson(group)).toList();
  }

  /// Add a member to a group
  Future<GroupMemberModel> addGroupMember(String groupId, String studentId, bool isLeader) async {
    final response = await _apiService.post(
      '/group/$groupId/add-member',
      body: GroupMemberAddRequest(studentId: studentId, isLeader: isLeader).toJson(),
    );
    return GroupMemberModel.fromJson(response);
  }

  /// Remove a member from a group
  Future<void> removeGroupMember(String groupId, String memberId) async {
    await _apiService.delete('/group/$groupId/remove-member/$memberId');
  }

  /// Get group details with members
  Future<GroupModel> getGroupDetails(String groupId) async {
    final response = await _apiService.get('/group/$groupId/members');
    return GroupModel.fromJson(response);
  }

  /// Transfer group leadership to another member
  Future<void> transferGroupLeadership(String groupId, String newLeaderId) async {
    await _apiService.put('/group/$groupId/transfer-leader/$newLeaderId');
  }  /// Send an invitation to join a group
  Future<void> sendInvite(String receiverId, {String? groupId}) async {
    await _apiService.post(
      '/invite/send',
      body: InviteCreateRequest(receiverId: receiverId, groupId: groupId).toJson(),
    );
  }

  /// Accept a group invitation
  Future<void> acceptInvite(String inviteId) async {
    await _apiService.post('/invite/accept/$inviteId');
  }

  /// Reject a group invitation
  Future<void> rejectInvite(String inviteId) async {
    await _apiService.post('/invite/reject/$inviteId');
  }

  /// Revoke (cancel) a sent invitation
  Future<void> revokeInvite(String inviteId) async {
    await _apiService.post('/invite/revoke/$inviteId');
  }

  /// Update group name
  Future<GroupModel> updateGroupName(String groupId, String newName) async {
    final response = await _apiService.put(
      '/group/$groupId/name',
      body: {'new_name': newName},
    );
    return GroupModel.fromJson(response);
  }

  /// Delete group
  Future<void> deleteGroup(String groupId) async {
    await _apiService.delete('/group/$groupId');
  }

  /// Get the current user's group (if any)
  Future<GroupModel?> getCurrentUserGroup() async {
    try {
      final groups = await getMyGroups();
      return groups.isNotEmpty ? groups.first : null;
    } catch (e) {
      return null;
    }
  }

  /// Get all invitations for the current user (both sent and received)
  Future<AllInvitesResponse> getAllMyInvites() async {
    final response = await _apiService.get('/invite/all-my-invites');
    return AllInvitesResponse.fromJson(response);
  }
}
