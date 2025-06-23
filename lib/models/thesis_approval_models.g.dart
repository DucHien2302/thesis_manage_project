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

Map<String, dynamic> _$ThesisUpdateDataToJson(ThesisUpdateData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'thesis_type': instance.thesisType,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'status': instance.status,
      'batch_id': instance.batchId,
      'major_id': instance.majorId,
      'lecturer_ids': instance.lecturerIds,
      'reviewer_ids': instance.reviewerIds,
      'reason': instance.reason,
      'department_id': instance.departmentId,
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
