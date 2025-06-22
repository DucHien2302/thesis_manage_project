// Export các component chính cho chức năng đăng ký đề tài

// Repositories
export 'package:thesis_manage_project/repositories/thesis_repository.dart';

// Models (từ thesis_models.dart)
export 'package:thesis_manage_project/models/thesis_models.dart';

// Bloc
export 'package:thesis_manage_project/screens/thesis/bloc/thesis_bloc.dart';

// Screens
export 'package:thesis_manage_project/screens/thesis/thesis_registration_screen.dart';
export 'package:thesis_manage_project/screens/thesis/thesis_registration_demo.dart';

/*
HƯỚNG DẪN SỬ DỤNG CHỨC NĂNG ĐĂNG KÝ ĐỀ TÀI:

1. API được sử dụng:
   - POST /group/{group_id}/register-thesis/{thesis_id}
   - Mô tả: API để nhóm trưởng đăng ký một đề tài cho nhóm của mình

2. Các component chính:
   - ThesisRepository: Quản lý các API call liên quan đến đề tài
   - ThesisBloc: Quản lý state cho việc load và search đề tài
   - GroupBloc: Đã được mở rộng với RegisterThesisEvent để đăng ký đề tài
   - ThesisRegistrationScreen: Màn hình chính để đăng ký đề tài

3. Quy trình sử dụng:
   a. Từ màn hình chi tiết nhóm, leader có thể nhấn nút "Đăng ký đề tài"
   b. Màn hình ThesisRegistrationScreen sẽ mở ra với danh sách đề tài có sẵn
   c. User có thể tìm kiếm đề tài theo tên
   d. User có thể xem chi tiết đề tài bằng cách nhấn vào card
   e. User nhấn nút "Đăng ký đề tài" để đăng ký
   f. Hệ thống hiển thị dialog xác nhận
   g. Sau khi xác nhận, gọi API để đăng ký đề tài
   h. Thông báo kết quả và quay về màn hình trước

4. Tích hợp vào ứng dụng:
   - ThesisRepository đã được thêm vào app.dart
   - Nút "Đăng ký đề tài" đã được thêm vào GroupDetailView
   - RegisterThesisEvent đã được thêm vào GroupBloc

5. Test:
   - Có thể sử dụng ThesisRegistrationDemo để test độc lập
   - Hoặc test qua flow thực tế từ màn hình nhóm

6. Models sử dụng:
   - ThesisModel: Model chính cho đề tài
   - GroupModel: Model nhóm (để truyền thông tin nhóm)
   - RegisterThesisEvent: Event để đăng ký đề tài
   - ThesisRegisteredState: State khi đăng ký thành công

7. Xử lý lỗi:
   - Có catch và handle exception từ API
   - Hiển thị thông báo lỗi cho user
   - Có retry mechanism với nút refresh

8. UI/UX:
   - Responsive design với card layout
   - Loading states với AnimatedLoadingIndicator  
   - Search functionality với debounce
   - Pull-to-refresh support
   - Detail view với bottom sheet
   - Confirmation dialogs
*/
