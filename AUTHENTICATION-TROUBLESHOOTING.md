# Hướng dẫn xử lý lỗi xác thực (Authentication)

## Lỗi thường gặp và cách khắc phục

### 1. Lỗi "type 'Null' is not a subtype of type 'Map<String, dynamic>'"

**Nguyên nhân:**

- API trả về null hoặc lỗi định dạng JSON không hợp lệ
- Kết nối mạng bị gián đoạn
- URL API không đúng

**Cách khắc phục:**

- Kiểm tra lại URL API trong `lib/config/api_config.dart`
- Đảm bảo backend đang chạy và có thể truy cập
- Nếu đang test trên Android Emulator, hãy kiểm tra lại baseUrl sử dụng `10.0.2.2` thay vì `localhost`
- Xem thông tin lỗi chi tiết trong console log để định vị chính xác vấn đề

### 2. Không thể đăng nhập

**Nguyên nhân:**

- Sai thông tin đăng nhập
- API endpoint không đúng
- Server đang offline
- Định dạng request không đúng với API

**Cách khắc phục:**

- Kiểm tra log trong terminal để xem chi tiết lỗi
- Kiểm tra định dạng request trong `auth_repository.dart`
- Sử dụng màn hình test API (`lib/screens/debug/api_test_screen.dart`) để kiểm tra trực tiếp API

### 3. Token không được lưu đúng cách

**Nguyên nhân:**

- Định dạng response API không khớp với code xử lý
- SharedPreferences gặp lỗi khi lưu dữ liệu

**Cách khắc phục:**

- Xem log để kiểm tra response API thực tế
- Kiểm tra cấu trúc lưu token trong `auth_repository.dart`

## Log chi tiết đăng nhập

Ứng dụng đã được cập nhật để hiển thị log chi tiết từ API. Khi gặp lỗi đăng nhập, hãy kiểm tra log console để xem thông tin chi tiết:

```console
API request to: http://10.0.2.2:8000/auth/login
Request body: {"user_name":"username","password":"password"}
API response status: 400
API response body: {"detail":"Invalid credentials"}
```

## Kiểm tra nhanh API

Sử dụng màn hình **API Test** đã được tạo để kiểm tra API trực tiếp:

1. Truy cập màn hình API Test (từ màn hình login hoặc màn hình chính)
2. Chọn endpoint API cần test (như `/auth/login`)
3. Nhập body request JSON nếu cần
4. Ấn nút "Test API" và xem kết quả

## Bước debug lỗi đăng nhập

1. **Xem log chi tiết**:
   - Chạy ứng dụng trong chế độ debug
   - Quan sát log khi thực hiện đăng nhập

2. **Kiểm tra kết nối API**:
   - Mở màn hình API Test
   - Thử test API login trực tiếp

3. **Kiểm tra URL API**:
   - Xác nhận file `api_config.dart` có URL đúng
   - Nếu chạy trên emulator Android, phải dùng `10.0.2.2` thay cho `localhost`
   - Nếu chạy trên thiết bị thật, phải dùng IP LAN của máy chủ API

4. **Kiểm tra định dạng request/response**:
   - So sánh định dạng request trong code với yêu cầu API
   - So sánh cấu trúc response thực tế với code xử lý

## Nếu vẫn gặp lỗi

- Xem lại file `TROUBLESHOOTING.md` để xử lý các vấn đề về kết nối API
- Kiểm tra thông tin log trong Debug Console
- Thử đặt breakpoint tại các hàm xử lý đăng nhập trong `auth_repository.dart` và `auth_bloc.dart` để theo dõi luồng thực thi
