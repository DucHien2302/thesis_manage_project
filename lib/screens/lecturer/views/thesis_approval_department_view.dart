import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_approval_models.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/thesis_approval_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/widgets/thesis_approval_modal.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/loading_indicator.dart';

class ThesisApprovalDepartmentView extends StatefulWidget {
  const ThesisApprovalDepartmentView({super.key});

  @override
  State<ThesisApprovalDepartmentView> createState() => _ThesisApprovalDepartmentViewState();
}

class _ThesisApprovalDepartmentViewState extends State<ThesisApprovalDepartmentView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = '';
  final Set<String> _selectedTheses = <String>{};
  bool _isSelectMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThesisApprovalBloc>().add(
        const LoadThesesForApproval(ApprovalType.department),
      );
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ThesisApprovalBloc>().add(
      FilterTheses(
        searchQuery: _searchController.text,
        statusFilter: _selectedStatusFilter,
      ),
    );
  }

  void _onStatusFilterChanged(String? status) {
    setState(() {
      _selectedStatusFilter = status ?? '';
    });
    context.read<ThesisApprovalBloc>().add(
      FilterTheses(
        searchQuery: _searchController.text,
        statusFilter: _selectedStatusFilter,
      ),
    );
  }

  void _toggleSelectMode() {
    setState(() {
      _isSelectMode = !_isSelectMode;
      if (!_isSelectMode) {
        _selectedTheses.clear();
      }
    });
  }

  void _toggleThesisSelection(String thesisId) {
    setState(() {
      if (_selectedTheses.contains(thesisId)) {
        _selectedTheses.remove(thesisId);
      } else {
        _selectedTheses.add(thesisId);
      }
    });
  }

  void _selectAllTheses(List<ThesisModel> theses) {
    setState(() {
      if (_selectedTheses.length == theses.length) {
        _selectedTheses.clear();
      } else {
        _selectedTheses.clear();
        _selectedTheses.addAll(theses.map((t) => t.id));
      }
    });
  }
  void _showBatchApprovalDialog() {
    if (_selectedTheses.isEmpty) return;

    final bloc = context.read<ThesisApprovalBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Duyệt hàng loạt'),
        content: Text('Bạn có chắc chắn muốn duyệt ${_selectedTheses.length} đề tài đã chọn?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(
                BatchApproveTheses(
                  thesisIds: _selectedTheses.toList(),
                  newStatus: ThesisStatus.departmentApproved,
                ),
              );
              _toggleSelectMode();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Duyệt'),
          ),
        ],
      ),
    );
  }
  void _showBatchRejectDialog() {
    if (_selectedTheses.isEmpty) return;

    final TextEditingController reasonController = TextEditingController();
    final bloc = context.read<ThesisApprovalBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Từ chối hàng loạt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bạn có chắc chắn muốn từ chối ${_selectedTheses.length} đề tài đã chọn?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Lý do từ chối',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập lý do từ chối'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(dialogContext);
              bloc.add(
                BatchRejectTheses(
                  thesisIds: _selectedTheses.toList(),
                  reason: reasonController.text.trim(),
                ),
              );
              _toggleSelectMode();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Từ chối'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThesisApprovalBloc, ThesisApprovalState>(
      listener: (context, state) {
        if (state is ThesisApprovalActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is ThesisApprovalBatchSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is ThesisApprovalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm đề tài...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatusFilter.isEmpty ? null : _selectedStatusFilter,
                        decoration: InputDecoration(
                          labelText: 'Lọc theo trạng thái',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: '',
                            child: Text('Tất cả'),
                          ),
                          const DropdownMenuItem(
                            value: 'Chờ duyệt',
                            child: Text('Chờ duyệt'),
                          ),
                          const DropdownMenuItem(
                            value: 'Đã duyệt cấp bộ môn',
                            child: Text('Đã duyệt cấp bộ môn'),
                          ),
                        ],
                        onChanged: _onStatusFilterChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Select Mode Toggle
                    IconButton(
                      onPressed: _toggleSelectMode,
                      icon: Icon(
                        _isSelectMode ? Icons.cancel : Icons.checklist,
                        color: _isSelectMode ? AppColors.error : AppColors.primary,
                      ),
                      tooltip: _isSelectMode ? 'Hủy chọn' : 'Chọn nhiều',
                    ),
                    
                    // Refresh Button
                    IconButton(
                      onPressed: () {
                        context.read<ThesisApprovalBloc>().add(const RefreshTheses());
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Làm mới',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Batch Action Bar (when in select mode)
          if (_isSelectMode) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.primary.withOpacity(0.1),
              child: Row(
                children: [
                  Text(
                    'Đã chọn: ${_selectedTheses.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  
                  BlocBuilder<ThesisApprovalBloc, ThesisApprovalState>(
                    builder: (context, state) {
                      if (state is ThesisApprovalLoaded) {
                        return TextButton(
                          onPressed: () => _selectAllTheses(state.filteredTheses),
                          child: Text(
                            _selectedTheses.length == state.filteredTheses.length 
                                ? 'Bỏ chọn tất cả' 
                                : 'Chọn tất cả',
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  
                  const SizedBox(width: 8),
                  
                  ElevatedButton.icon(
                    onPressed: _selectedTheses.isEmpty ? null : _showBatchApprovalDialog,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Duyệt'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  ElevatedButton.icon(
                    onPressed: _selectedTheses.isEmpty ? null : _showBatchRejectDialog,
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Từ chối'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Thesis List
          Expanded(
            child: BlocBuilder<ThesisApprovalBloc, ThesisApprovalState>(
              builder: (context, state) {
                if (state is ThesisApprovalLoading || state is ThesisApprovalProcessing) {                  return const LoadingIndicator(message: 'Đang tải danh sách đề tài...');
                }

                if (state is ThesisApprovalError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Có lỗi xảy ra',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<ThesisApprovalBloc>().add(
                              const LoadThesesForApproval(ApprovalType.department),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ThesisApprovalLoaded) {
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
                            'Không có đề tài nào cần duyệt',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tất cả đề tài đã được xử lý',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ThesisApprovalBloc>().add(const RefreshTheses());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: theses.length,
                      itemBuilder: (context, index) {
                        final thesis = theses[index];
                        final isSelected = _selectedTheses.contains(thesis.id);

                        return ModernCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(                            onTap: () {                              if (_isSelectMode) {
                                _toggleThesisSelection(thesis.id);
                              } else {
                                ThesisApprovalModal.show(
                                  context,
                                  thesis,
                                  ApprovalType.department,
                                ).then((result) {
                                  // Reload data if changes were made
                                  if (result == true) {
                                    context.read<ThesisApprovalBloc>().add(const RefreshTheses());
                                  }
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: _isSelectMode && isSelected
                                    ? Border.all(color: AppColors.primary, width: 2)
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header Row
                                    Row(
                                      children: [
                                        if (_isSelectMode) ...[
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (_) => _toggleThesisSelection(thesis.id),
                                            activeColor: AppColors.primary,
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        
                                        Expanded(
                                          child: Text(
                                            thesis.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(thesis.status).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            thesis.status,
                                            style: TextStyle(
                                              color: _getStatusColor(thesis.status),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    
                                    // Description
                                    Text(
                                      thesis.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    
                                    // Info Row
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 16,
                                          color: Colors.grey[500],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            thesis.instructors.isNotEmpty
                                                ? thesis.instructors.map((i) => i.name).join(', ')
                                                : 'Chưa có GVHD',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        
                                        Icon(
                                          Icons.school,
                                          size: 16,
                                          color: Colors.grey[500],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          thesis.major,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    if (!_isSelectMode) ...[
                                      const SizedBox(height: 16),
                                      
                                      // Action Buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {
                                                ThesisApprovalModal.show(
                                                  context,
                                                  thesis,
                                                  ApprovalType.department,
                                                ).then((result) {
                                                  // Reload data if changes were made
                                                  if (result == true) {
                                                    context.read<ThesisApprovalBloc>().add(const RefreshTheses());
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.visibility, size: 16),
                                              label: const Text('Chi tiết'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: AppColors.primary,
                                                side: BorderSide(color: AppColors.primary),
                                              ),
                                            ),
                                          ),
                                          
                                          const SizedBox(width: 8),
                                          
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                ThesisApprovalModal.show(
                                                  context,
                                                  thesis,
                                                  ApprovalType.department,
                                                ).then((result) {
                                                  if (result == true) {
                                                    context.read<ThesisApprovalBloc>().add(const RefreshTheses());
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.check, size: 16),
                                              label: const Text('Duyệt'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.success,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          );
                        },
                      ),
                    ); // End of RefreshIndicator
                }

                return const Center(
                  child: Text('Không có dữ liệu'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Improved color differentiation for statuses
  Color _getStatusColor(String status) {
    if (status.contains('Chờ duyệt')) {
      return AppColors.warning; // Yellow
    } else if (status.contains('Đã duyệt cấp bộ môn')) {
      return AppColors.info; // Blue
    } else if (status.contains('Đã duyệt cấp khoa')) {
      return AppColors.success; // Green
    } else if (status.contains('Từ chối')) {
      return AppColors.error; // Red
    }
    return Colors.grey;
  }
}
