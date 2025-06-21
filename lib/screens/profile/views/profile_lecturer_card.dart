import 'package:flutter/material.dart';
import 'package:thesis_manage_project/utils/logger.dart';

class ProfileLecturerCard extends StatelessWidget {
  final TextEditingController lecturerCodeController;
  final TextEditingController emailController;
  final TextEditingController titleController;
  final int selectedDepartment;
  final List<Map<String, dynamic>> departments;
  final ValueChanged<int?> onDepartmentChanged;

  const ProfileLecturerCard({
    Key? key,
    required this.lecturerCodeController,
    required this.emailController,
    required this.titleController,
    required this.selectedDepartment,
    required this.departments,
    required this.onDepartmentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger('ProfileLecturerCard');
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin giảng viên',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Lecturer code
            TextFormField(
              controller: lecturerCodeController,
              decoration: const InputDecoration(
                labelText: 'Mã số giảng viên',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 20 ký tự',
              ),
              maxLength: 20,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mã số giảng viên';
                }
                if (value.length > 20) {
                  return 'Mã số giảng viên không được vượt quá 20 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Email
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 100 ký tự',
              ),
              maxLength: 100,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                if (value.length > 100) {
                  return 'Email không được vượt quá 100 ký tự';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Title
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Chức danh',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 100 ký tự',
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập chức danh';
                }
                if (value.length > 100) {
                  return 'Chức danh không được vượt quá 100 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Department selection
            DropdownButtonFormField<int>(
              value: departments.isNotEmpty && selectedDepartment != 0
                  ? selectedDepartment
                  : (departments.isNotEmpty ? departments[0]['id'] : 1),
              decoration: const InputDecoration(
                labelText: 'Khoa',
                border: OutlineInputBorder(),
              ),
              items: departments.isEmpty
                  ? [
                      const DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Đang tải...'),
                      ),
                    ]
                  : departments.map((department) {
                      int id = department['id'] is int
                          ? department['id']
                          : int.tryParse(department['id'].toString()) ?? 1;
                      String name = department['name'].toString();
                      logger.debug('Department item: $id: $name');
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(name),
                      );
                    }).toList(),
              onChanged: onDepartmentChanged,
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn khoa';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
