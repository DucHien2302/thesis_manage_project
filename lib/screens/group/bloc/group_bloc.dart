import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';

// Events
abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class GetMyGroupsEvent extends GroupEvent {}

class ClearGroupCacheEvent extends GroupEvent {}

class RefreshGroupsEvent extends GroupEvent {}

class CreateGroupEvent extends GroupEvent {
  final String name;

  const CreateGroupEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class AddGroupMemberEvent extends GroupEvent {
  final String groupId;
  final String studentId;
  final bool isLeader;

  const AddGroupMemberEvent({
    required this.groupId, 
    required this.studentId, 
    this.isLeader = false,
  });

  @override
  List<Object?> get props => [groupId, studentId, isLeader];
}

class RemoveGroupMemberEvent extends GroupEvent {
  final String groupId;
  final String memberId;

  const RemoveGroupMemberEvent({
    required this.groupId, 
    required this.memberId,
  });

  @override
  List<Object?> get props => [groupId, memberId];
}

class GetGroupMembersEvent extends GroupEvent {
  final String groupId;

  const GetGroupMembersEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class GetGroupDetailsEvent extends GroupEvent {
  final String groupId;

  const GetGroupDetailsEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class TransferGroupLeadershipEvent extends GroupEvent {
  final String groupId;
  final String newLeaderId;

  const TransferGroupLeadershipEvent({
    required this.groupId, 
    required this.newLeaderId,
  });

  @override
  List<Object?> get props => [groupId, newLeaderId];
}

class SendInviteEvent extends GroupEvent {
  final String receiverId;
  final String? groupId;

  const SendInviteEvent({
    required this.receiverId, 
    this.groupId,
  });

  @override
  List<Object?> get props => [receiverId, groupId];
}

class GetMyInvitesEvent extends GroupEvent {}

class AcceptInviteEvent extends GroupEvent {
  final String inviteId;

  const AcceptInviteEvent({required this.inviteId});

  @override
  List<Object?> get props => [inviteId];
}

class RejectInviteEvent extends GroupEvent {
  final String inviteId;

  const RejectInviteEvent({required this.inviteId});

  @override
  List<Object?> get props => [inviteId];
}

class UpdateGroupNameEvent extends GroupEvent {
  final String groupId;
  final String newName;

  const UpdateGroupNameEvent({required this.groupId, required this.newName});

  @override
  List<Object?> get props => [groupId, newName];
}

class DissolveGroupEvent extends GroupEvent {
  final String groupId;

  const DissolveGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class RevokeInviteEvent extends GroupEvent {
  final String inviteId;

  const RevokeInviteEvent({required this.inviteId});

  @override
  List<Object?> get props => [inviteId];
}

class RegisterThesisEvent extends GroupEvent {
  final String groupId;
  final String thesisId;

  const RegisterThesisEvent({
    required this.groupId,
    required this.thesisId,
  });

  @override
  List<Object?> get props => [groupId, thesisId];
}

// States
abstract class GroupState extends Equatable {
  const GroupState();
  
  @override
  List<Object?> get props => [];
}

class GroupInitialState extends GroupState {}

class GroupLoadingState extends GroupState {}

class MyGroupsLoadedState extends GroupState {
  final List<GroupModel> groups;

  const MyGroupsLoadedState({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GroupCreatedState extends GroupState {
  final GroupModel group;

  const GroupCreatedState({required this.group});

  @override
  List<Object?> get props => [group];
}

class GroupCreatingState extends GroupState {
  final String message;

  const GroupCreatingState({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemberAddedState extends GroupState {
  final GroupMemberModel member;

  const MemberAddedState({required this.member});

  @override
  List<Object?> get props => [member];
}

class MemberRemovedState extends GroupState {}

class GroupMembersLoadedState extends GroupState {
  final List<MemberDetailModel> members;

  const GroupMembersLoadedState({required this.members});

  @override
  List<Object?> get props => [members];
}

class GroupDetailsLoadedState extends GroupState {
  final GroupModel group;

  const GroupDetailsLoadedState({required this.group});

  @override
  List<Object?> get props => [group];
}

class LeadershipTransferredState extends GroupState {}

class InviteSentState extends GroupState {}

class InvitesLoadedState extends GroupState {
  final AllInvitesResponse allInvites;

  const InvitesLoadedState({required this.allInvites});

  @override
  List<Object?> get props => [allInvites];
}

class InviteActionSuccessState extends GroupState {
  final String action;  // "accepted", "rejected", or "revoked"

  const InviteActionSuccessState({required this.action});

  @override
  List<Object?> get props => [action];
}

class GroupNameUpdatedState extends GroupState {
  final GroupModel updatedGroup;

  const GroupNameUpdatedState({required this.updatedGroup});

  @override
  List<Object?> get props => [updatedGroup];
}

class GroupDissolvedState extends GroupState {}

class ThesisRegisteredState extends GroupState {
  final GroupModel updatedGroup;

  const ThesisRegisteredState({required this.updatedGroup});

  @override
  List<Object?> get props => [updatedGroup];
}

class GroupErrorState extends GroupState {
  final String error;

  const GroupErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

// Bloc
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;
  
  // Cache for groups to avoid losing data when switching tabs
  List<GroupModel>? _cachedGroups;
  DateTime? _lastGroupsUpdate;
  static const Duration _cacheTimeout = Duration(minutes: 5);
  bool _isFetching = false; // Flag to prevent multiple concurrent requests

  GroupBloc({required this.groupRepository}) : super(GroupInitialState()) {
    on<GetMyGroupsEvent>(_onGetMyGroups);
    on<RefreshGroupsEvent>(_onRefreshGroups);
    on<ClearGroupCacheEvent>(_onClearGroupCache);
    on<CreateGroupEvent>(_onCreateGroup);
    on<AddGroupMemberEvent>(_onAddGroupMember);
    on<RemoveGroupMemberEvent>(_onRemoveGroupMember);
    on<GetGroupMembersEvent>(_onGetGroupMembers);
    on<GetGroupDetailsEvent>(_onGetGroupDetails);
    on<UpdateGroupNameEvent>(_onUpdateGroupName);
    on<DissolveGroupEvent>(_onDissolveGroup);
    on<RegisterThesisEvent>(_onRegisterThesis);
    on<SendInviteEvent>(_onSendInvite);
    on<GetMyInvitesEvent>(_onGetMyInvites);
    on<AcceptInviteEvent>(_onAcceptInvite);
    on<RejectInviteEvent>(_onRejectInvite);    on<RevokeInviteEvent>(_onRevokeInvite);
  }  Future<void> _onGetMyGroups(GetMyGroupsEvent event, Emitter<GroupState> emit) async {
    // Prevent multiple concurrent requests
    if (_isFetching) return;
    
    // Check if we have valid cached data
    if (_cachedGroups != null && 
        _lastGroupsUpdate != null && 
        DateTime.now().difference(_lastGroupsUpdate!) < _cacheTimeout) {
      emit(MyGroupsLoadedState(groups: _cachedGroups!));
      return;
    }

    _isFetching = true;
    emit(GroupLoadingState());
    try {
      final groups = await groupRepository.getMyGroups();
      _cachedGroups = groups;
      _lastGroupsUpdate = DateTime.now();
      emit(MyGroupsLoadedState(groups: groups));
    } catch (e) {
      // If we have cached data, fall back to it even if the request fails
      if (_cachedGroups != null) {
        emit(MyGroupsLoadedState(groups: _cachedGroups!));
      } else {
        emit(GroupErrorState(error: e.toString()));
      }
    } finally {
      _isFetching = false;
    }
  }  Future<void> _onCreateGroup(CreateGroupEvent event, Emitter<GroupState> emit) async {
    print('Debug: Creating group with name: ${event.name}');
    emit(const GroupCreatingState(message: 'Đang tạo nhóm...'));
    
    try {
      // Step 1: Create the group
      final group = await groupRepository.createGroup(event.name);
      print('Debug: Group created successfully: ${group.toJson()}');
      
      // Step 2: Get detailed group information with members
      emit(const GroupCreatingState(message: 'Đang tải thông tin nhóm...'));
      print('Debug: Fetching detailed group info for group ID: ${group.id}');
      final detailedGroup = await groupRepository.getGroupDetails(group.id);
      print('Debug: Detailed group info: ${detailedGroup.toJson()}');
      
      // Update cache with detailed group information
      if (_cachedGroups != null) {
        _cachedGroups!.add(detailedGroup);
        _lastGroupsUpdate = DateTime.now();
      }
      
      emit(GroupCreatedState(group: detailedGroup));
    } catch (e) {
      print('Debug: Error creating group: $e');
      emit(GroupErrorState(error: e.toString()));
    }
  }

  Future<void> _onAddGroupMember(AddGroupMemberEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final member = await groupRepository.addGroupMember(
        event.groupId, 
        event.studentId, 
        event.isLeader,
      );
      emit(MemberAddedState(member: member));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }

  Future<void> _onRemoveGroupMember(RemoveGroupMemberEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.removeGroupMember(event.groupId, event.memberId);
      emit(MemberRemovedState());
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }
  Future<void> _onGetGroupMembers(GetGroupMembersEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final groupDetails = await groupRepository.getGroupDetails(event.groupId);
      emit(GroupMembersLoadedState(members: groupDetails.members));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }

  Future<void> _onGetGroupDetails(GetGroupDetailsEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final groupDetails = await groupRepository.getGroupDetails(event.groupId);
      emit(GroupDetailsLoadedState(group: groupDetails));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }

  Future<void> _onTransferGroupLeadership(
      TransferGroupLeadershipEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.transferGroupLeadership(
        event.groupId, 
        event.newLeaderId,
      );
      emit(LeadershipTransferredState());
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }  Future<void> _onSendInvite(SendInviteEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.sendInvite(event.receiverId, groupId: event.groupId);
      emit(InviteSentState());
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }
  Future<void> _onGetMyInvites(GetMyInvitesEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final allInvites = await groupRepository.getAllMyInvites();
      emit(InvitesLoadedState(allInvites: allInvites));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }
  Future<void> _onAcceptInvite(AcceptInviteEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.acceptInvite(event.inviteId);
      // Clear cache since user now has a new group
      _cachedGroups = null;
      _lastGroupsUpdate = null;
      emit(const InviteActionSuccessState(action: "accepted"));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }

  Future<void> _onRejectInvite(RejectInviteEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.rejectInvite(event.inviteId);
      emit(const InviteActionSuccessState(action: "rejected"));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }

  Future<void> _onRevokeInvite(RevokeInviteEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.revokeInvite(event.inviteId);
      emit(const InviteActionSuccessState(action: "revoked"));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }
  Future<void> _onUpdateGroupName(UpdateGroupNameEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final updatedGroup = await groupRepository.updateGroupName(
        event.groupId,
        event.newName,
      );
      
      // Update cache with new group name
      if (_cachedGroups != null) {
        final index = _cachedGroups!.indexWhere((g) => g.id == event.groupId);
        if (index != -1) {
          _cachedGroups![index] = updatedGroup;
          _lastGroupsUpdate = DateTime.now();
        }
      }
      
      emit(GroupNameUpdatedState(updatedGroup: updatedGroup));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }
  
  Future<void> _onDissolveGroup(DissolveGroupEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.deleteGroup(event.groupId);
      
      // Remove group from cache
      if (_cachedGroups != null) {
        _cachedGroups!.removeWhere((group) => group.id == event.groupId);
        _lastGroupsUpdate = DateTime.now();
      }
      
      emit(GroupDissolvedState());
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }  }

  // Register thesis for group
  Future<void> _onRegisterThesis(RegisterThesisEvent event, Emitter<GroupState> emit) async {
    try {
      emit(GroupLoadingState());
      final updatedGroup = await groupRepository.registerThesis(event.groupId, event.thesisId);
      
      // Update cache if exists
      if (_cachedGroups != null) {
        final index = _cachedGroups!.indexWhere((group) => group.id == event.groupId);
        if (index != -1) {
          _cachedGroups![index] = updatedGroup;
          _lastGroupsUpdate = DateTime.now();
        }
      }
      
      emit(ThesisRegisteredState(updatedGroup: updatedGroup));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }

  // Method to refresh groups by clearing cache and fetching new data
  Future<void> _onRefreshGroups(RefreshGroupsEvent event, Emitter<GroupState> emit) async {
    _cachedGroups = null;
    _lastGroupsUpdate = null;
    add(GetMyGroupsEvent());
  }

  // Method to clear cache
  Future<void> _onClearGroupCache(ClearGroupCacheEvent event, Emitter<GroupState> emit) async {
    _cachedGroups = null;
    _lastGroupsUpdate = null;
  }
}
