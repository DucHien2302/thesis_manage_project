import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/lecturer_thesis_bloc.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/lecturer/views/create_thesis_screen.dart';

class ThesisManagementView extends StatefulWidget {
  const ThesisManagementView({super.key});

  @override
  State<ThesisManagementView> createState() => _ThesisManagementViewState();
}

class _ThesisManagementViewState extends State<ThesisManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = '';

  @override
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<LecturerThesisBloc>().add(
          FilterLecturerTheses(
            status: _selectedStatusFilter,
            searchQuery: query,
          ),
        );
  }

  void _onStatusFilterChanged(String? status) {
    setState(() {
      _selectedStatusFilter = status ?? '';
    });
    context.read<LecturerThesisBloc>().add(
          FilterLecturerTheses(
            status: _selectedStatusFilter,
            searchQuery: _searchController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filter
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
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
                          Icons.assignment_outlined,
                          color: AppColors.primary,
                          size: 24,
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
                            Text(
                              'Theo dõi và quản lý các đề tài đang hướng dẫn',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Search bar
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => _onSearchChanged(),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm đề tài...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Filter dropdown
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatusFilter.isEmpty ? null : _selectedStatusFilter,
                          decoration: InputDecoration(
                            labelText: 'Lọc theo trạng thái',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: [
                            const DropdownMenuItem(value: '', child: Text('Tất cả')),
                            const DropdownMenuItem(value: 'Đã duyệt', child: Text('Đã duyệt')),
                            const DropdownMenuItem(value: 'Chờ duyệt', child: Text('Chờ duyệt')),
                            const DropdownMenuItem(value: 'Từ chối', child: Text('Từ chối')),
                          ],
                          onChanged: _onStatusFilterChanged,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          final bloc = context.read<LecturerThesisBloc>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateThesisScreen(
                                lecturerThesisBloc: bloc,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Lập đề xuất'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Thesis list
            Expanded(
              child: BlocBuilder<LecturerThesisBloc, LecturerThesisState>(
                builder: (context, state) {
                  if (state is LecturerThesisLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is LecturerThesisError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Có lỗi xảy ra',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<LecturerThesisBloc>().add(const LoadLecturerTheses());
                            },
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is LecturerThesisLoaded) {
                    final theses = state.filteredTheses;
                    
                    if (theses.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có đề tài nào',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hãy lập đề xuất đề tài đầu tiên của bạn',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                final bloc = context.read<LecturerThesisBloc>();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateThesisScreen(
                                      lecturerThesisBloc: bloc,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Lập đề xuất đề tài'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<LecturerThesisBloc>().add(const RefreshLecturerTheses());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: theses.length,
                        itemBuilder: (context, index) {
                          final thesis = theses[index];
                          return _buildThesisCard(thesis);
                        },
                      ),
                    );
                  }
                  
                  return const Center(
                    child: Text('Đang tải...'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThesisCard(ThesisModel thesis) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    thesis.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusChip(thesis.status),
              ],
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              thesis.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            
            // Details
            Row(
              children: [                _buildDetailItem(
                  Icons.calendar_today_outlined,
                  'Ngày bắt đầu',
                  _formatDate(thesis.startDate ?? ''),
                ),
                const SizedBox(width: 24),
                _buildDetailItem(
                  Icons.category_outlined,
                  'Loại',
                  thesis.thesisType == 1 ? 'Khóa luận' : 'Đồ án',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to thesis detail
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('Xem chi tiết'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to edit thesis
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Chỉnh sửa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'đã duyệt':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'chờ duyệt':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case 'từ chối':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
