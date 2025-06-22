import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/group_models.dart' as group_models;
import 'package:thesis_manage_project/screens/thesis/bloc/thesis_bloc.dart';
import 'package:thesis_manage_project/screens/thesis/thesis_registration_screen.dart';
import 'package:thesis_manage_project/repositories/thesis_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

/// Màn hình demo để test chức năng đăng ký đề tài
/// Sử dụng để test khi chưa có group thật
class ThesisRegistrationDemo extends StatelessWidget {
  const ThesisRegistrationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo một group demo để test
    final demoGroup = group_models.GroupModel(
      id: 'demo-group-id',
      name: 'Nhóm Demo',
      leaderId: 'demo-leader-id',
      members: [
        group_models.MemberDetailModel(
          userId: 'demo-leader-id',
          fullName: 'Trưởng nhóm Demo',
          studentCode: 'ST001',
          isLeader: true,
        ),
        group_models.MemberDetailModel(
          userId: 'demo-member-id',
          fullName: 'Thành viên Demo',
          studentCode: 'ST002',
          isLeader: false,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Đăng ký Đề tài'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.assignment,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Demo Chức năng Đăng ký Đề tài',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Nhấn nút bên dưới để mở màn hình đăng ký đề tài với nhóm demo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ThesisBloc(
                          thesisRepository: ThesisRepository(
                            apiService: context.read<ApiService>(),
                          ),
                        ),
                        child: ThesisRegistrationScreen(group: demoGroup),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.launch),
                label: const Text('Mở Đăng ký Đề tài'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Chức năng bao gồm:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✓ Xem danh sách đề tài có sẵn'),
                  Text('✓ Tìm kiếm đề tài theo tên'),
                  Text('✓ Xem chi tiết đề tài'),
                  Text('✓ Đăng ký đề tài cho nhóm'),
                  Text('✓ Xác nhận đăng ký'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget để hiển thị thông tin API được sử dụng
class ApiInfoWidget extends StatelessWidget {
  const ApiInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API sử dụng:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('POST /group/{group_id}/register-thesis/{thesis_id}'),
            const SizedBox(height: 8),
            const Text(
              'Mô tả: API để nhóm trưởng đăng ký một đề tài cho nhóm của mình.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Các API hỗ trợ khác:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• GET /thesis - Lấy danh sách tất cả đề tài'),
                Text('• GET /thesis/available - Lấy đề tài có sẵn'),
                Text('• GET /thesis/{id} - Lấy chi tiết đề tài'),
                Text('• GET /thesis/search?q={query} - Tìm kiếm đề tài'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
