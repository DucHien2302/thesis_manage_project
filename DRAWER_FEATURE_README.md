# Tính năng Menu Drawer với API Student Profile

## Mô tả
Đã xây dựng thành công tính năng khi nhấn vào icon menu drawer sẽ tự động gọi API để lấy và hiển thị thông tin sinh viên trong header của drawer.

## Các tính năng đã triển khai

### 1. Tự động gọi API khi mở drawer
- Khi người dùng nhấn vào icon hamburger menu (☰), hệ thống sẽ tự động gọi API `LoadProfile` để refresh thông tin sinh viên
- Sử dụng ProfileBloc để quản lý state và call API

### 2. Hiển thị thông tin sinh viên trong drawer header
- **Tên sinh viên**: Hiển thị họ và tên đầy đủ
- **MSSV**: Mã số sinh viên trong container với background đặc biệt
- **Ngành học**: Tên ngành đào tạo
- **Avatar**: Icon school với animation loading khi đang tải

### 3. Xử lý các trạng thái
- **Loading**: Hiển thị CircularProgressIndicator và text "Đang tải thông tin..."
- **Success**: Hiển thị đầy đủ thông tin sinh viên + thông báo SnackBar thành công
- **Error**: Hiển thị thông báo lỗi + button "Tải lại thông tin" để retry

### 4. Tính năng Long Press để xem chi tiết
- Nhấn giữ vào drawer header để mở dialog hiển thị thông tin chi tiết sinh viên
- Bao gồm: Họ tên, MSSV, Lớp, Ngành, Điện thoại, Địa chỉ
- Có button "Xem chi tiết" để navigate tới trang Profile

### 5. UX/UI Improvements
- Gradient background cho drawer header
- Animation cho CircularProgressIndicator
- SnackBar notifications với icon và styling đẹp
- Hint text "Nhấn giữ để xem thông tin chi tiết"
- Responsive design với text overflow handling

## Log từ ProfileBloc
Dựa trên log đã cung cấp:
```
[log] onTransition: ProfileBloc, Transition { 
  currentState: ProfileLoading(), 
  event: LoadProfile(2, e8478421-d6ae-41d0-b1a0-53638a8fef9f), 
  nextState: ProfileLoaded(StudentFullProfileModel(...))
}
```

Tính năng này đã được tích hợp để xử lý chính xác transition này và hiển thị thông tin đúng cách.

## Technical Implementation

### Files Modified:
1. `lib/screens/student/student_dashboard.dart` - Main implementation
2. `test/student_dashboard_test.dart` - Widget tests

### Key Components:
- `_loadProfileData()` - Method gọi API ProfileBloc
- `_buildDrawer()` - Render drawer với thông tin sinh viên
- `_showStudentQuickInfo()` - Dialog hiển thị thông tin chi tiết
- BlocListener để handle state changes và show notifications

### State Management:
- Sử dụng ProfileBloc với LoadProfile event
- Track first load để không show notification khi app khởi động
- Handle error states với retry functionality

## Demo Flow:
1. User nhấn hamburger menu (☰)
2. App gọi `_loadProfileData()` 
3. ProfileBloc emit LoadProfile event với userType=2 và userId
4. API được call và trả về StudentFullProfileModel
5. Drawer header được update với thông tin sinh viên
6. SnackBar thông báo thành công hiển thị
7. User có thể long press để xem chi tiết hoặc click menu items

## Testing
Đã tạo widget tests trong `test/student_dashboard_test.dart` để verify:
- Drawer mở và hiển thị loading state
- API được gọi khi mở drawer
- Thông tin sinh viên được hiển thị đúng
- Functionality refresh hoạt động

Tính năng này đã hoàn thành và sẵn sàng sử dụng!
