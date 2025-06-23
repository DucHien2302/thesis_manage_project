import 'dart:convert';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/models/thesis_approval_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class ThesisApprovalRepository {
  final ApiService _apiService;

  ThesisApprovalRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get thesis list based on approval type and status filters
  Future<List<ThesisModel>> getThesesForApproval(ApprovalType approvalType) async {
    try {
      // Get all theses from the API
      final response = await _apiService.get('/theses/');
      final List<dynamic> data = response;
      final allTheses = data.map((thesis) => ThesisModel.fromJson(thesis)).toList();

      // Filter based on approval type and allowed statuses
      final allowedStatuses = approvalType.allowedStatuses;
      
      final filteredTheses = allTheses.where((thesis) {
        final statusCode = ThesisStatus.getStatusFromString(thesis.status);
        return allowedStatuses.contains(statusCode);
      }).toList();

      return filteredTheses;
    } catch (e) {
      throw Exception('Không thể lấy danh sách đề tài để duyệt: $e');
    }
  }
  /// Batch update theses status
  Future<ThesisBatchUpdateResponse> batchUpdateTheses(
    List<ThesisBatchUpdateItem> updateItems,
  ) async {
    try {
      final request = ThesisBatchUpdateRequest(theses: updateItems);
      final requestJson = request.toJson();
      
      print('🔗 PUT /theses/batch-update');
      print('📋 Request payload: ${jsonEncode(requestJson)}');
      print('📊 Update items count: ${updateItems.length}');
      
      // Log each update item for debugging
      for (int i = 0; i < updateItems.length; i++) {
        final item = updateItems[i];
        print('📝 Item $i: id=${item.id}, status=${item.updateData.status}, reason=${item.updateData.reason}');
      }
      
      final response = await _apiService.put(
        '/theses/batch-update', 
        body: requestJson,
      );
      
      print('✅ Batch update response: $response');
      
      final batchResponse = ThesisBatchUpdateResponse.fromJson(response);
      print('📈 Success count: ${batchResponse.successCount}');
      print('⚠️ Errors count: ${batchResponse.errors.length}');
      
      if (batchResponse.errors.isNotEmpty) {
        for (final error in batchResponse.errors) {
          print('❌ Error for ${error.id}: ${error.error}');
        }
      }
      
      return batchResponse;
    } catch (e) {
      print('❌ Batch update error: $e');
      throw Exception('Không thể cập nhật trạng thái đề tài: $e');
    }
  }
  /// Approve single thesis
  Future<void> approveThesis(String thesisId, int newStatus, {String? reason}) async {
    try {
      print('🎯 Approving single thesis $thesisId with status $newStatus');
      
      final updateItem = ThesisBatchUpdateItem(
        id: thesisId,
        updateData: ThesisUpdateData(
          status: newStatus,
          reason: reason ?? 'Individual approval',
          // Ensure we don't send null arrays that might cause backend issues
          lecturerIds: null,
          reviewerIds: null,
        ),
      );

      final response = await batchUpdateTheses([updateItem]);
      
      if (response.errors.isNotEmpty) {
        throw Exception('Backend error: ${response.errors.first.error}');
      }
      
      print('✅ Individual approval successful');
    } catch (e) {
      print('❌ Individual approve error: $e');
      throw Exception('Không thể duyệt đề tài: $e');
    }
  }
  /// Reject single thesis
  Future<void> rejectThesis(String thesisId, String reason) async {
    try {
      print('🎯 Rejecting single thesis $thesisId');
      
      final updateItem = ThesisBatchUpdateItem(
        id: thesisId,
        updateData: ThesisUpdateData(
          status: ThesisStatus.rejected,
          reason: reason,
          // Ensure we don't send null arrays that might cause backend issues
          lecturerIds: null,
          reviewerIds: null,
        ),
      );

      final response = await batchUpdateTheses([updateItem]);
      
      if (response.errors.isNotEmpty) {
        throw Exception('Backend error: ${response.errors.first.error}');
      }
      
      print('✅ Individual rejection successful');
    } catch (e) {
      print('❌ Individual reject error: $e');
      throw Exception('Không thể từ chối đề tài: $e');
    }
  }
  /// Batch approve multiple theses
  Future<ThesisBatchUpdateResponse> batchApproveTheses(
    List<String> thesisIds, 
    int newStatus,
    {String? reason}
  ) async {
    try {
      print('🚀 Starting batch approve for ${thesisIds.length} theses with status $newStatus');
      
      final updateItems = thesisIds.map((id) => ThesisBatchUpdateItem(
        id: id,
        updateData: ThesisUpdateData(
          status: newStatus,
          reason: reason ?? 'Batch approval',
          // Ensure we don't send null arrays that might cause backend issues
          lecturerIds: null, // Explicitly set to null rather than empty array
          reviewerIds: null, // Explicitly set to null rather than empty array
        ),
      )).toList();

      return await batchUpdateTheses(updateItems);
    } catch (e) {
      print('❌ Batch approve error: $e');
      throw Exception('Không thể duyệt hàng loạt đề tài: $e');
    }
  }
  /// Batch reject multiple theses
  Future<ThesisBatchUpdateResponse> batchRejectTheses(
    List<String> thesisIds, 
    String reason
  ) async {
    try {
      print('🚀 Starting batch reject for ${thesisIds.length} theses');
      
      final updateItems = thesisIds.map((id) => ThesisBatchUpdateItem(
        id: id,
        updateData: ThesisUpdateData(
          status: ThesisStatus.rejected,
          reason: reason,
          // Ensure we don't send null arrays that might cause backend issues
          lecturerIds: null, // Explicitly set to null rather than empty array
          reviewerIds: null, // Explicitly set to null rather than empty array
        ),
      )).toList();

      return await batchUpdateTheses(updateItems);
    } catch (e) {
      print('❌ Batch reject error: $e');
      throw Exception('Không thể từ chối hàng loạt đề tài: $e');
    }
  }
}
