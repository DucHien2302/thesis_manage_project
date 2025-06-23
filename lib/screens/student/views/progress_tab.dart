import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:thesis_manage_project/screens/student/bloc/mission_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/mission_models.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/repositories/student_repository.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  String? _thesisId;
  bool _isLoadingThesisId = true;
  @override
  void initState() {
    super.initState();
    // Delay the call to avoid using context in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadThesisId();
    });
  }

  Future<void> _loadThesisId() async {
    try {
      final studentRepository = context.read<StudentRepository>();
      final thesisId = await studentRepository.getCurrentStudentThesisId();
      
      if (mounted) {
        setState(() {
          _thesisId = thesisId;
          _isLoadingThesisId = false;
        });
        
        if (thesisId != null) {
          // Load tasks for this thesis when we have the thesis ID
          context.read<MissionBloc>().add(LoadTasksForThesis(thesisId: thesisId));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingThesisId = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải thông tin đề tài: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Không xác định';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _onTaskCheckedChanged(String taskId, bool completed) {
    // Convert boolean to status code: 2 = completed, 1 = in progress
    final newStatus = completed ? 2 : 1;
    context.read<MissionBloc>().add(UpdateTaskStatus(
          taskId: taskId,
          newStatus: newStatus,
        ));
  }
  @override
  Widget build(BuildContext context) {
    // Show loading if we're still getting thesis ID
    if (_isLoadingThesisId) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải thông tin đề tài...'),
          ],
        ),
      );
    }

    // Show message if no thesis ID is found
    if (_thesisId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chưa đăng ký đề tài',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Vui lòng tham gia nhóm và đăng ký đề tài để xem tiến độ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<MissionBloc, MissionState>(
      builder: (context, state) {
        if (state is MissionInitial) {
          return const Center(child: Text('Đang tải nhiệm vụ...'));
        }

        if (state is MissionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MissionError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lỗi: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_thesisId != null) {
                      context.read<MissionBloc>().add(LoadTasksForThesis(thesisId: _thesisId!));
                    }
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (state is TasksLoaded && state.tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Chưa có nhiệm vụ nào được giao'),
                SizedBox(height: 8),
                Text('Nhiệm vụ sẽ được tạo sau khi đăng ký đề tài'),
              ],
            ),
          );
        }
        
        // If we have tasks, show them
        if (state is TasksLoaded) {
          return _buildTasksView(state.tasks);
        }
        
        // Fallback
        return const Center(child: Text('Đang tải thông tin...'));
      },
    );
  }
  
  Widget _buildTasksView(List<Task> tasks) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final progress = tasks.isEmpty ? 0.0 : completedTasks / tasks.length;
    final progressPercent = (progress * 100).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          GradientCard(
            gradientColors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.primary,
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.assignment_outlined, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tiến độ thực hiện khóa luận',
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Các nhiệm vụ cần thực hiện trong quá trình làm khóa luận',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hoàn thành: $completedTasks/${tasks.length} nhiệm vụ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Progress overview
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tiến độ thực hiện',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedTasks/${tasks.length} công việc',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '$progressPercent%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getProgressColor(progress),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Task list
          const Text(
            'Danh sách công việc',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          // List of tasks with checkboxes
          if (tasks.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskItem(task);
              },
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('Chưa có công việc nào được tạo'),
              ),
            ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return AppColors.error;
    if (progress < 0.7) return AppColors.warning;
    return AppColors.primary;
  }

  Widget _buildTaskItem(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          _showTaskDetails(task);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      _onTaskCheckedChanged(task.id, value);
                    }
                  },
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                    if (task.dueDate != null)
                      Text(
                        'Hạn: ${_formatDate(task.dueDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  task.isCompleted 
                      ? Icons.task_alt 
                      : Icons.assignment_outlined,
                  color: task.isCompleted ? AppColors.primary : Colors.grey[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Chi tiết công việc:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task.description ?? 'Không có mô tả',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (task.dueDate != null) ...[
              const Text(
                'Thời hạn:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(task.dueDate),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            if (task.priorityText != null) ...[
              const Text(
                'Độ ưu tiên:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                task.priorityText!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _onTaskCheckedChanged(task.id, !task.isCompleted);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.isCompleted ? Colors.grey[300] : AppColors.primary,
                      foregroundColor: task.isCompleted ? Colors.black87 : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(task.isCompleted ? 'Đánh dấu chưa hoàn thành' : 'Đánh dấu hoàn thành'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
