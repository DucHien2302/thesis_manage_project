// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thesis_approval_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThesisBatchUpdateRequest _$ThesisBatchUpdateRequestFromJson(
  Map<String, dynamic> json,
) => ThesisBatchUpdateRequest(
  theses:
      (json['theses'] as List<dynamic>)
          .map((e) => ThesisBatchUpdateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ThesisBatchUpdateRequestToJson(
  ThesisBatchUpdateRequest instance,
) => <String, dynamic>{'theses': instance.theses};

ThesisBatchUpdateItem _$ThesisBatchUpdateItemFromJson(
  Map<String, dynamic> json,
) => ThesisBatchUpdateItem(
  id: json['id'] as String,
  updateData: ThesisUpdateData.fromJson(
    json['update_data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ThesisBatchUpdateItemToJson(
  ThesisBatchUpdateItem instance,
) => <String, dynamic>{'id': instance.id, 'update_data': instance.updateData};

ThesisUpdateData _$ThesisUpdateDataFromJson(Map<String, dynamic> json) =>
    ThesisUpdateData(
      title: json['title'] as String?,
      description: json['description'] as String?,
      thesisType: (json['thesis_type'] as num?)?.toInt(),
      startDate:
          json['start_date'] == null
              ? null
              : DateTime.parse(json['start_date'] as String),
      endDate:
          json['end_date'] == null
              ? null
              : DateTime.parse(json['end_date'] as String),
      status: (json['status'] as num?)?.toInt(),
      batchId: json['batch_id'] as String?,
      majorId: json['major_id'] as String?,
      lecturerIds:
          (json['lecturer_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      reviewerIds:
          (json['reviewer_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      reason: json['reason'] as String?,
      departmentId: (json['department_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ThesisUpdateDataToJson(
  ThesisUpdateData instance,
) => <String, dynamic>{
  if (instance.title case final value?) 'title': value,
  if (instance.description case final value?) 'description': value,
  if (instance.thesisType case final value?) 'thesis_type': value,
  if (instance.startDate?.toIso8601String() case final value?)
    'start_date': value,
  if (instance.endDate?.toIso8601String() case final value?) 'end_date': value,
  if (instance.status case final value?) 'status': value,
  if (instance.batchId case final value?) 'batch_id': value,
  if (instance.majorId case final value?) 'major_id': value,
  if (instance.lecturerIds case final value?) 'lecturer_ids': value,
  if (instance.reviewerIds case final value?) 'reviewer_ids': value,
  if (instance.reason case final value?) 'reason': value,
  if (instance.departmentId case final value?) 'department_id': value,
};

ThesisBatchUpdateResponse _$ThesisBatchUpdateResponseFromJson(
  Map<String, dynamic> json,
) => ThesisBatchUpdateResponse(
  successCount: (json['success_count'] as num).toInt(),
  errors:
      (json['errors'] as List<dynamic>)
          .map((e) => BatchUpdateError.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ThesisBatchUpdateResponseToJson(
  ThesisBatchUpdateResponse instance,
) => <String, dynamic>{
  'success_count': instance.successCount,
  'errors': instance.errors,
};

BatchUpdateError _$BatchUpdateErrorFromJson(Map<String, dynamic> json) =>
    BatchUpdateError(id: json['id'] as String, error: json['error'] as String);

Map<String, dynamic> _$BatchUpdateErrorToJson(BatchUpdateError instance) =>
    <String, dynamic>{'id': instance.id, 'error': instance.error};
