// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thesis_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorResponse _$InstructorResponseFromJson(Map<String, dynamic> json) =>
    InstructorResponse(
      name: json['name'] as String,
      email: json['email'] as String,
      lecturerCode: json['lecturer_code'] as String,
      department: (json['department'] as num).toInt(),
      departmentName: json['department_name'] as String?,
    );

Map<String, dynamic> _$InstructorResponseToJson(InstructorResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'lecturer_code': instance.lecturerCode,
      'department': instance.department,
      'department_name': instance.departmentName,
    };

BatchResponse _$BatchResponseFromJson(Map<String, dynamic> json) =>
    BatchResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      semester: SemesterResponse.fromJson(
        json['semester'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BatchResponseToJson(BatchResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'semester': instance.semester,
    };

AcademyYearResponse _$AcademyYearResponseFromJson(Map<String, dynamic> json) =>
    AcademyYearResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
    );

Map<String, dynamic> _$AcademyYearResponseToJson(
  AcademyYearResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
};

SemesterResponse _$SemesterResponseFromJson(Map<String, dynamic> json) =>
    SemesterResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      academyYear:
          json['academy_year'] == null
              ? null
              : AcademyYearResponse.fromJson(
                json['academy_year'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$SemesterResponseToJson(SemesterResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'academy_year': instance.academyYear,
    };

DepartmentResponse _$DepartmentResponseFromJson(Map<String, dynamic> json) =>
    DepartmentResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$DepartmentResponseToJson(DepartmentResponse instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ThesisModel _$ThesisModelFromJson(Map<String, dynamic> json) => ThesisModel(
  id: json['id'] as String,
  thesisType: (json['thesis_type'] as num).toInt(),
  status: json['status'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  instructors:
      (json['instructors'] as List<dynamic>)
          .map((e) => InstructorResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
  reviewers:
      (json['reviewers'] as List<dynamic>)
          .map((e) => InstructorResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
  batch: BatchResponse.fromJson(json['batch'] as Map<String, dynamic>),
  major: json['major'] as String,
  department:
      json['department'] == null
          ? null
          : DepartmentResponse.fromJson(
            json['department'] as Map<String, dynamic>,
          ),
  reason: json['reason'] as String?,
  nameThesisType: json['name_thesis_type'] as String,
  notes: json['notes'] as String?,
  committeeId: json['committee_id'] as String?,
);

Map<String, dynamic> _$ThesisModelToJson(ThesisModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'thesis_type': instance.thesisType,
      'status': instance.status,
      'name': instance.name,
      'description': instance.description,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'instructors': instance.instructors,
      'reviewers': instance.reviewers,
      'batch': instance.batch,
      'major': instance.major,
      'department': instance.department,
      'reason': instance.reason,
      'name_thesis_type': instance.nameThesisType,
      'notes': instance.notes,
      'committee_id': instance.committeeId,
    };

StudentThesisRegistrationRequest _$StudentThesisRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => StudentThesisRegistrationRequest(
  studentId: json['student_id'] as String,
  thesisId: json['thesis_id'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$StudentThesisRegistrationRequestToJson(
  StudentThesisRegistrationRequest instance,
) => <String, dynamic>{
  'student_id': instance.studentId,
  'thesis_id': instance.thesisId,
  'notes': instance.notes,
};

StudentThesisRegistrationModel _$StudentThesisRegistrationModelFromJson(
  Map<String, dynamic> json,
) => StudentThesisRegistrationModel(
  id: json['id'] as String,
  studentId: json['student_id'] as String,
  thesisId: json['thesis_id'] as String,
  status: json['status'] as String,
  notes: json['notes'] as String?,
  registrationDate: json['registration_date'] as String,
  approvalDate: json['approval_date'] as String?,
  createDatetime: json['create_datetime'] as String,
  updateDatetime: json['update_datetime'] as String,
);

Map<String, dynamic> _$StudentThesisRegistrationModelToJson(
  StudentThesisRegistrationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'student_id': instance.studentId,
  'thesis_id': instance.thesisId,
  'status': instance.status,
  'notes': instance.notes,
  'registration_date': instance.registrationDate,
  'approval_date': instance.approvalDate,
  'create_datetime': instance.createDatetime,
  'update_datetime': instance.updateDatetime,
};

ThesisListResponse _$ThesisListResponseFromJson(Map<String, dynamic> json) =>
    ThesisListResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((e) => ThesisModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      total: (json['total'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
    );

Map<String, dynamic> _$ThesisListResponseToJson(ThesisListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'current_page': instance.currentPage,
      'per_page': instance.perPage,
      'last_page': instance.lastPage,
    };

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    GroupMemberModel(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      studentCode: json['student_code'] as String,
      isLeader: json['is_leader'] as bool,
    );

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'student_code': instance.studentCode,
      'is_leader': instance.isLeader,
    };

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
  id: json['id'] as String,
  name: json['name'] as String?,
  leaderId: json['leader_id'] as String,
  thesisId: json['thesis_id'] as String?,
  members:
      (json['members'] as List<dynamic>)
          .map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'leader_id': instance.leaderId,
      'thesis_id': instance.thesisId,
      'members': instance.members,
    };

ThesisCreateRequest _$ThesisCreateRequestFromJson(Map<String, dynamic> json) =>
    ThesisCreateRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      thesisType: (json['thesis_type'] as num).toInt(),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      status: (json['status'] as num).toInt(),
      batchId: json['batch_id'] as String,
      majorId: json['major_id'] as String,
      departmentId: (json['department_id'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      instructorIds:
          (json['instructor_ids'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      reviewerIds:
          (json['reviewer_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ThesisCreateRequestToJson(
  ThesisCreateRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'thesis_type': instance.thesisType,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'status': instance.status,
  'batch_id': instance.batchId,
  'major_id': instance.majorId,
  'department_id': instance.departmentId,
  'notes': instance.notes,
  'instructor_ids': instance.instructorIds,
  'reviewer_ids': instance.reviewerIds,
};
