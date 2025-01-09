import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ChooseRolePage extends ConsumerStatefulWidget {
  const ChooseRolePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends ConsumerState<ChooseRolePage> {
  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF009ECE);
    const secondaryGreen = Color(0xFF006C3B);
    const accentGold = Color(0xFFFFD700);
    const bgColor = Color(0xFFF5F7FA);
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Row(
          children: [
            SizedBox(width: context.fivePercentWidth),
            Image.asset('assets/images/logo.png', height: 60),
            SizedBox(width: context.onePercentWidth),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bells University of Technology',
                  style: TextStyle(
                    color: Color(0xFF009ECE),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'only the best, is good for bells...',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    color: Color(0xFF006C3B),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 100,
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Content
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Welcome Text
                  const Text(
                    'WELCOME',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: accentGold,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  const Text(
                    'Please select your login portal',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login Buttons
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildPortalButton(
                            title: 'STUDENT PORTAL',
                            color: primaryBlue,
                            icon: Icons.school,
                            maxWidth: constraints.maxWidth,
                            onTap: () {
                              context.pushRoute(const SignInPage());
                            },
                          ),
                          _buildPortalButton(
                            title: 'STAFF PORTAL',
                            color: secondaryGreen,
                            icon: Icons.work,
                            maxWidth: constraints.maxWidth,
                            onTap: () {
                              context.pushRoute(const StaffSignInPage());
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black,
        child: const Text(
          '© 2024 Bells University of Technology | Proudly designed by Group 6',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPortalButton({
    required String title,
    required Color color,
    required IconData icon,
    required double maxWidth,
    required void Function()? onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: maxWidth > 600 ? (maxWidth - 20) / 2 : maxWidth,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
