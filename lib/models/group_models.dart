import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_models.g.dart';

@JsonSerializable()
class GroupModel extends Equatable {
  final String id;
  final String? name;
  @JsonKey(name: 'leader_id')
  final String leaderId;
  @JsonKey(name: 'thesis_id')
  final String? thesisId;
  final List<MemberDetailModel> members;

  const GroupModel({
    required this.id,
    this.name,
    required this.leaderId,
    this.thesisId,
    this.members = const [],
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  @override
  List<Object?> get props => [id, name, leaderId, thesisId, members];
}

@JsonSerializable()
class MemberDetailModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'student_code')
  final String studentCode;
  @JsonKey(name: 'is_leader')
  final bool isLeader;

  const MemberDetailModel({
    required this.userId,
    required this.fullName,
    required this.studentCode,
    this.isLeader = false,
  });

  factory MemberDetailModel.fromJson(Map<String, dynamic> json) => _$MemberDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$MemberDetailModelToJson(this);

  @override
  List<Object?> get props => [userId, fullName, studentCode, isLeader];
}

@JsonSerializable()
class GroupMemberModel extends Equatable {
  @JsonKey(name: 'group_id')
  final String groupId;
  @JsonKey(name: 'student_id')
  final String studentId;
  @JsonKey(name: 'is_leader')
  final bool isLeader;

  const GroupMemberModel({
    required this.groupId,
    required this.studentId,
    this.isLeader = false,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => _$GroupMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);

  @override
  List<Object?> get props => [groupId, studentId, isLeader];
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
  @JsonKey(name: 'student_id')
  final String studentId;
  @JsonKey(name: 'is_leader')
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

// Invite models based on API response
@JsonSerializable()
class InviteDetailModel extends Equatable {
  final String id;
  final int status;
  final UserInInviteModel sender;
  final UserInInviteModel receiver;
  final GroupInInviteModel? group;

  const InviteDetailModel({
    required this.id,
    required this.status,
    required this.sender,
    required this.receiver,
    this.group,
  });

  factory InviteDetailModel.fromJson(Map<String, dynamic> json) => _$InviteDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$InviteDetailModelToJson(this);

  @override
  List<Object?> get props => [id, status, sender, receiver, group];
}

@JsonSerializable()
class UserInInviteModel extends Equatable {
  final String id;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'student_code')
  final String? studentCode;

  const UserInInviteModel({
    required this.id,
    required this.fullName,
    this.studentCode,
  });

  factory UserInInviteModel.fromJson(Map<String, dynamic> json) => _$UserInInviteModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInInviteModelToJson(this);

  @override
  List<Object?> get props => [id, fullName, studentCode];
}

@JsonSerializable()
class GroupInInviteModel extends Equatable {
  final String id;
  final String? name;

  const GroupInInviteModel({
    required this.id,
    this.name,
  });

  factory GroupInInviteModel.fromJson(Map<String, dynamic> json) => _$GroupInInviteModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupInInviteModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class AllInvitesResponse extends Equatable {
  @JsonKey(name: 'received_invites')
  final List<InviteDetailModel> receivedInvites;
  @JsonKey(name: 'sent_invites')
  final List<InviteDetailModel> sentInvites;

  const AllInvitesResponse({
    required this.receivedInvites,
    required this.sentInvites,
  });

  factory AllInvitesResponse.fromJson(Map<String, dynamic> json) => _$AllInvitesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AllInvitesResponseToJson(this);

  @override
  List<Object?> get props => [receivedInvites, sentInvites];
}

@JsonSerializable()
class InviteCreateRequest extends Equatable {
  @JsonKey(name: 'receiver_id')
  final String receiverId;
  @JsonKey(name: 'group_id')
  final String? groupId;

  const InviteCreateRequest({
    required this.receiverId,
    this.groupId,
  });

  factory InviteCreateRequest.fromJson(Map<String, dynamic> json) => _$InviteCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$InviteCreateRequestToJson(this);

  @override
  List<Object?> get props => [receiverId, groupId];
}
