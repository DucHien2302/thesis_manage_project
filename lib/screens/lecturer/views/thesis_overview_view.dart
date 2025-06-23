import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/lecturer_thesis_bloc.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class ThesisOverviewView extends StatefulWidget {
  final TabController? tabController;
  
  const ThesisOverviewView({super.key, this.tabController});

  @override
  State<ThesisOverviewView> createState() => _ThesisOverviewViewState();
}

class _ThesisOverviewViewState extends State<ThesisOverviewView> {  @override
  void initState() {
    super.initState();
    // Load data when view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LecturerThesisBloc>().add(const LoadLecturerTheses());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LecturerThesisBloc, LecturerThesisState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome card
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school_outlined,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quản lý đề tài',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tổng quan về các đề tài đang hướng dẫn',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
                // Statistics cards
              if (state is LecturerThesisLoaded) ...[
                _buildStatsGrid(_calculateStats(state.theses)),
              ] else if (state is LecturerThesisLoading) ...[
                _buildLoadingStats(),
              ] else if (state is LecturerThesisError) ...[
                _buildErrorStats(state.message),
              ] else ...[
                _buildEmptyStats(),
              ],
              
              const SizedBox(height: 16),
              
              // Quick actions
              _buildQuickActions(context),
            ],
          ),
        );
      },
    );
  }
  Widget _buildStatsGrid(Map<String, int> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Tổng đề tài',
          stats['total']?.toString() ?? '0',
          Icons.assignment_outlined,
          AppColors.primary,
        ),
        _buildStatCard(
          'Đã duyệt',
          stats['approved']?.toString() ?? '0',
          Icons.check_circle_outlined,
          Colors.green,
        ),
        _buildStatCard(
          'Chờ duyệt',
          stats['pending']?.toString() ?? '0',
          Icons.pending_outlined,
          Colors.orange,
        ),
        _buildStatCard(
          'Từ chối',
          stats['rejected']?.toString() ?? '0',
          Icons.cancel_outlined,
          Colors.red,
        ),
      ],
    );
  }  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLoadingStats() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: List.generate(4, (index) {
        return ModernCard(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }),
    );
  }

  Widget _buildErrorStats(String message) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Lỗi tải thống kê',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStats() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Chưa có dữ liệu thống kê',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy tạo đề tài đầu tiên để xem thống kê',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thao tác nhanh',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildQuickActionButton(
            context,
            icon: Icons.add_circle_outline,
            title: 'Lập đề xuất đề tài mới',
            subtitle: 'Tạo đề tài mới để sinh viên đăng ký',
            color: AppColors.primary,
            onTap: () {
              // Navigate to create thesis
              Navigator.pushNamed(context, '/lecturer/create-thesis');
            },
          ),
          
          const SizedBox(height: 12),
            _buildQuickActionButton(
            context,
            icon: Icons.list_alt_outlined,
            title: 'Xem tất cả đề tài',
            subtitle: 'Quản lý và theo dõi các đề tài đang hướng dẫn',
            color: Colors.blue,
            onTap: () {
              // Switch to management tab
              widget.tabController?.animateTo(1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  // Calculate statistics from theses list
  Map<String, int> _calculateStats(List<dynamic> theses) {
    // Filter out registered and unregistered status as per requirement
    final filteredTheses = theses.where((thesis) {
      final status = thesis.status ?? '';
      return !status.contains('Đã được đăng ký') && 
             !status.contains('Chưa được đăng ký');
    }).toList();

    final Map<String, int> stats = {
      'total': filteredTheses.length,
      'approved': 0,
      'pending': 0,
      'rejected': 0,
    };

    for (final thesis in filteredTheses) {
      final status = (thesis.status ?? '').toLowerCase();
      if (status.contains('đã duyệt')) {
        stats['approved'] = (stats['approved'] ?? 0) + 1;
      } else if (status.contains('chờ duyệt')) {
        stats['pending'] = (stats['pending'] ?? 0) + 1;
      } else if (status.contains('từ chối')) {
        stats['rejected'] = (stats['rejected'] ?? 0) + 1;
      }
    }

    return stats;
  }
}
