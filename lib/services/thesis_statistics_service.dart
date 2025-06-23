import 'package:thesis_manage_project/services/thesis_service.dart';

class ThesisStatisticsModel {
  final int totalTheses;
  final int openTheses;
  final int availableSlotTheses;

  ThesisStatisticsModel({
    required this.totalTheses,
    required this.openTheses,
    required this.availableSlotTheses,
  });
}

class ThesisStatisticsService {
  final ThesisService _thesisService;

  ThesisStatisticsService({ThesisService? thesisService})
      : _thesisService = thesisService ?? ThesisService();

  /// Tính toán thống kê từ danh sách đề tài
  Future<ThesisStatisticsModel> calculateStatistics() async {
    try {
      // Lấy danh sách đề tài theo chuyên ngành của sinh viên
      final theses = await _thesisService.getThesesByMyMajor();
      
      // Tổng số đề tài
      final totalTheses = theses.length;
      
      // Đề tài đang mở - sử dụng getter isActive từ model
      // Model có getter isActive kiểm tra status nếu chứa:
      // - "chưa được đăng ký"
      // - "active"
      // - "approved"
      final openTheses = theses.where((thesis) => thesis.isActive).length;
      
      // Đề tài còn slot - sử dụng getter isRegistrationOpen từ model
      // Model có getter isRegistrationOpen (trỏ tới isActive) để xác định đề tài có đang mở đăng ký không
      final availableSlotTheses = theses.where((thesis) => thesis.isRegistrationOpen).length;
      
      return ThesisStatisticsModel(
        totalTheses: totalTheses,
        openTheses: openTheses,
        availableSlotTheses: availableSlotTheses,
      );
    } catch (e) {
      // Nếu có lỗi, trả về giá trị mặc định và ghi log lỗi
      print('Error calculating thesis statistics: $e');
      return ThesisStatisticsModel(
        totalTheses: 0,
        openTheses: 0,
        availableSlotTheses: 0,
      );
    }
  }
}
