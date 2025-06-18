import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  _ApiTestScreenState createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  String _apiResponse = '';
  bool _isLoading = false;
  String _selectedMethod = 'GET';
  final List<String> _endpoints = [
    ApiConfig.login,
    ApiConfig.register,
    ApiConfig.me,
    ApiConfig.users,
    ApiConfig.lecturers,
    ApiConfig.theses,
    ApiConfig.majors,
    ApiConfig.departments,
    ApiConfig.batches,
    ApiConfig.myGroups,
  ];

  @override
  void initState() {
    super.initState();
    _urlController.text = _endpoints.first;

    // Nếu endpoint là login, tự động thêm body mẫu
    if (_urlController.text == ApiConfig.login) {
      _bodyController.text = jsonEncode({
        'user_name': 'student1',
        'password': '123456',
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _testApi() async {
    String endpoint = _urlController.text;
    
    // Nếu người dùng nhập URL đầy đủ, trích xuất phần endpoint
    if (endpoint.startsWith('http')) {
      final uri = Uri.parse(endpoint);
      final baseUrl = '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ":${uri.port}" : ""}';
      endpoint = endpoint.replaceFirst(baseUrl, '');
    }
    
    setState(() {
      _isLoading = true;
      _apiResponse = 'Đang gọi API...';
    });

    try {
      dynamic response;
      dynamic body;
      
      // Parse body JSON nếu có
      if (_bodyController.text.isNotEmpty) {
        try {
          body = jsonDecode(_bodyController.text);
        } catch (e) {
          setState(() {
            _isLoading = false;
            _apiResponse = 'Lỗi: Body JSON không hợp lệ\n${e.toString()}';
          });
          return;
        }
      }

      // Gọi API theo phương thức đã chọn
      if (_selectedMethod == 'GET') {
        response = await _apiService.get(endpoint);
      } else {
        response = await _apiService.post(endpoint, body: body);
      }

      // Hiển thị kết quả
      setState(() {
        _isLoading = false;
        _apiResponse = JsonEncoder.withIndent('  ').convert(response);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _apiResponse = 'Lỗi: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test Tool'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // URL input
            const Text(
              'Endpoints:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _urlController.text.isNotEmpty ? _urlController.text : _endpoints.first,
              items: _endpoints
                  .map((endpoint) => DropdownMenuItem(
                        value: endpoint,
                        child: Text(endpoint),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _urlController.text = value;
                    
                    // Nếu endpoint là login, tự động thêm body mẫu
                    if (value == ApiConfig.login) {
                      _bodyController.text = jsonEncode({
                        'user_name': 'student1',
                        'password': '123456',
                      });
                    } else {
                      _bodyController.clear();
                    }
                  });
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Chọn endpoint',
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Endpoint URL',
                hintText: '/auth/login',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16.0),
            
            // HTTP Method Selection
            Row(
              children: [
                const Text(
                  'HTTP Method:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'GET', label: Text('GET')),
                    ButtonSegment(value: 'POST', label: Text('POST')),
                  ],
                  selected: {_selectedMethod},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedMethod = newSelection.first;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16.0),
            
            // Request Body
            const Text(
              'Request Body (JSON):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _bodyController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '{"user_name": "student1", "password": "123456"}',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Test Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _testApi,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Test API'),
              ),
            ),

            const SizedBox(height: 16.0),
            
            // Response Section
            const Text(
              'API Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _apiResponse,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
