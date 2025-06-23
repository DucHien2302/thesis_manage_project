// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchModel _$BatchModelFromJson(Map<String, dynamic> json) => BatchModel(
  id: json['id'] as String,
  name: json['name'] as String,
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String,
);

Map<String, dynamic> _$BatchModelToJson(BatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
    };

MajorModel _$MajorModelFromJson(Map<String, dynamic> json) =>
    MajorModel(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$MajorModelToJson(MajorModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    DepartmentModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

LecturerModel _$LecturerModelFromJson(Map<String, dynamic> json) =>
    LecturerModel(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      department: (json['department'] as num).toInt(),
      title: json['title'] as String,
      isActive: json['is_active'] as bool,
      departmentName: json['department_name'] as String?,
    );

Map<String, dynamic> _$LecturerModelToJson(LecturerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'department': instance.department,
      'title': instance.title,
      'is_active': instance.isActive,
      'department_name': instance.departmentName,
    };
