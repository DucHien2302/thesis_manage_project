import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class GroupRepository {
  final ApiService _apiService;

  GroupRepository({required ApiService apiService}) : _apiService = apiService;
  /// Create a new group
  Future<GroupModel> createGroup(String name) async {
    try {
      print('Debug: Sending create group request with name: $name');
      final response = await _apiService.post(
        '/group',
        body: GroupCreateRequest(name: name).toJson(),
      );
      print('Debug: Create group response: $response');
      return GroupModel.fromJson(response);
    } catch (e) {
      print('Debug: Error in createGroup: $e');
      throw Exception('Không thể tạo nhóm: $e');
    }
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
    try {
      print('Debug: Getting group details for group ID: $groupId');
      final response = await _apiService.get('/group/$groupId/members');
      print('Debug: Group details response: $response');
      return GroupModel.fromJson(response);
    } catch (e) {
      print('Debug: Error getting group details: $e');
      throw Exception('Không thể lấy thông tin chi tiết nhóm: $e');
    }
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

  /// Register thesis for group
  /// API để nhóm trưởng đăng ký một đề tài cho nhóm của mình
  Future<GroupModel> registerThesis(String groupId, String thesisId) async {
    try {
      print('Debug: Registering thesis $thesisId for group $groupId');
      final response = await _apiService.post('/group/$groupId/register-thesis/$thesisId');
      print('Debug: Register thesis response: $response');
      return GroupModel.fromJson(response);
    } catch (e) {
      print('Debug: Error registering thesis: $e');
      throw Exception('Không thể đăng ký đề tài: $e');
    }
  }
}
