import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/student_models.dart';
import 'package:thesis_manage_project/repositories/student_repository.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/custom_text_field.dart';
import 'package:thesis_manage_project/widgets/loading_indicator.dart';

class InviteMemberView extends StatefulWidget {
  final String groupId;

  const InviteMemberView({Key? key, required this.groupId}) : super(key: key);

  @override
  State<InviteMemberView> createState() => _InviteMemberViewState();
}

class _InviteMemberViewState extends State<InviteMemberView> {
  final TextEditingController _searchController = TextEditingController();
  late StudentRepository _studentRepository;
  List<StudentModel> _students = [];
  List<StudentModel> _filteredStudents = [];
  bool _isLoading = true;
  bool _isInviting = false;
  String? _currentUserId;
  String? _lastErrorMessage; // To prevent duplicate error messages

  @override
  void initState() {
    super.initState();
    _studentRepository = StudentRepository(apiService: ApiService());
    
    // Get current user ID
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _currentUserId = authState.user['id']?.toString();
    }
    
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final students = await _studentRepository.getAllStudents();
      
      // Filter out current user
      final filteredStudents = students.where((student) => 
        student.id != _currentUserId).toList();
      
      setState(() {
        _students = filteredStudents;
        _filteredStudents = filteredStudents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Show some dummy data if API fails
        _students = [
          StudentModel(
            id: '1',
            userName: 'nguyenvana',
            information: InformationModel(
              id: '1',
              userId: '1',
              firstName: 'Nguyễn Văn',
              lastName: 'A',
              dateOfBirth: '2000-01-01',
              gender: 1,
              address: 'TP.HCM',
              telPhone: '0123456789',
            ),
            studentInfo: StudentInfoModel(
              id: '1',
              userId: '1',
              studentCode: '20110001',
              className: 'KHMT2021',
              majorId: '1',
              majorName: 'Công nghệ thông tin',
              createDatetime: '2021-01-01',
              updateDatetime: '2021-01-01',
            ),
          ),
          StudentModel(
            id: '2',
            userName: 'tranthib',
            information: InformationModel(
              id: '2',
              userId: '2',
              firstName: 'Trần Thị',
              lastName: 'B',
              dateOfBirth: '2000-02-01',
              gender: 0,
              address: 'TP.HCM',
              telPhone: '0123456788',
            ),
            studentInfo: StudentInfoModel(
              id: '2',
              userId: '2',
              studentCode: '20110002',
              className: 'KHMT2021',
              majorId: '1',
              majorName: 'Công nghệ thông tin',
              createDatetime: '2021-01-01',
              updateDatetime: '2021-01-01',
            ),
          ),
        ];
        _filteredStudents = _students;
      });
    }
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_students);
      } else {
        _filteredStudents = _students
            .where((student) => 
                student.fullName.toLowerCase().contains(query.toLowerCase()) ||
                student.studentCode.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mời thành viên'),
      ),      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupErrorState) {
            // Prevent duplicate error messages
            if (_lastErrorMessage != state.error) {
              _lastErrorMessage = state.error;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            setState(() {
              _isInviting = false;
            });          } else if (state is InviteSentState) {
            _lastErrorMessage = null; // Reset error message on success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã gửi lời mời thành công')),
            );
            setState(() {
              _isInviting = false;
            });
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextField(
                controller: _searchController,
                hintText: 'Tìm sinh viên theo tên hoặc mã số',
                labelText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                onChanged: _filterStudents,
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const LoadingIndicator(message: 'Đang tải danh sách sinh viên...')
                  : _isInviting
                      ? const LoadingIndicator(message: 'Đang gửi lời mời...')
                      : _filteredStudents.isEmpty
                          ? _buildEmptySearchResult()
                          : _buildStudentList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchResult() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Không tìm thấy sinh viên nào',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Thử tìm kiếm với từ khóa khác',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildStudentList() {
    return RefreshIndicator(
      onRefresh: _loadStudents,
      child: ListView.builder(
        itemCount: _filteredStudents.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final student = _filteredStudents[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  // Student Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'MSSV: ${student.studentCode}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Ngành: ${student.majorName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Action Button
                  SizedBox(
                    width: 60,
                    child: CustomButton(
                      text: 'Mời',
                      onPressed: () => _sendInvite(student.id),
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      fullWidth: false,
                      height: 36,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }  void _sendInvite(String studentId) {
    setState(() {
      _isInviting = true;
    });
    context.read<GroupBloc>().add(
      SendInviteEvent(
        receiverId: studentId,
        groupId: widget.groupId,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
