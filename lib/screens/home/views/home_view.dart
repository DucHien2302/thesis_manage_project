import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    // Trang chủ
    Center(
      child: Text(
        'Trang chủ',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // Quản lý đề tài
    Center(
      child: Text(
        'Quản lý đề tài',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // Quản lý nhóm
    Center(
      child: Text(
        'Quản lý nhóm',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // Thông tin cá nhân
    Center(
      child: Text(
        'Thông tin cá nhân',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final user = authBloc.state is Authenticated
        ? (authBloc.state as Authenticated).user
        : null;

    final String userName = user?['user_name'] ?? 'Người dùng';
    final String userType = user?['user_type_name'] ?? '';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.marginRegular),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userType,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
              selected: _selectedIndex == 0,
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Quản lý đề tài'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
              selected: _selectedIndex == 1,
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Quản lý nhóm'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
              selected: _selectedIndex == 2,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Thông tin cá nhân'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
              selected: _selectedIndex == 3,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Đề tài',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Nhóm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
