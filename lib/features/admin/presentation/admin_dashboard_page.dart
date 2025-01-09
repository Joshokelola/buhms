//TODO: When logout is clicked, navigate back to chooseRole page.

import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/features/admin/domain/admin_dashboard_item.dart';
import 'package:buhms/features/admin/presentation/controllers/admin_controller.dart';
import 'package:buhms/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool isSidebarVisible = true;

  // final List<Map<String, dynamic>> dashboardItems = [
  //   {'title': 'Students', 'count': '5', 'color': Colors.blue},
  //   {'title': 'Total Rooms', 'count': '6', 'color': Colors.green},
  //   {'title': 'Registered Complaints', 'count': '7', 'color': Colors.red},
  //   {'title': 'In Process Complaints', 'count': '1', 'color': Colors.orange},
  //   {'title': 'Closed Complaints', 'count': '5', 'color': Colors.green},
  // ];

  // final List<String> menuItems = [
  //   'Dashboard',
  //   'Courses',
  //   'Rooms',
  //   'Student Registration',
  //   'Manage Students',
  //   'Complaints',
  //   'Feedback',
  //   'User Access logs',
  // ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(adminNotifierProvider.notifier).loadAdminDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        unauthenticated: (message) {
          context.replaceRoute(const ChooseRolePage());
        },
      );
    });

    return Scaffold(
      body: Row(
        children: [
          //   if (isSidebarVisible) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: _buildDashboardGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSidebar() {
  //   return Container(
  //     width: 250,
  //     color: const Color(0xFF2C3E50),
  //     child: Column(
  //       children: menuItems
  //           .map((item) => ListTile(
  //                 title: Text(
  //                   item,
  //                   style: const TextStyle(color: Colors.white),
  //                 ),
  //                 onTap: () {
  //                   // Handle menu item tap
  //                 },
  //               ))
  //           .toList(),
  //     ),
  //   );
  // }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF2C3E50),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              setState(() {
                isSidebarVisible = !isSidebarVisible;
              });
            },
          ),
          const Text(
            'Bells Hostel Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF2C3E50)),
            ),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                onTap: ref.read(authNotifierProvider.notifier).logout,
                value: 'logout',
                child: const Text('Logout'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid() {
    final adminState = ref.watch(adminNotifierProvider);

    return adminState.maybeWhen(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      successful: (data) {
        final adminData = data;
        final students = adminData!.students;
        final pendingMaintenanceRequests = adminData.maintenanceRequests
            .where((data) => data.status == 'pending')
            .toList();

        final inProgressMaintenanceRequests = adminData.maintenanceRequests
            .where((data) => data.status == 'in progress')
            .toList();
        final completedMaintenanceRequests = adminData.maintenanceRequests
            .where((data) => data.status == 'completed')
            .toList();
        final adminDashboardItems = <AdminDashboardItem>[
          AdminDashboardItem(
            title: 'Total Rooms',
            count: data!.roomCount.toString(),
            color: Colors.green,
          ),
          AdminDashboardItem(
            title: 'Registered Complaints',
            count: pendingMaintenanceRequests.length.toString(),
            requests: pendingMaintenanceRequests,
            color: Colors.red,
          ),
          AdminDashboardItem(
            title: 'In Process Complaints',
            count: inProgressMaintenanceRequests.length.toString(),
            requests: inProgressMaintenanceRequests,
            color: Colors.orange,
          ),
          AdminDashboardItem(
            title: 'Completed Complaints',
            count: completedMaintenanceRequests.length.toString(),
            requests: completedMaintenanceRequests,
            color: Colors.green,
          ),
          AdminDashboardItem(
            title: 'Students',
            count: students.length.toString(),
            color: Colors.blue,
          ),
        ];
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: adminDashboardItems.length,
          itemBuilder: (context, index) {
            final item = adminDashboardItems[index];
            return Card(
              color: item.color,
              child: InkWell(
                onTap: () {
                  if (index != 0 && index != 4) {
                    context.pushRoute(
                      AdminMaintenancePage(
                        dashboardItems: item,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.count!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      const Row(
                        children: [
                          Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      orElse: () {
        return Container();
      },
    );
  }
}
