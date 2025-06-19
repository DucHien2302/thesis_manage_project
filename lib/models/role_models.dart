import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role_models.g.dart';

@JsonSerializable()
class RoleModel extends Equatable {
  final String code;
  final String name;
  final String description;
  final int status;

  const RoleModel({
    required this.code,
    required this.name,
    required this.description,
    required this.status,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$RoleModelToJson(this);

  @override
  List<Object?> get props => [code, name, description, status];
}

@JsonSerializable()
class FunctionModel extends Equatable {
  final int id;
  final String name;
  final String? path;
  final String type;
  final int? parentId;
  final String? description;
  final String status;
  final bool isAssigned;
  final List<FunctionModel> children;

  const FunctionModel({
    required this.id,
    required this.name,
    this.path,
    required this.type,
    this.parentId,
    this.description,
    required this.status,
    this.isAssigned = false,
    this.children = const [],
  });

  factory FunctionModel.fromJson(Map<String, dynamic> json) => _$FunctionModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$FunctionModelToJson(this);

  @override
  List<Object?> get props => [id, name, path, type, parentId, description, status, isAssigned, children];
}

@JsonSerializable()
class RoleResponseTree extends Equatable {
  final int id;
  final String roleId;
  final String roleName;
  final String? description;
  final String status;
  final List<FunctionModel> function;

  const RoleResponseTree({
    required this.id,
    required this.roleId, 
    required this.roleName,
    this.description,
    required this.status,
    required this.function,
  });

  factory RoleResponseTree.fromJson(Map<String, dynamic> json) => _$RoleResponseTreeFromJson(json);
  
  Map<String, dynamic> toJson() => _$RoleResponseTreeToJson(this);

  @override
  List<Object?> get props => [id, roleId, roleName, description, status, function];
}

@JsonSerializable()
class UserRoleAssignment extends Equatable {
  final String userId;
  final int roleId;

  const UserRoleAssignment({
    required this.userId,
    required this.roleId,
  });

  factory UserRoleAssignment.fromJson(Map<String, dynamic> json) => _$UserRoleAssignmentFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserRoleAssignmentToJson(this);

  @override
  List<Object?> get props => [userId, roleId];
}
