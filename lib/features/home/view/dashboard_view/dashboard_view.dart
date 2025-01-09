import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/features/home/view/controller/user_controller.dart';
import 'package:buhms/features/home/widgets/action_card.dart';
import 'package:buhms/features/home/widgets/profile_info_item.dart';
import 'package:buhms/features/payment/services/payment_controller.dart';
import 'package:buhms/features/rooms/presentation/controllers/room_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ... other imports remain the same

@RoutePage()
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  static const primaryBlue = Color(0xFF009ECE);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(paymentNotifierProvider.notifier).checkPaymentState();
      ref.read(userNotifierProvider.notifier).getUserProfile();
      ref.read(roomNotifierProvider.notifier).getUserRoom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: true,
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          color: const Color(0xFFF5F6FA),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: isMobile ? screenWidth : 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  if (isMobile)
                    Column(
                      children: [
                        _buildProfileCard(),
                        const SizedBox(height: 16),
                        _buildStatsCard(),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildProfileCard()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildStatsCard()),
                      ],
                    ),
                  const SizedBox(height: 24),
                  // Action Grid
                  _buildActionGrid(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return ref.watch(userNotifierProvider).maybeWhen(
      orElse: () {
        return const _DashboardCard(
          title: 'Student Profile',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfoItem(label: 'Name', value: 'Loading...'),
              ProfileInfoItem(label: 'ID', value: 'Loading...'),
              ProfileInfoItem(label: 'Level', value: 'Loading...'),
            ],
          ),
        );
      },
      error: (failed) {
        return Text(failed!.message);
      },
      loaded: (data) {
        return _DashboardCard(
          title: 'Student Profile',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfoItem(
                label: 'Name',
                value: '${data.lastName.capitalize()} ${data.firstName}',
              ),
              ProfileInfoItem(
                label: 'ID',
                value: data.matricNumber,
              ),
              ProfileInfoItem(label: 'Level', value: data.level),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return _DashboardCard(
      title: 'Quick Stats',
      child: Column(
        children: [
          _buildStatsContent(),
          const SizedBox(height: 16),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: primaryBlue,
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     child: const Text(
          //       'View Room Details',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildStatsContent() {
    return Column(
      children: [
        ref.watch(roomNotifierProvider).maybeWhen(
          orElse: () {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileInfoItem(
                  label: 'Room Number',
                  value: 'Loading...',
                ),
                ProfileInfoItem(
                  label: 'Hostel Block',
                  value: 'Loading...',
                ),
              ],
            );
          },
          data: (data) {
            if (data.hostelId == '') {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileInfoItem(
                    label: 'Room Number',
                    value: 'nil',
                  ),
                  ProfileInfoItem(
                    label: 'Hostel Block',
                    value: 'nil',
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileInfoItem(
                    label: 'Room Number',
                    value: data.roomNumber,
                  ),
                  ProfileInfoItem(
                    label: 'Hostel Block',
                    value: data.hostelName,
                  ),
                ],
              );
            }
          },
        ),
        ProfileInfoItem(
          label: 'Fee Status',
          value: ref.watch(paymentNotifierProvider).maybeWhen(
                orElse: () => 'Paid ✓',
                loading: () => 'Loading...',
                successful: (data) =>
                    data is bool ? (data ? 'Paid ✓' : 'Not Paid') : '',
              ),
          valueColor: const Color(0xFF27AE60),
        ),
      ],
    );
  }

  Widget _buildActionGrid(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: isMobile ? 2 : 4,
      mainAxisSpacing: isMobile ? 16 : 24,
      crossAxisSpacing: isMobile ? 16 : 24,
      childAspectRatio: isMobile ? 1.1 : 1.2,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // ActionCard(
        //   title: 'Attendance',
        //   subtitle: 'View Records',
        //   onTap: () {},
        //   backgroundColor: Colors.red.shade100,
        // ),
        ActionCard(
          title: 'Room Details',
          subtitle: 'Manage Room',
          onTap: () {
            context.pushRoute(const RoomDetailsPage());
          },
          backgroundColor: Colors.blue.shade100,
        ),
        ActionCard(
          title: 'Maintenance',
          subtitle: 'Report Issue',
          onTap: () {},
          backgroundColor: Colors.purple.shade100,
        ),
        ActionCard(
          title: 'Payments',
          subtitle: 'View History',
          onTap: () {},
          backgroundColor: Colors.yellow.shade100,
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.child,
  });
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
