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
      
      print('🔗 PUT /theses/batch-update with data: ${request.toJson()}');
      
      final response = await _apiService.put(
        '/theses/batch-update', 
        body: request.toJson(),
      );
      
      print('✅ Batch update response: $response');
      
      return ThesisBatchUpdateResponse.fromJson(response);
    } catch (e) {
      print('❌ Batch update error: $e');
      throw Exception('Không thể cập nhật trạng thái đề tài: $e');
    }
  }

  /// Approve single thesis
  Future<void> approveThesis(String thesisId, int newStatus, {String? reason}) async {
    try {
      final updateItem = ThesisBatchUpdateItem(
        id: thesisId,
        updateData: ThesisUpdateData(
          status: newStatus,
          reason: reason,
        ),
      );

      await batchUpdateTheses([updateItem]);
    } catch (e) {
      throw Exception('Không thể duyệt đề tài: $e');
    }
  }

  /// Reject single thesis
  Future<void> rejectThesis(String thesisId, String reason) async {
    try {
      final updateItem = ThesisBatchUpdateItem(
        id: thesisId,
        updateData: ThesisUpdateData(
          status: ThesisStatus.rejected,
          reason: reason,
        ),
      );

      await batchUpdateTheses([updateItem]);
    } catch (e) {
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
      final updateItems = thesisIds.map((id) => ThesisBatchUpdateItem(
        id: id,
        updateData: ThesisUpdateData(
          status: newStatus,
          reason: reason,
        ),
      )).toList();

      return await batchUpdateTheses(updateItems);
    } catch (e) {
      throw Exception('Không thể duyệt hàng loạt đề tài: $e');
    }
  }

  /// Batch reject multiple theses
  Future<ThesisBatchUpdateResponse> batchRejectTheses(
    List<String> thesisIds, 
    String reason
  ) async {
    try {
      final updateItems = thesisIds.map((id) => ThesisBatchUpdateItem(
        id: id,
        updateData: ThesisUpdateData(
          status: ThesisStatus.rejected,
          reason: reason,
        ),
      )).toList();

      return await batchUpdateTheses(updateItems);
    } catch (e) {
      throw Exception('Không thể từ chối hàng loạt đề tài: $e');
    }
  }
}
