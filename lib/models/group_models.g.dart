// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
  id: json['id'] as String,
  name: json['name'] as String?,
  leaderId: json['leader_id'] as String,
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => MemberDetailModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'leader_id': instance.leaderId,
      'members': instance.members,
    };

MemberDetailModel _$MemberDetailModelFromJson(Map<String, dynamic> json) =>
    MemberDetailModel(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      studentCode: json['student_code'] as String,
      isLeader: json['is_leader'] as bool? ?? false,
    );

Map<String, dynamic> _$MemberDetailModelToJson(MemberDetailModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'student_code': instance.studentCode,
      'is_leader': instance.isLeader,
    };

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    GroupMemberModel(
      groupId: json['group_id'] as String,
      studentId: json['student_id'] as String,
      isLeader: json['is_leader'] as bool? ?? false,
    );

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'student_id': instance.studentId,
      'is_leader': instance.isLeader,
    };

GroupCreateRequest _$GroupCreateRequestFromJson(Map<String, dynamic> json) =>
    GroupCreateRequest(name: json['name'] as String);

Map<String, dynamic> _$GroupCreateRequestToJson(GroupCreateRequest instance) =>
    <String, dynamic>{'name': instance.name};

GroupMemberAddRequest _$GroupMemberAddRequestFromJson(
  Map<String, dynamic> json,
) => GroupMemberAddRequest(
  studentId: json['student_id'] as String,
  isLeader: json['is_leader'] as bool? ?? false,
);

Map<String, dynamic> _$GroupMemberAddRequestToJson(
  GroupMemberAddRequest instance,
) => <String, dynamic>{
  'student_id': instance.studentId,
  'is_leader': instance.isLeader,
};

InviteDetailModel _$InviteDetailModelFromJson(
  Map<String, dynamic> json,
) => InviteDetailModel(
  id: json['id'] as String,
  status: (json['status'] as num).toInt(),
  sender: UserInInviteModel.fromJson(json['sender'] as Map<String, dynamic>),
  receiver: UserInInviteModel.fromJson(
    json['receiver'] as Map<String, dynamic>,
  ),
  group:
      json['group'] == null
          ? null
          : GroupInInviteModel.fromJson(json['group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InviteDetailModelToJson(InviteDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'group': instance.group,
    };

UserInInviteModel _$UserInInviteModelFromJson(Map<String, dynamic> json) =>
    UserInInviteModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      studentCode: json['student_code'] as String?,
    );

Map<String, dynamic> _$UserInInviteModelToJson(UserInInviteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'student_code': instance.studentCode,
    };

GroupInInviteModel _$GroupInInviteModelFromJson(Map<String, dynamic> json) =>
    GroupInInviteModel(id: json['id'] as String, name: json['name'] as String?);

Map<String, dynamic> _$GroupInInviteModelToJson(GroupInInviteModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

AllInvitesResponse _$AllInvitesResponseFromJson(Map<String, dynamic> json) =>
    AllInvitesResponse(
      receivedInvites:
          (json['received_invites'] as List<dynamic>)
              .map((e) => InviteDetailModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      sentInvites:
          (json['sent_invites'] as List<dynamic>)
              .map((e) => InviteDetailModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$AllInvitesResponseToJson(AllInvitesResponse instance) =>
    <String, dynamic>{
      'received_invites': instance.receivedInvites,
      'sent_invites': instance.sentInvites,
    };

InviteCreateRequest _$InviteCreateRequestFromJson(Map<String, dynamic> json) =>
    InviteCreateRequest(
      receiverId: json['receiver_id'] as String,
      groupId: json['group_id'] as String?,
    );

Map<String, dynamic> _$InviteCreateRequestToJson(
  InviteCreateRequest instance,
) => <String, dynamic>{
  'receiver_id': instance.receiverId,
  'group_id': instance.groupId,
};
