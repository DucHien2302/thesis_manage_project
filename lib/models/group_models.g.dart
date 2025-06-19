// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
  id: json['id'] as String,
  name: json['name'] as String,
  leaderId: json['leaderId'] as String,
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'leaderId': instance.leaderId,
      'members': instance.members,
    };

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    GroupMemberModel(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      studentCode: json['studentCode'] as String,
      isLeader: json['isLeader'] as bool? ?? false,
    );

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'studentCode': instance.studentCode,
      'isLeader': instance.isLeader,
    };

GroupCreateRequest _$GroupCreateRequestFromJson(Map<String, dynamic> json) =>
    GroupCreateRequest(name: json['name'] as String);

Map<String, dynamic> _$GroupCreateRequestToJson(GroupCreateRequest instance) =>
    <String, dynamic>{'name': instance.name};

GroupMemberAddRequest _$GroupMemberAddRequestFromJson(
  Map<String, dynamic> json,
) => GroupMemberAddRequest(
  studentId: json['studentId'] as String,
  isLeader: json['isLeader'] as bool? ?? false,
);

Map<String, dynamic> _$GroupMemberAddRequestToJson(
  GroupMemberAddRequest instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'isLeader': instance.isLeader,
};

InviteModel _$InviteModelFromJson(Map<String, dynamic> json) => InviteModel(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  receiverId: json['receiverId'] as String,
  groupId: json['groupId'] as String?,
  senderName: json['senderName'] as String,
  groupName: json['groupName'] as String?,
  status: (json['status'] as num).toInt(),
);

Map<String, dynamic> _$InviteModelToJson(InviteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'groupId': instance.groupId,
      'senderName': instance.senderName,
      'groupName': instance.groupName,
      'status': instance.status,
    };

InviteCreateRequest _$InviteCreateRequestFromJson(Map<String, dynamic> json) =>
    InviteCreateRequest(
      receiverId: json['receiverId'] as String,
      groupId: json['groupId'] as String?,
      status: (json['status'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$InviteCreateRequestToJson(
  InviteCreateRequest instance,
) => <String, dynamic>{
  'receiverId': instance.receiverId,
  'groupId': instance.groupId,
  'status': instance.status,
};
