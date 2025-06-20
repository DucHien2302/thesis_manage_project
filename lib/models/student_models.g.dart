// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
  id: json['user_id'] as String,
  userName: json['user_name'] as String,
  information: InformationModel.fromJson(
    json['information'] as Map<String, dynamic>,
  ),
  studentInfo: StudentInfoModel.fromJson(
    json['student_info'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'user_name': instance.userName,
      'information': instance.information,
      'student_info': instance.studentInfo,
    };

InformationModel _$InformationModelFromJson(Map<String, dynamic> json) =>
    InformationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      gender: (json['gender'] as num).toInt(),
      address: json['address'] as String,
      telPhone: json['tel_phone'] as String,
    );

Map<String, dynamic> _$InformationModelToJson(InformationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'date_of_birth': instance.dateOfBirth,
      'gender': instance.gender,
      'address': instance.address,
      'tel_phone': instance.telPhone,
    };

StudentInfoModel _$StudentInfoModelFromJson(Map<String, dynamic> json) =>
    StudentInfoModel(
      studentCode: json['student_code'] as String,
      className: json['class_name'] as String?,
      majorId: json['major_id'] as String,
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createDatetime: json['create_datetime'] as String,
      updateDatetime: json['update_datetime'] as String,
      majorName: json['major_name'] as String,
    );

Map<String, dynamic> _$StudentInfoModelToJson(StudentInfoModel instance) =>
    <String, dynamic>{
      'student_code': instance.studentCode,
      'class_name': instance.className,
      'major_id': instance.majorId,
      'id': instance.id,
      'user_id': instance.userId,
      'create_datetime': instance.createDatetime,
      'update_datetime': instance.updateDatetime,
      'major_name': instance.majorName,
    };
