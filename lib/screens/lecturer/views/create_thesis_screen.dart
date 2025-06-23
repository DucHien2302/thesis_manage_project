import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/lecturer_thesis_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/batch_major_bloc.dart';
import 'package:thesis_manage_project/services/batch_major_service.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/utils/user_utils.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/custom_text_field.dart';

class CreateThesisScreen extends StatelessWidget {
  final LecturerThesisBloc lecturerThesisBloc;

  const CreateThesisScreen({
    super.key,
    required this.lecturerThesisBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: lecturerThesisBloc),
        BlocProvider<BatchMajorBloc>(
          create: (context) => BatchMajorBloc(
            service: BatchMajorService(apiService: ApiService()),
          )..add(const LoadBatchesAndMajors()),
        ),
      ],
      child: const _CreateThesisView(),
    );
  }
}

class _CreateThesisView extends StatefulWidget {
  const _CreateThesisView();

  @override
  State<_CreateThesisView> createState() => _CreateThesisViewState();
}

class _CreateThesisViewState extends State<_CreateThesisView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();  int _selectedThesisType = 1;
  String _selectedBatchId = '';
  String _selectedMajorId = '';
  int? _selectedDepartmentId;
  List<String> _selectedReviewerIds = [];
  
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lập đề xuất đề tài'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<LecturerThesisBloc, LecturerThesisState>(
        listener: (context, state) {
          if (state is LecturerThesisCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đề tài đã được tạo thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();          } else if (state is LecturerThesisError) {
            String errorMessage = state.message;
            
            // Simplify error message for user
            if (errorMessage.contains('500')) {
              errorMessage = 'Lỗi server. Vui lòng kiểm tra lại thông tin hoặc thử lại sau.';
            } else if (errorMessage.contains('422')) {
              errorMessage = 'Thông tin đề tài không hợp lệ. Vui lòng kiểm tra lại.';
            } else if (errorMessage.contains('401') || errorMessage.contains('403')) {
              errorMessage = 'Bạn không có quyền thực hiện thao tác này.';
            } else if (errorMessage.contains('kết nối')) {
              errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildCard(
                      title: 'Thông tin cơ bản',
                      children: [                        CustomTextField(
                          controller: _titleController,
                          labelText: 'Tên đề tài',
                          hintText: 'Nhập tên đề tài',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập tên đề tài';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),                        CustomTextField(
                          controller: _descriptionController,
                          labelText: 'Mô tả đề tài',
                          hintText: 'Nhập mô tả chi tiết về đề tài',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập mô tả đề tài';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildThesisTypeDropdown(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      title: 'Thời gian thực hiện',
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                controller: _startDateController,
                                label: 'Ngày bắt đầu',
                                onTap: () => _selectDate(context, isStartDate: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDateField(
                                controller: _endDateController,
                                label: 'Ngày kết thúc',
                                onTap: () => _selectDate(context, isStartDate: false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCard(                      title: 'Thông tin bổ sung',
                      children: [
                        _buildBatchDropdown(),
                        const SizedBox(height: 16),
                        _buildMajorDropdown(),
                        const SizedBox(height: 16),                        _buildDepartmentDropdown(),
                        const SizedBox(height: 16),
                        // Chỉ hiển thị reviewer dropdown khi thesis_type = 2 (Đồ án tốt nghiệp)
                        if (_selectedThesisType == 2) ...[
                          _buildReviewerDropdown(),
                          const SizedBox(height: 16),
                        ],CustomTextField(
                          controller: _notesController,
                          labelText: 'Ghi chú (tùy chọn)',
                          hintText: 'Nhập ghi chú thêm về đề tài',
                          maxLines: 3,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
  Widget _buildThesisTypeDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedThesisType,
      decoration: const InputDecoration(
        labelText: 'Loại đề tài',
        border: OutlineInputBorder(),
      ),      items: const [
        DropdownMenuItem(value: 1, child: Text('Khóa luận kỹ sư')),
        DropdownMenuItem(value: 2, child: Text('Đồ án tốt nghiệp')),
      ],      onChanged: (value) {
        setState(() {
          _selectedThesisType = value!;
          // Reset reviewer selection khi chuyển type
          if (_selectedThesisType != 2) {
            _selectedReviewerIds.clear();
          }
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Vui lòng chọn loại đề tài';
        }
        return null;
      },
      isExpanded: true, // Thêm property này để tránh overflow
    );
  }
  Widget _buildBatchDropdown() {
    return BlocBuilder<BatchMajorBloc, BatchMajorState>(
      builder: (context, state) {
        if (state is BatchMajorLoaded) {          return DropdownButtonFormField<String>(
            value: _selectedBatchId.isEmpty ? null : _selectedBatchId,
            decoration: const InputDecoration(
              labelText: 'Đợt đề tài',
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            items: state.batches.map((batch) {
              return DropdownMenuItem(
                value: batch.id,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${batch.name} (${batch.startDate} - ${batch.endDate})',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBatchId = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng chọn đợt đề tài';
              }
              return null;
            },
          );        } else if (state is BatchMajorLoading) {
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Đang tải...',
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            items: const [],
            onChanged: null,
          );
        } else {
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Lỗi tải dữ liệu',
              border: OutlineInputBorder(),
              errorText: 'Không thể tải danh sách đợt đề tài',
            ),
            isExpanded: true,
            items: const [],
            onChanged: null,
          );
        }
      },
    );
  }
  Widget _buildMajorDropdown() {
    return BlocBuilder<BatchMajorBloc, BatchMajorState>(
      builder: (context, state) {
        if (state is BatchMajorLoaded) {          return DropdownButtonFormField<String>(
            value: _selectedMajorId.isEmpty ? null : _selectedMajorId,
            decoration: const InputDecoration(
              labelText: 'Chuyên ngành',
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            items: state.majors.map((major) {
              return DropdownMenuItem(
                value: major.id,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    major.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMajorId = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng chọn chuyên ngành';
              }
              return null;
            },
          );        } else if (state is BatchMajorLoading) {
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Đang tải...',
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            items: const [],
            onChanged: null,
          );
        } else {
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Lỗi tải dữ liệu',
              border: OutlineInputBorder(),
              errorText: 'Không thể tải danh sách chuyên ngành',
            ),
            isExpanded: true,
            items: const [],
            onChanged: null,
          );
        }
      },
    );
  }

  Widget _buildDepartmentDropdown() {
    return BlocBuilder<BatchMajorBloc, BatchMajorState>(
      builder: (context, state) {
        if (state is BatchMajorLoaded) {          return DropdownButtonFormField<int>(
            value: _selectedDepartmentId,
            decoration: const InputDecoration(
              labelText: 'Khoa/Phòng ban (tùy chọn)',
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            items: state.departments.map((department) {
              return DropdownMenuItem(
                value: department.id,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    department.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDepartmentId = value;
              });
            },
            // Không bắt buộc chọn department
          );        } else if (state is BatchMajorLoading) {
          return DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Đang tải...',
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            items: const [],
            onChanged: null,
          );
        } else {
          return DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Lỗi tải dữ liệu',
              border: OutlineInputBorder(),
              errorText: 'Không thể tải danh sách khoa/phòng ban',
            ),
            isExpanded: true,
            items: const [],
            onChanged: null,
          );
        }
      },
    );
  }

  Widget _buildReviewerDropdown() {
    return BlocBuilder<BatchMajorBloc, BatchMajorState>(
      builder: (context, state) {
        if (state is BatchMajorLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giảng viên phản biện *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [                    ...state.lecturers.map((lecturer) {
                      final isSelected = _selectedReviewerIds.contains(lecturer.id);
                      return CheckboxListTile(
                        title: Text(lecturer.fullName),
                        subtitle: Text('${lecturer.email} • ${lecturer.departmentName ?? 'Không có khoa'}'),
                        value: isSelected,
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedReviewerIds.add(lecturer.id);
                            } else {
                              _selectedReviewerIds.remove(lecturer.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              if (_selectedReviewerIds.isEmpty && _selectedThesisType == 2)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Vui lòng chọn ít nhất một giảng viên phản biện',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );        } else if (state is BatchMajorLoading) {
          return Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else {
          return Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'Lỗi tải danh sách giảng viên',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn ngày';
        }
        return null;
      },
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = _formatDate(picked);
        } else {
          _endDate = picked;
          _endDateController.text = _formatDate(picked);
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<LecturerThesisBloc, LecturerThesisState>(
      builder: (context, state) {
        final isLoading = state is LecturerThesisCreating;
        
        return SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Lập đề xuất đề tài',
            onPressed: isLoading ? null : _submitForm,
            isLoading: isLoading,
            backgroundColor: AppColors.primary,
          ),
        );
      },
    );
  }  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn ngày bắt đầu và ngày kết thúc'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ngày kết thúc phải sau ngày bắt đầu'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validation cho reviewer khi thesis_type = 2 (Đồ án tốt nghiệp)
      if (_selectedThesisType == 2 && _selectedReviewerIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Với loại đề tài Đồ án tốt nghiệp, phải chọn ít nhất một giảng viên phản biện'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get current user info for debugging
      final userInfo = await UserUtils.getCurrentUserInfo();
      print('Full user info: $userInfo');
      
      // Get current user ID
      final currentUserId = await UserUtils.getCurrentUserId();
      print('Current user ID: $currentUserId');
      
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể xác định thông tin người dùng. Vui lòng đăng nhập lại.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }      final thesisRequest = ThesisCreateRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        thesisType: _selectedThesisType,
        startDate: _startDate!.toIso8601String(), // Bỏ .toUtc() để giữ timezone local
        endDate: _endDate!.toIso8601String(), // Bỏ .toUtc() để giữ timezone local
        status: 1, // Đổi từ 0 thành 1 - có thể backend yêu cầu status = 1
        batchId: _selectedBatchId,
        majorId: _selectedMajorId,
        departmentId: _selectedDepartmentId, // Sử dụng department được chọn hoặc null
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        instructorIds: [currentUserId],
        reviewerIds: _selectedReviewerIds, // Sử dụng danh sách reviewer đã chọn
      );

      context.read<LecturerThesisBloc>().add(CreateThesis(thesisRequest: thesisRequest));
    }
  }
}
