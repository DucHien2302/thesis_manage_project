// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InformationModel _$InformationModelFromJson(Map<String, dynamic> json) =>
    InformationModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
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
      'date_of_birth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'tel_phone': instance.telPhone,
    };

StudentInfoModel _$StudentInfoModelFromJson(Map<String, dynamic> json) =>
    StudentInfoModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      studentCode: json['student_code'] as String,
      className: json['class_name'] as String?,
      majorId: json['major_id'] as String,
      majorName: json['major_name'] as String?,
      createDatetime:
          json['create_datetime'] == null
              ? null
              : DateTime.parse(json['create_datetime'] as String),
      updateDatetime:
          json['update_datetime'] == null
              ? null
              : DateTime.parse(json['update_datetime'] as String),
    );

Map<String, dynamic> _$StudentInfoModelToJson(StudentInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'student_code': instance.studentCode,
      'class_name': instance.className,
      'major_id': instance.majorId,
      'major_name': instance.majorName,
      'create_datetime': instance.createDatetime?.toIso8601String(),
      'update_datetime': instance.updateDatetime?.toIso8601String(),
    };

LecturerInfoModel _$LecturerInfoModelFromJson(Map<String, dynamic> json) =>
    LecturerInfoModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      lecturerCode: json['lecturerCode'] as String,
      department: (json['department'] as num).toInt(),
      title: json['title'] as String,
      email: json['email'] as String,
      departmentName: json['departmentName'] as String?,
      createDatetime:
          json['createDatetime'] == null
              ? null
              : DateTime.parse(json['createDatetime'] as String),
      updateDatetime:
          json['updateDatetime'] == null
              ? null
              : DateTime.parse(json['updateDatetime'] as String),
    );

Map<String, dynamic> _$LecturerInfoModelToJson(LecturerInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'lecturerCode': instance.lecturerCode,
      'department': instance.department,
      'title': instance.title,
      'email': instance.email,
      'departmentName': instance.departmentName,
      'createDatetime': instance.createDatetime?.toIso8601String(),
      'updateDatetime': instance.updateDatetime?.toIso8601String(),
    };

StudentFullProfileModel _$StudentFullProfileModelFromJson(
  Map<String, dynamic> json,
) => StudentFullProfileModel(
  userId: json['user_id'] as String,
  userName: json['user_name'] as String,
  information: InformationModel.fromJson(
    json['information'] as Map<String, dynamic>,
  ),
  studentInfo: StudentInfoModel.fromJson(
    json['student_info'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$StudentFullProfileModelToJson(
  StudentFullProfileModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'user_name': instance.userName,
  'information': instance.information,
  'student_info': instance.studentInfo,
};

LecturerFullProfileModel _$LecturerFullProfileModelFromJson(
  Map<String, dynamic> json,
) => LecturerFullProfileModel(
  userId: json['userId'] as String,
  information: InformationModel.fromJson(
    json['information'] as Map<String, dynamic>,
  ),
  lecturerInfo: LecturerInfoModel.fromJson(
    json['lecturerInfo'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$LecturerFullProfileModelToJson(
  LecturerFullProfileModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'information': instance.information,
  'lecturerInfo': instance.lecturerInfo,
};
