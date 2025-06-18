// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => RoleModel(
  code: json['code'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  status: (json['status'] as num).toInt(),
);

Map<String, dynamic> _$RoleModelToJson(RoleModel instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
};

FunctionModel _$FunctionModelFromJson(Map<String, dynamic> json) =>
    FunctionModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      path: json['path'] as String?,
      type: json['type'] as String,
      parentId: (json['parentId'] as num?)?.toInt(),
      description: json['description'] as String?,
      status: json['status'] as String,
      isAssigned: json['isAssigned'] as bool? ?? false,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => FunctionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FunctionModelToJson(FunctionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'type': instance.type,
      'parentId': instance.parentId,
      'description': instance.description,
      'status': instance.status,
      'isAssigned': instance.isAssigned,
      'children': instance.children,
    };

RoleResponseTree _$RoleResponseTreeFromJson(Map<String, dynamic> json) =>
    RoleResponseTree(
      id: (json['id'] as num).toInt(),
      roleId: json['roleId'] as String,
      roleName: json['roleName'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      function:
          (json['function'] as List<dynamic>)
              .map((e) => FunctionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$RoleResponseTreeToJson(RoleResponseTree instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'description': instance.description,
      'status': instance.status,
      'function': instance.function,
    };

UserRoleAssignment _$UserRoleAssignmentFromJson(Map<String, dynamic> json) =>
    UserRoleAssignment(
      userId: json['userId'] as String,
      roleId: (json['roleId'] as num).toInt(),
    );

Map<String, dynamic> _$UserRoleAssignmentToJson(UserRoleAssignment instance) =>
    <String, dynamic>{'userId': instance.userId, 'roleId': instance.roleId};
