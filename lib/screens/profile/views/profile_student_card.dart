import 'package:flutter/material.dart';
import 'package:thesis_manage_project/utils/logger.dart';

class ProfileStudentCard extends StatelessWidget {
  final TextEditingController studentCodeController;
  final TextEditingController classNameController;
  final String selectedMajorId;
  final List<Map<String, dynamic>> majors;
  final ValueChanged<String?> onMajorChanged;

  const ProfileStudentCard({
    Key? key,
    required this.studentCodeController,
    required this.classNameController,
    required this.selectedMajorId,
    required this.majors,
    required this.onMajorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger('ProfileStudentCard');
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin sinh viên',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Student code
            TextFormField(
              controller: studentCodeController,
              decoration: const InputDecoration(
                labelText: 'Mã số sinh viên',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 20 ký tự',
              ),
              maxLength: 20,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mã số sinh viên';
                }
                if (value.length > 20) {
                  return 'Mã số sinh viên không được vượt quá 20 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Class name
            TextFormField(
              controller: classNameController,
              decoration: const InputDecoration(
                labelText: 'Lớp',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 50 ký tự',
              ),
              maxLength: 50,
              validator: (value) {
                if (value != null && value.length > 50) {
                  return 'Tên lớp không được vượt quá 50 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Major selection
            DropdownButtonFormField<String>(
              value: selectedMajorId.isNotEmpty &&
                      majors.isNotEmpty &&
                      majors.any((m) => m['id'].toString() == selectedMajorId)
                  ? selectedMajorId
                  : (majors.isNotEmpty ? majors[0]['id'].toString() : ''),
              decoration: const InputDecoration(
                labelText: 'Chuyên ngành',
                border: OutlineInputBorder(),
              ),
              items: majors.isEmpty
                  ? [
                      const DropdownMenuItem<String>(
                        value: '',
                        child: Text('Đang tải...'),
                      ),
                    ]
                  : majors.map((major) {
                      String id = major['id'].toString();
                      String name = major['name'].toString();
                      logger.debug('Major item: $id: $name');
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(name),
                      );
                    }).toList(),
              onChanged: onMajorChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn chuyên ngành';
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
