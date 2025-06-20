import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/widgets/custom_navigation_bar.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

/// Unified base dashboard component for consistent UI across all user roles
class UnifiedDashboardBase extends StatefulWidget {
  final String title;
  final Color themeColor;
  final List<NavigationItem> navigationItems;
  final List<Widget> tabViews;
  final List<DashboardStatCard> statCards;
  final Widget? floatingActionButton;
  final bool useBottomNavigation;
  final List<Widget>? appBarActions;

  const UnifiedDashboardBase({
    Key? key,
    required this.title,
    required this.themeColor,
    required this.navigationItems,
    required this.tabViews,
    this.statCards = const [],
    this.floatingActionButton,
    this.useBottomNavigation = true,
    this.appBarActions,
  }) : super(key: key);

  @override
  State<UnifiedDashboardBase> createState() => _UnifiedDashboardBaseState();
}

class _UnifiedDashboardBaseState extends State<UnifiedDashboardBase>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.navigationItems.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: AppColors.error),
              const SizedBox(width: 8),
              const Text('Xác nhận đăng xuất'),
            ],
          ),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<AuthBloc>(context).add(const LogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    final authState = context.read<AuthBloc>().state;
    final userData = authState is Authenticated ? authState.user : {};
    final userName = userData['user_name'] ?? 'Người dùng';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.themeColor.withOpacity(0.1),
            Colors.transparent
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: widget.themeColor.withOpacity(0.2),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.themeColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào, $userName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.statCards.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildStatCards(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.statCards.length,
        itemBuilder: (context, index) {
          final stat = widget.statCards[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            child: ModernCard(
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    stat.icon,
                    color: stat.color ?? widget.themeColor,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    stat.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.useBottomNavigation ? AppBar(
        title: Text(widget.title),
        backgroundColor: widget.themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          ...?widget.appBarActions,
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
      ) : AppBar(
        title: Text(widget.title),
        backgroundColor: widget.themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          ...?widget.appBarActions,
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: widget.navigationItems.map((item) => Tab(
            icon: Icon(item.icon),
            text: item.label,
          )).toList(),
        ),
      ),
      body: widget.useBottomNavigation ? Column(
        children: [
          _buildHeader(),
          Expanded(
            child: widget.tabViews[_currentIndex],
          ),
        ],
      ) : TabBarView(
        controller: _tabController,
        children: widget.tabViews,
      ),
      bottomNavigationBar: widget.useBottomNavigation ? CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: widget.navigationItems,
      ) : null,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}

/// Data class for dashboard statistics cards
class DashboardStatCard {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const DashboardStatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });
}
