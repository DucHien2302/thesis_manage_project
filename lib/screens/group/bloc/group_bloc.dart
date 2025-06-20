import 'package:bloc/bloc.dart';
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

class LeaveGroupEvent extends GroupEvent {
  final String groupId;

  const LeaveGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class RevokeInviteEvent extends GroupEvent {
  final String inviteId;

  const RevokeInviteEvent({required this.inviteId});

  @override
  List<Object?> get props => [inviteId];
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

class GroupLeftState extends GroupState {}

class GroupErrorState extends GroupState {
  final String error;

  const GroupErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

// Bloc
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;

  GroupBloc({required this.groupRepository}) : super(GroupInitialState()) {
    on<GetMyGroupsEvent>(_onGetMyGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<AddGroupMemberEvent>(_onAddGroupMember);
    on<RemoveGroupMemberEvent>(_onRemoveGroupMember);
    on<GetGroupMembersEvent>(_onGetGroupMembers);
    on<TransferGroupLeadershipEvent>(_onTransferGroupLeadership);
    on<SendInviteEvent>(_onSendInvite);
    on<GetMyInvitesEvent>(_onGetMyInvites);
    on<AcceptInviteEvent>(_onAcceptInvite);
    on<RejectInviteEvent>(_onRejectInvite);
    on<RevokeInviteEvent>(_onRevokeInvite);
    on<UpdateGroupNameEvent>(_onUpdateGroupName);
    on<LeaveGroupEvent>(_onLeaveGroup);
  }

  Future<void> _onGetMyGroups(GetMyGroupsEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final groups = await groupRepository.getMyGroups();
      emit(MyGroupsLoadedState(groups: groups));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }

  Future<void> _onCreateGroup(CreateGroupEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final group = await groupRepository.createGroup(event.name);
      emit(GroupCreatedState(group: group));
    } catch (e) {
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
      emit(GroupNameUpdatedState(updatedGroup: updatedGroup));
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }
  Future<void> _onLeaveGroup(LeaveGroupEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      await groupRepository.deleteGroup(event.groupId);
      emit(GroupLeftState());
    } catch (e) {
      emit(GroupErrorState(error: e.toString()));
    }
  }
}
