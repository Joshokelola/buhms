import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/core/extensions/context_extensions.dart';
import 'package:buhms/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  late FocusNode emailFocus;
  late FocusNode passwordFocus;

  // ValueNotifiers to track focus state
  final ValueNotifier<bool> emailFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> passwordFocusNotifier = ValueNotifier<bool>(false);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    emailFocus = FocusNode();
    passwordFocus = FocusNode();

    emailFocus.addListener(() {
      emailFocusNotifier.value = emailFocus.hasFocus;
    });
    passwordFocus.addListener(() {
      passwordFocusNotifier.value = passwordFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    emailFocusNotifier.dispose();
    passwordFocusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          context.replaceRoute(const HomeRoute());
        },
        unauthenticated: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message!.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: context.height,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ref.watch(authNotifierProvider).maybeWhen(
                        orElse: () {
                          return _signInForm(context);
                        },
                        loading: () {
                          return AbsorbPointer(
                            // absorbing: true,
                            child: Stack(
                              children: [
                                _signInForm(context),
                                Container(
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              color: Colors.black,
              child: const Center(
                child: Text(
                  '© 2024 Bells University of Technology | Proudly designed by Group 6',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Form _signInForm(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Student Login',
            style: TextStyle(
              color: Color(0xFF009ECE),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Enter your credentials'),
          SizedBox(height: context.highValue),
          ValueListenableBuilder(
            valueListenable: emailFocusNotifier,
            builder: (_, isFocused, __) {
              return TextFormField(
                controller: emailController,
                focusNode: emailFocus,
                validator: (string) {
                  return ref
                      .read(authNotifierProvider.notifier)
                      .validateEmail(string);
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  hoverColor: Colors.transparent,
                  fillColor: isFocused ? Colors.white : const Color(0xFFEEEEEE),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF009ECE),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: context.highValue),
          ValueListenableBuilder(
            valueListenable: passwordFocusNotifier,
            builder: (_, isFocused, __) {
              return TextFormField(
                controller: passwordController,
                focusNode: passwordFocus,
                obscureText: ref.watch(visibilityProvider),
                validator: (string) {
                  return ref
                      .read(authNotifierProvider.notifier)
                      .validatePassword(string);
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      ref
                          .read(visibilityProvider.notifier)
                          .update((state) => !state);
                    },
                    icon: ref.watch(visibilityProvider)
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  hoverColor: Colors.transparent,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isFocused ? Colors.white : const Color(0xFFEEEEEE),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF009ECE),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: context.highValue),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (ref.watch(authNotifierProvider).maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      )) {
                    return Colors.grey[400];
                  }
                  return states.contains(WidgetState.disabled)
                      ? Colors.grey[400]
                      : const Color(
                          0xFF3498DB,
                        );
                }),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ref.read(authNotifierProvider.notifier).login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                }
              },
              child: ref.watch(authNotifierProvider).maybeWhen(
                    orElse: () => const Text(
                      'Log In',
                      style: TextStyle(color: Colors.white),
                    ),
                    loading: () => const CircularProgressIndicator(),
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.replaceRoute(const SignUpPage());
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
