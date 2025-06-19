import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_models.g.dart';

@JsonSerializable()
class GroupModel extends Equatable {
  final String id;
  final String name;
  final String leaderId;
  final List<GroupMemberModel> members;

  const GroupModel({
    required this.id,
    required this.name,
    required this.leaderId,
    this.members = const [],
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  @override
  List<Object?> get props => [id, name, leaderId, members];
}

@JsonSerializable()
class GroupMemberModel extends Equatable {
  final String userId;
  final String fullName;
  final String studentCode;
  final bool isLeader;

  const GroupMemberModel({
    required this.userId,
    required this.fullName,
    required this.studentCode,
    this.isLeader = false,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => _$GroupMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);

  @override
  List<Object?> get props => [userId, fullName, studentCode, isLeader];
}

@JsonSerializable()
class GroupCreateRequest extends Equatable {
  final String name;

  const GroupCreateRequest({
    required this.name,
  });

  factory GroupCreateRequest.fromJson(Map<String, dynamic> json) => _$GroupCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GroupCreateRequestToJson(this);

  @override
  List<Object?> get props => [name];
}

@JsonSerializable()
class GroupMemberAddRequest extends Equatable {
  final String studentId;
  final bool isLeader;

  const GroupMemberAddRequest({
    required this.studentId,
    this.isLeader = false,
  });

  factory GroupMemberAddRequest.fromJson(Map<String, dynamic> json) => _$GroupMemberAddRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberAddRequestToJson(this);

  @override
  List<Object?> get props => [studentId, isLeader];
}

@JsonSerializable()
class InviteModel extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String? groupId;
  final String senderName;
  final String? groupName;
  final int status; // 1: pending, 2: accepted, 3: rejected, 4: revoked

  const InviteModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.groupId,
    required this.senderName,
    this.groupName,
    required this.status,
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) => _$InviteModelFromJson(json);
  Map<String, dynamic> toJson() => _$InviteModelToJson(this);

  @override
  List<Object?> get props => [id, senderId, receiverId, groupId, senderName, groupName, status];
}

@JsonSerializable()
class InviteCreateRequest extends Equatable {
  final String receiverId;
  final String? groupId;
  final int status;

  const InviteCreateRequest({
    required this.receiverId,
    this.groupId,
    this.status = 1,
  });

  factory InviteCreateRequest.fromJson(Map<String, dynamic> json) => _$InviteCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$InviteCreateRequestToJson(this);

  @override
  List<Object?> get props => [receiverId, groupId, status];
}
