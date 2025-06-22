import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/thesis_registration/blocs/thesis_registration_bloc.dart';
import 'package:thesis_manage_project/screens/thesis_registration/views/thesis_detail_view.dart';

class ThesisListView extends StatefulWidget {
  final String studentId;

  const ThesisListView({
    super.key,
    required this.studentId,
  });

  @override
  State<ThesisListView> createState() => _ThesisListViewState();
}

class _ThesisListViewState extends State<ThesisListView> {  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    context.read<ThesisRegistrationBloc>().add(
      const LoadThesesByMyMajor(),
    );
  }

  void _onRefresh() {
    context.read<ThesisRegistrationBloc>().add(
      const RefreshTheses(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đề tài'),        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: BlocConsumer<ThesisRegistrationBloc, ThesisRegistrationState>(        listener: (context, state) {
          if (state is ThesisRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _onRefresh(); // Refresh danh sách sau khi đăng ký thành công
            
            // Trả về signal để parent widget biết có thay đổi
            Navigator.pop(context, true);
          } else if (state is ThesisRegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ThesesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ThesesLoaded) {
            return _buildThesesList(context, state.theses);
          } else if (state is ThesesError) {
            return _buildErrorWidget(state.message);
          }
          
          return const Center(
            child: Text('Chưa có dữ liệu'),
          );
        },
      ),
    );
  }

  Widget _buildThesesList(BuildContext context, List<ThesisModel> theses) {
    if (theses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có đề tài nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _onRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: theses.length,
        itemBuilder: (context, index) {
          return _buildThesisCard(context, theses[index]);
        },
      ),
    );
  }

  Widget _buildThesisCard(BuildContext context, ThesisModel thesis) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),      child: InkWell(
        borderRadius: BorderRadius.circular(12),        onTap: () async {
          final bloc = context.read<ThesisRegistrationBloc>();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: bloc,
                child: ThesisDetailView(
                  thesis: thesis,
                  studentId: widget.studentId,
                ),
              ),
            ),
          );
          
          // Reload theses when returning from detail view
          _onRefresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                thesis.title,                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Mô tả
              if (thesis.description.isNotEmpty)
                Text(
                  thesis.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
                // Thông tin loại đề tài và trạng thái
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.category,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              thesis.thesisTypeName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                thesis.lecturerName ?? 'Chưa có giảng viên',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.school,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                thesis.major,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.info,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              thesis.status,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),                  // Trạng thái đề tài
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(thesis).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(thesis),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(thesis),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Đã xảy ra lỗi',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _onRefresh,            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
  // Helper methods để xác định trạng thái đề tài
  String _getStatusText(ThesisModel thesis) {
    // Kiểm tra theo thứ tự ưu tiên
    if (thesis.status == 'Đã được đăng ký') {
      return 'Đã có nhóm đăng ký';
    } else if (thesis.status == 'Chờ duyệt') {
      return 'Chờ duyệt';
    } else if (thesis.status == 'Chưa được đăng ký' && thesis.isRegistrationOpen) {
      return 'Đang mở đăng ký';
    } else {
      return 'Đã đóng đăng ký';
    }
  }
  
  Color _getStatusColor(ThesisModel thesis) {
    // Kiểm tra theo thứ tự ưu tiên
    if (thesis.status == 'Đã được đăng ký') {
      return Colors.red; // Đã được đăng ký
    } else if (thesis.status == 'Chờ duyệt') {
      return Colors.blue; // Chờ duyệt
    } else if (thesis.status == 'Chưa được đăng ký' && thesis.isRegistrationOpen) {
      return Colors.green; // Đang mở đăng ký
    } else {
      return Colors.orange; // Đã đóng đăng ký hoặc trạng thái khác
    }
  }
}
