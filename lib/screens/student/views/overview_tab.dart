import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  late ProfileBloc _profileBloc;
  late GroupRepository _groupRepository;
  GroupModel? _currentGroup;
  bool _isLoadingGroup = false;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(
      profileRepository: ProfileRepository(apiService: ApiService())
    );
    _groupRepository = GroupRepository(apiService: ApiService());
    
    // Load profile data and group data
    _loadProfile();
    _loadGroupInfo();
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final userId = authState.user['id']?.toString() ?? '';
      _profileBloc.add(LoadProfile(
        userType: AppConfig.userTypeStudent,
        userId: userId,
      ));
    }
  }

  void _loadGroupInfo() async {
    setState(() {
      _isLoadingGroup = true;
    });
    
    try {
      final currentGroup = await _groupRepository.getCurrentUserGroup();
      if (mounted) {
        setState(() {
          _currentGroup = currentGroup;
          _isLoadingGroup = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentGroup = null;
          _isLoadingGroup = false;
        });
      }
    }
  }

  // Helper methods để hiển thị thông tin nhóm
  String _getGroupDisplayValue() {
    if (_isLoadingGroup) {
      return 'Đang tải...';
    }
    
    if (_currentGroup == null) {
      return 'Chưa có nhóm';
    }
    
    // Nếu nhóm có tên thì hiển thị tên, nếu không thì tạo tên mặc định
    if (_currentGroup!.name != null && _currentGroup!.name!.isNotEmpty) {
      return _currentGroup!.name!;
    } else {
      // Tạo tên nhóm mặc định dựa trên số thành viên và ID
      final memberCount = _currentGroup!.members.length;
      if (memberCount <= 1) {
        return 'Nhóm cá nhân';
      } else {
        // Tạo tên dựa trên ID nhóm (lấy 2 ký tự cuối)
        final shortId = _currentGroup!.id.length >= 2 
            ? _currentGroup!.id.substring(_currentGroup!.id.length - 2)
            : _currentGroup!.id;
        return 'Nhóm ${shortId.toUpperCase()}';
      }
    }
  }
  
  String _getGroupSubtitle() {
    if (_isLoadingGroup) {
      return 'Đang tải...';
    }
    
    if (_currentGroup == null) {
      return 'Tạo nhóm mới';
    }
    
    final memberCount = _currentGroup!.members.length;
    if (memberCount == 0) {
      return 'Chưa có thành viên';
    } else if (memberCount == 1) {
      return '1 thành viên';
    } else {
      return '$memberCount thành viên';
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
          _loadGroupInfo();
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
                          Icons.waving_hand,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Chào mừng Sinh viên!',
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
                      'Theo dõi tiến độ và quản lý khóa luận của bạn',
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
                'Thống kê nhanh',
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
                    title: 'Trạng thái đề tài',
                    value: 'Đang thực hiện',
                    color: AppColors.info,
                  ),
                  StatCard(
                    icon: Icons.trending_up,
                    title: 'Tiến độ',
                    value: '65%',
                    subtitle: 'Đang tốt',
                    color: AppColors.warning,
                  ),
                  StatCard(
                    icon: Icons.task_alt,
                    title: 'Nhiệm vụ',
                    value: '3',
                    subtitle: 'Còn lại',
                    color: AppColors.error,
                  ),
                  StatCard(
                    icon: Icons.group,
                    title: 'Nhóm',
                    value: _getGroupDisplayValue(),
                    subtitle: _getGroupSubtitle(),
                    color: AppColors.primary,
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
              // Hiển thị thông tin sinh viên từ ProfileBloc
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  print('DEBUG: ProfileBloc state: $state');
                  
                  if (state is ProfileLoading) {
                    print('DEBUG: ProfileLoading state');
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (state is ProfileError) {
                    print('DEBUG: ProfileError state: ${state.message}');
                    return _buildEmptyProfileCards();
                  }
                  
                  if (state is ProfileLoaded && state.studentProfile != null) {
                    print('DEBUG: ProfileLoaded state with data');
                    final profile = state.studentProfile!;
                    final information = profile.information;
                    final studentInfo = profile.studentInfo;
                    
                    print('DEBUG: Information - firstName: ${information.firstName}, lastName: ${information.lastName}');
                    print('DEBUG: StudentInfo - studentCode: ${studentInfo.studentCode}, className: ${studentInfo.className}');
                    
                    return _buildProfileCards(information, studentInfo);
                  }
                  
                  print('DEBUG: Default case - no data');
                  // Trường hợp mặc định - chưa có dữ liệu
                  return _buildEmptyProfileCards();
                },
              ),
              
              const SizedBox(height: 20),
              
              // Actions nhanh
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
                      icon: Icons.add_task,
                      label: 'Tạo nhiệm vụ',
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
                      icon: Icons.upload_file,
                      label: 'Nộp báo cáo',
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
                      icon: Icons.schedule,
                      label: 'Lịch hẹn',
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
              
              // Tiến độ dự án
              const Text(
                'Tiến độ dự án',
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
                    ProgressIndicatorWidget(
                      progress: 0.65,
                      label: 'Tổng tiến độ',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    ProgressIndicatorWidget(
                      progress: 0.8,
                      label: 'Nghiên cứu lý thuyết',
                      color: AppColors.info,
                    ),
                    const SizedBox(height: 16),
                    ProgressIndicatorWidget(
                      progress: 0.4,
                      label: 'Phát triển ứng dụng',
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: 16),
                    ProgressIndicatorWidget(
                      progress: 0.2,
                      label: 'Viết báo cáo',
                      color: AppColors.error,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Thông báo gần đây
              const Text(
                'Thông báo gần đây',
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
                    _buildNotificationItem(
                      'Có nhiệm vụ mới được giao',
                      '2 giờ trước',
                      AppColors.primary,
                    ),
                    _buildNotificationItem(
                      'Hạn nộp báo cáo tiến độ',
                      '1 ngày',
                      AppColors.warning,
                    ),
                    _buildNotificationItem(
                      'Cuộc họp nhóm lúc 14:00',
                      'Hôm nay',
                      AppColors.primary,
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

  Widget _buildNotificationItem(String title, String date, Color color) {
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
            date,
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
  Widget _buildProfileCards(dynamic information, dynamic studentInfo) {
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
          title: 'MSSV',
          value: getDisplayValue(studentInfo.studentCode),
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.person_outline,
          title: 'Họ tên',
          value: formatFullName(information.firstName, information.lastName),
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.school,
          title: 'Lớp',
          value: getDisplayValue(studentInfo.className),
          iconColor: AppColors.info,
        ),
        InfoCard(
          icon: Icons.business,
          title: 'Ngành',
          value: getDisplayValue(studentInfo.majorName),
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
          title: 'MSSV',
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
          icon: Icons.school,
          title: 'Lớp',
          value: 'Đang cập nhật...',
          iconColor: AppColors.info,
        ),
        InfoCard(
          icon: Icons.business,
          title: 'Ngành',
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
