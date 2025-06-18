// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  studentCode: json['studentCode'] as String,
  major: json['major'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'studentCode': instance.studentCode,
      'major': instance.major,
      'email': instance.email,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
    };
