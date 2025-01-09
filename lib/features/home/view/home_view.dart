import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:buhms/features/home/view/dashboard_view/main_page.dart';
import 'package:buhms/features/home/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AnimatedAppBar(
            logoutAction: ref.read(authNotifierProvider.notifier).logout,
          ),
          drawer: const CustomDrawer(),
          body: const MainPage(),
          // drawer: const Drawer(
          //   child: Column(
          //     children: [
          //       DrawerWidget(
          //         icon: Icons.dashboard,
          //         text: 'Dashboard',
          //       ),
          //       DrawerWidget(
          //         icon: Icons.note_add,
          //         text: 'Book Hostel',
          //       ),
          //       DrawerWidget(
          //         icon: Icons.hotel,
          //         text: 'Room details',
          //       ),
          //       DrawerWidget(
          //         icon: Icons.help_center,
          //         text: 'Maintenance Requests',
          //       ),
          //     ],
          //   ),
          // ),
        );
      },
    );
  }
}
