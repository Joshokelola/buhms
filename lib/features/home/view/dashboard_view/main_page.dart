import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

  // SizedBox(
  //         width: 200,
  //         child: Ink(
  //           //  color: Colors.grey,
  //           child: Column(
  //             children: [
  //               DrawerWidget(
  //                 icon: Icons.dashboard,
  //                 text: 'Home',
  //                 onTap: () {
  //                   context.pushRoute(const DashboardRoute());
  //                 },
  //               ),
  //               DrawerWidget(
  //                 icon: Icons.note_add,
  //                 text: 'Book Hostel',
  //                 onTap: () {
  //                   context.pushRoute( const BookHostelPage());
  //                 },
  //               ),
  //               DrawerWidget(
  //                 icon: Icons.hotel,
  //                 text: 'Room details',
  //                 onTap: () {
  //                   context.pushRoute(const RoomDetailsPage());
  //                 },
  //               ),
  //               DrawerWidget(
  //                 icon: Icons.help_center,
  //                 text: 'Maintenance Requests',
  //                 onTap: () {
  //                   context.pushRoute(const MaintenanceRequestsPage());
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),