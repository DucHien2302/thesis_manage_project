import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/models/group_models.dart' as group_models;
import 'package:thesis_manage_project/screens/thesis/bloc/thesis_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/components/animated_loading.dart';

class ThesisRegistrationScreen extends StatefulWidget {
  final group_models.GroupModel group;

  const ThesisRegistrationScreen({
    super.key,
    required this.group,
  });

  @override
  State<ThesisRegistrationScreen> createState() => _ThesisRegistrationScreenState();
}

class _ThesisRegistrationScreenState extends State<ThesisRegistrationScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load available thesis when screen opens
    context.read<ThesisBloc>().add(GetAvailableThesisEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      appBar: AppBar(
        title: const Text('Đăng ký đề tài'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm đề tài...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          context.read<ThesisBloc>().add(GetAvailableThesisEvent());
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                if (value.isNotEmpty) {
                  context.read<ThesisBloc>().add(SearchThesisEvent(query: value));
                } else {
                  context.read<ThesisBloc>().add(GetAvailableThesisEvent());
                }
              },
            ),
          ),
          // Thesis list
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<GroupBloc, GroupState>(
                  listener: (context, state) {
                    if (state is ThesisRegisteredState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đăng ký đề tài thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pop(state.updatedGroup);
                    } else if (state is GroupErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi: ${state.error}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<ThesisBloc, ThesisState>(
                builder: (context, state) {
                  if (state is ThesisLoadingState) {
                    return const Center(child: AnimatedLoadingIndicator());
                  } else if (state is ThesisListLoadedState) {
                    return _buildThesisList(state.thesisList);
                  } else if (state is ThesisSearchResultsState) {
                    return _buildThesisList(state.searchResults, isSearchResult: true);
                  } else if (state is ThesisErrorState) {
                    return _buildErrorWidget(state.error);
                  }
                  return const Center(
                    child: Text('Chưa có dữ liệu đề tài'),
                  );
                },
              ),
            ),
          ),
        ],
      ),      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ThesisBloc>().add(RefreshThesisEvent());
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildThesisList(List<ThesisModel> thesisList, {bool isSearchResult = false}) {
    if (thesisList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchResult ? Icons.search_off : Icons.assignment_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isSearchResult 
                  ? 'Không tìm thấy đề tài nào phù hợp'
                  : 'Chưa có đề tài nào có sẵn',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ThesisBloc>().add(RefreshThesisEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: thesisList.length,
        itemBuilder: (context, index) {
          final thesis = thesisList[index];
          return _buildThesisCard(thesis);
        },
      ),
    );
  }

  Widget _buildThesisCard(ThesisModel thesis) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => _showThesisDetails(thesis),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      thesis.title,                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: thesis.isRegistrationOpen ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      thesis.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                thesis.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'GVHD: ${thesis.lecturerName ?? 'Chưa có'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.school, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Chuyên ngành: ${thesis.majorName}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Loại: ${thesis.thesisTypeName}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: thesis.isRegistrationOpen 
                      ? () => _showRegistrationConfirmation(thesis)
                      : null,
                  icon: const Icon(Icons.app_registration),                  label: const Text('Đăng ký đề tài'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
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
            'Có lỗi xảy ra',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ThesisBloc>().add(RefreshThesisEvent());
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  void _showThesisDetails(ThesisModel thesis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thesis.title,                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Trạng thái', thesis.status),
                      _buildDetailRow('Loại đề tài', thesis.thesisTypeName),
                      _buildDetailRow('Chuyên ngành', thesis.majorName ?? 'Chưa xác định'),
                      _buildDetailRow('GVHD', thesis.lecturerName ?? 'Chưa có'),
                      if (thesis.reviewers.isNotEmpty)
                        _buildDetailRow('Phản biện', thesis.reviewers.map((r) => r.name).join(', ')),
                      if (thesis.startDate != null)
                        _buildDetailRow('Ngày bắt đầu', thesis.startDate!),
                      if (thesis.endDate != null)
                        _buildDetailRow('Ngày kết thúc', thesis.endDate!),
                      const SizedBox(height: 16),
                      const Text(
                        'Mô tả chi tiết:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        thesis.description,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      if (thesis.notes != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Ghi chú:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          thesis.notes!,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: thesis.isRegistrationOpen 
                              ? () {
                                  Navigator.of(context).pop();
                                  _showRegistrationConfirmation(thesis);
                                }
                              : null,
                          icon: const Icon(Icons.app_registration),                          label: const Text('Đăng ký đề tài này'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegistrationConfirmation(ThesisModel thesis) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng ký'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn có chắc chắn muốn đăng ký đề tài này cho nhóm?'),
            const SizedBox(height: 16),
            Text(
              'Đề tài: ${thesis.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Nhóm: ${widget.group.name ?? 'Chưa đặt tên'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              final isLoading = state is GroupLoadingState;
              return ElevatedButton(
                onPressed: isLoading 
                    ? null 
                    : () {
                        Navigator.of(context).pop();
                        context.read<GroupBloc>().add(
                          RegisterThesisEvent(
                            groupId: widget.group.id,
                            thesisId: thesis.id,
                          ),
                        );
                      },                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Đăng ký'),
              );
            },
          ),
        ],
      ),
    );
  }
}
