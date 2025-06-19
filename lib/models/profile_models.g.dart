// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InformationModel _$InformationModelFromJson(Map<String, dynamic> json) =>
    InformationModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: (json['gender'] as num).toInt(),
      address: json['address'] as String,
      telPhone: json['telPhone'] as String,
    );

Map<String, dynamic> _$InformationModelToJson(InformationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'telPhone': instance.telPhone,
    };

StudentInfoModel _$StudentInfoModelFromJson(Map<String, dynamic> json) =>
    StudentInfoModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      studentCode: json['studentCode'] as String,
      className: json['className'] as String?,
      majorId: json['majorId'] as String,
      majorName: json['majorName'] as String?,
      createDatetime:
          json['createDatetime'] == null
              ? null
              : DateTime.parse(json['createDatetime'] as String),
      updateDatetime:
          json['updateDatetime'] == null
              ? null
              : DateTime.parse(json['updateDatetime'] as String),
    );

Map<String, dynamic> _$StudentInfoModelToJson(StudentInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'studentCode': instance.studentCode,
      'className': instance.className,
      'majorId': instance.majorId,
      'majorName': instance.majorName,
      'createDatetime': instance.createDatetime?.toIso8601String(),
      'updateDatetime': instance.updateDatetime?.toIso8601String(),
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
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  information: InformationModel.fromJson(
    json['information'] as Map<String, dynamic>,
  ),
  studentInfo: StudentInfoModel.fromJson(
    json['studentInfo'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$StudentFullProfileModelToJson(
  StudentFullProfileModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'information': instance.information,
  'studentInfo': instance.studentInfo,
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
