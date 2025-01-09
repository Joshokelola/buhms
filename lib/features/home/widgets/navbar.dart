import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:flutter/material.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedAppBar({super.key, this.logoutAction});
  final void Function()? logoutAction;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      if (isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2C3E50),
            Color(0xFF3498DB),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: isMobile
            ? IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  color: Colors.white,
                  progress: _animationController,
                ),
                onPressed: () {
                  _toggleMenu();
                  Scaffold.of(context).openDrawer();
                },
              )
            : null,
        actions: [
          if (widget.logoutAction != null)
            IconButton(
              onPressed: widget.logoutAction,
              icon: const Icon(Icons.logout_outlined),
            ),
        ],
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              width: 40,
            ),
            if (!isMobile) ...[
              const SizedBox(width: 32),
              Expanded(
                child: Row(
                  children: [
                    _NavBarItem(
                      title: 'Dashboard',
                      onTap: () {
                        context.pushRoute(const DashboardRoute());
                      },
                    ),
                    _NavBarItem(
                      title: 'Hostel Fee',
                      onTap: () {
                        context.pushRoute(const PaymentPage());
                      },
                    ),
                    _NavBarItem(title: 'Attendance', onTap: () {}),
                    _NavBarItem(
                      title: 'Room Allocation',
                      onTap: () {
                        context.pushRoute(const RoomAllocationRoute());
                      },
                    ),
                    _NavBarItem(
                      title: 'Maintenance',
                      onTap: () {
                        context.pushRoute(const MaintenancePage());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF2C3E50),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2C3E50),
                    Color(0xFF3498DB),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _DrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
                context.pushRoute(const DashboardRoute());
              },
            ),
            _DrawerItem(
              icon: Icons.payment,
              title: 'Hostel Fee',
              onTap: () {
                Navigator.pop(context);
                context.pushRoute(const PaymentPage());
              },
            ),
            _DrawerItem(
              icon: Icons.check_circle,
              title: 'Attendance',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.room,
              title: 'Room Allocation',
              onTap: () {
                Navigator.pop(context);
                context.pushRoute(const RoomAllocationRoute());
              },
            ),
            _DrawerItem(
              icon: Icons.build,
              title: 'Maintenance',
              onTap: () {
                Navigator.pop(context);
                context.pushRoute(const MaintenancePage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.title,
    required this.onTap,
  });
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
