import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileInformationCard extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final DateTime selectedDate;
  final int selectedGender;
  final VoidCallback onDateTap;
  final ValueChanged<int?> onGenderChanged;

  const ProfileInformationCard({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.addressController,
    required this.phoneController,
    required this.selectedDate,
    required this.selectedGender,
    required this.onDateTap,
    required this.onGenderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin cá nhân',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // First name
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'Họ',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 50 ký tự',
              ),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ';
                }
                if (value.length > 50) {
                  return 'Họ không được vượt quá 50 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Last name
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 50 ký tự',
              ),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                if (value.length > 50) {
                  return 'Tên không được vượt quá 50 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Gender selection
            DropdownButtonFormField<int>(
              value: selectedGender,
              decoration: const InputDecoration(
                labelText: 'Giới tính',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Nam')),
                DropdownMenuItem(value: 1, child: Text('Nữ')),
                DropdownMenuItem(value: 2, child: Text('Khác')),
              ],
              onChanged: onGenderChanged,
            ),
            const SizedBox(height: 16),
            
            // Date of birth
            InkWell(
              onTap: onDateTap,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Address
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 255 ký tự',
              ),
              maxLength: 255,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                if (value.length > 255) {
                  return 'Địa chỉ không được vượt quá 255 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Phone
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
                helperText: 'Tối đa 15 ký tự',
              ),
              maxLength: 15,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                if (value.length > 15) {
                  return 'Số điện thoại không được vượt quá 15 ký tự';
                }
                // Basic phone number validation
                if (!RegExp(r'^\d{10,15}$').hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
                  return 'Số điện thoại không hợp lệ';
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
