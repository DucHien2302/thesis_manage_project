import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/models/group_models.dart' as group_models;
import 'package:thesis_manage_project/screens/thesis_registration/blocs/thesis_registration_bloc.dart';
import 'package:thesis_manage_project/services/group_state_manager.dart';

class StudentRegistrationsView extends StatefulWidget {
  final String studentId;

  const StudentRegistrationsView({
    super.key,
    required this.studentId,
  });

  @override
  State<StudentRegistrationsView> createState() => _StudentRegistrationsViewState();
}

class _StudentRegistrationsViewState extends State<StudentRegistrationsView> {
  final GroupStateManager _groupStateManager = GroupStateManager();
  bool _isLoadingGroup = true;
  String? _groupErrorMessage;
  group_models.GroupModel? _currentGroup;

  @override
  void initState() {
    super.initState();
    _fetchGroupAndLoadThesis();
  }
  Future<void> _fetchGroupAndLoadThesis() async {
    setState(() {
      _isLoadingGroup = true;
      _groupErrorMessage = null;
    });

    try {
      // Get the current user's group
      final group = await _groupStateManager.getCurrentUserGroup(forceRefresh: true);
      
      setState(() {
        _currentGroup = group;
      });

      if (group == null) {
        setState(() {
          _isLoadingGroup = false;
          _groupErrorMessage = 'Bạn chưa tham gia nhóm nào';
        });
        return;
      }

      if (group.thesisId == null) {
        setState(() {
          _isLoadingGroup = false;
          _groupErrorMessage = 'Nhóm của bạn chưa đăng ký đề tài';
        });
        return;
      }      // Set loading group to false since we found a valid group with thesis
      setState(() {
        _isLoadingGroup = false;
      });
      
      // Load thesis details using the thesis_id from the group
      context.read<ThesisRegistrationBloc>().add(
        LoadThesisDetail(group.thesisId!),
      );
    } catch (e) {
      setState(() {
        _isLoadingGroup = false;
        _groupErrorMessage = 'Lỗi khi tải thông tin nhóm: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      appBar: AppBar(
        title: const Text('Đăng ký của tôi'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchGroupAndLoadThesis,
          ),
        ],
      ),      body: BlocConsumer<ThesisRegistrationBloc, ThesisRegistrationState>(        listener: (context, state) {
          if (state is RegistrationCancelSuccess) {
            _showSuccessSnackBar(state.message);
            _fetchGroupAndLoadThesis(); // Reload after cancellation
          }
          
          if (state is RegistrationCancelError) {
            _showErrorSnackBar(state.message);
          }
        },builder: (context, state) {
          // Show group loading or error status
          if (_isLoadingGroup) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải thông tin nhóm...'),
                ],
              ),
            );
          }
          
          if (_groupErrorMessage != null) {
            return _buildErrorView(_groupErrorMessage!);
          }
          
          // If group is loaded but thesis is still loading or has errors
          if (state is StudentRegistrationsLoading || state is ThesisDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is StudentRegistrationsError) {
            return _buildErrorView(state.message);
          }
          
          if (state is ThesisDetailError) {
            return _buildErrorView(state.message);
          }
          
          if (state is ThesisDetailLoaded) {
            return _buildThesisDetail(state.thesis);
          }
          
          return const Center(
            child: Text('Chưa có dữ liệu'),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.marginLarge),
            ElevatedButton(              onPressed: _fetchGroupAndLoadThesis,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThesisDetail(ThesisModel thesis) {
    return RefreshIndicator(
      onRefresh: () async => _fetchGroupAndLoadThesis(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thesis.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.marginMedium),
                
                _buildSectionTitle('Mô tả'),
                Text(thesis.description),
                const SizedBox(height: AppDimens.marginMedium),
                
                _buildSectionTitle('Giảng viên hướng dẫn'),
                ...thesis.instructors.map((instructor) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person),
                  title: Text(instructor.name),
                  subtitle: Text(instructor.lecturerCode),
                )),
                const SizedBox(height: AppDimens.marginMedium),
                
                _buildSectionTitle('Thông tin khác'),
                _buildInfoRow('Loại đề tài', thesis.nameThesisType),
                _buildInfoRow('Trạng thái', thesis.status),
                if (thesis.startDate != null)
                  _buildInfoRow('Ngày bắt đầu', thesis.startDate!),
                if (thesis.endDate != null)
                  _buildInfoRow('Ngày kết thúc', thesis.endDate!),
                
                const SizedBox(height: AppDimens.marginLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _fetchGroupAndLoadThesis,
                    child: const Text('Làm mới'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.marginSmall),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.marginSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),    );
  }
}
