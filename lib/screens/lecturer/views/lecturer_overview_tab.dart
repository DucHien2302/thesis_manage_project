import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class LecturerOverviewTab extends StatefulWidget {
  const LecturerOverviewTab({super.key});

  @override
  State<LecturerOverviewTab> createState() => _LecturerOverviewTabState();
}

class _LecturerOverviewTabState extends State<LecturerOverviewTab> {
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(
      profileRepository: ProfileRepository(apiService: ApiService())
    );
    
    // Load profile data
    _loadProfile();
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final userId = authState.user['id']?.toString() ?? '';
      _profileBloc.add(LoadProfile(
        userType: AppConfig.userTypeLecturer,
        userId: userId,
      ));
    }
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: RefreshIndicator(
        onRefresh: () async {
          _loadProfile();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              GradientCard(
                gradientColors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary,
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Chào mừng Giảng viên!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quản lý đề tài và hướng dẫn sinh viên thực hiện khóa luận',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Thống kê nhanh
              const Text(
                'Thống kê tổng quan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  StatCard(
                    icon: Icons.assignment,
                    title: 'Đề tài',
                    value: '8',
                    subtitle: 'Đang hướng dẫn',
                    color: AppColors.primary,
                  ),
                  StatCard(
                    icon: Icons.people,
                    title: 'Sinh viên',
                    value: '24',
                    subtitle: 'Đang hướng dẫn',
                    color: AppColors.info,
                  ),
                  StatCard(
                    icon: Icons.check_circle,
                    title: 'Hoàn thành',
                    value: '15',
                    subtitle: 'Đề tài',
                    color: AppColors.success,
                  ),
                  StatCard(
                    icon: Icons.pending,
                    title: 'Chờ chấm',
                    value: '3',
                    subtitle: 'Báo cáo',
                    color: AppColors.warning,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Thông tin cá nhân
              const Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              // Hiển thị thông tin giảng viên từ ProfileBloc
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (state is ProfileError) {
                    return _buildEmptyProfileCards();
                  }
                  
                  if (state is ProfileLoaded && state.lecturerProfile != null) {
                    final profile = state.lecturerProfile!;
                    final information = profile.information;
                    final lecturerInfo = profile.lecturerInfo;
                    
                    return _buildProfileCards(information, lecturerInfo);
                  }
                  
                  // Trường hợp mặc định - chưa có dữ liệu
                  return _buildEmptyProfileCards();
                },
              ),
              
              const SizedBox(height: 20),
              
              // Hành động nhanh
              const Text(
                'Hành động nhanh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.add_circle,
                      label: 'Tạo đề tài',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng đang phát triển')),
                        );
                      },
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.rate_review,
                      label: 'Chấm điểm',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng đang phát triển')),
                        );
                      },
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.schedule_send,
                      label: 'Lịch gặp',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng đang phát triển')),
                        );
                      },
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Đề tài gần đây
              const Text(
                'Đề tài gần đây',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              ModernCard(
                child: Column(
                  children: [
                    _buildThesisItem(
                      'Phát triển ứng dụng di động quản lý khóa luận',
                      'Nguyễn Văn A - Trần Thị B',
                      AppColors.primary,
                      'Đang thực hiện',
                    ),
                    const Divider(),
                    _buildThesisItem(
                      'Hệ thống quản lý thư viện thông minh',
                      'Lê Văn C',
                      AppColors.warning,
                      'Chờ bảo vệ',
                    ),
                    const Divider(),
                    _buildThesisItem(
                      'Ứng dụng AI trong giáo dục',
                      'Phạm Thị D - Hoàng Văn E',
                      AppColors.info,
                      'Đang nghiên cứu',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Thông báo và lịch trình
              const Text(
                'Lịch trình hôm nay',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              ModernCard(
                child: Column(
                  children: [
                    _buildScheduleItem(
                      'Họp hội đồng đánh giá',
                      '09:00 - 11:00',
                      AppColors.primary,
                    ),
                    _buildScheduleItem(
                      'Gặp nhóm sinh viên - Đề tài AI',
                      '14:00 - 15:30',
                      AppColors.info,
                    ),
                    _buildScheduleItem(
                      'Chấm báo cáo tiến độ',
                      '16:00 - 17:00',
                      AppColors.warning,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThesisItem(String title, String students, Color color, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  students,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            text: status,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String title, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method để hiển thị profile cards với dữ liệu thực
  Widget _buildProfileCards(dynamic information, dynamic lecturerInfo) {
    // Helper function để format ngày sinh
    String formatBirthDate(DateTime? dateTime) {
      if (dateTime == null) return 'Đang cập nhật...';
      
      // Kiểm tra nếu là ngày mặc định (1970-01-01)
      if (dateTime.year == 1970 && dateTime.month == 1 && dateTime.day == 1) {
        return 'Đang cập nhật...';
      }
      
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }

    // Helper function để kiểm tra chuỗi rỗng hoặc null
    String getDisplayValue(String? value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return 'Đang cập nhật...';
      }
      return value;
    }

    // Helper function để format họ tên
    String formatFullName(String? firstName, String? lastName) {
      final first = firstName?.trim() ?? '';
      final last = lastName?.trim() ?? '';
      
      if (first.isEmpty && last.isEmpty) {
        return 'Đang cập nhật...';
      }
      
      return '$first $last'.trim();
    }

    return Column(
      children: [
        InfoCard(
          icon: Icons.badge,
          title: 'Mã GV',
          value: getDisplayValue(lecturerInfo.lecturerCode),
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.person_outline,
          title: 'Họ tên',
          value: formatFullName(information.firstName, information.lastName),
          iconColor: AppColors.primary,
        ),        InfoCard(
          icon: Icons.business,
          title: 'Khoa',
          value: getDisplayValue(lecturerInfo.departmentName),
          iconColor: AppColors.info,
        ),        InfoCard(
          icon: Icons.work,
          title: 'Chức vụ',
          value: getDisplayValue(lecturerInfo.title),
          iconColor: AppColors.warning,
        ),
        InfoCard(
          icon: Icons.cake,
          title: 'Ngày sinh',
          value: formatBirthDate(information.dateOfBirth),
          iconColor: AppColors.error,
        ),
        InfoCard(
          icon: Icons.location_on,
          title: 'Địa chỉ',
          value: getDisplayValue(information.address),
          iconColor: AppColors.accent,
        ),
        InfoCard(
          icon: Icons.phone,
          title: 'Điện thoại',
          value: getDisplayValue(information.telPhone),
          iconColor: AppColors.info,
        ),
      ],
    );
  }

  // Helper method để hiển thị profile cards rỗng
  Widget _buildEmptyProfileCards() {
    return Column(
      children: [
        InfoCard(
          icon: Icons.badge,
          title: 'Mã GV',
          value: 'Đang cập nhật...',
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.person_outline,
          title: 'Họ tên',
          value: 'Đang cập nhật...',
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.business,
          title: 'Khoa',
          value: 'Đang cập nhật...',
          iconColor: AppColors.info,
        ),
        InfoCard(
          icon: Icons.work,
          title: 'Chức vụ',
          value: 'Đang cập nhật...',
          iconColor: AppColors.warning,
        ),
        InfoCard(
          icon: Icons.cake,
          title: 'Ngày sinh',
          value: 'Đang cập nhật...',
          iconColor: AppColors.error,
        ),
        InfoCard(
          icon: Icons.location_on,
          title: 'Địa chỉ',
          value: 'Đang cập nhật...',
          iconColor: AppColors.accent,
        ),
        InfoCard(
          icon: Icons.phone,
          title: 'Điện thoại',
          value: 'Đang cập nhật...',
          iconColor: AppColors.info,
        ),
      ],
    );
  }
}
