import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/core/extensions/context_extensions.dart';
import 'package:buhms/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  // Focus nodes
  late FocusNode emailFocus;
  late FocusNode passwordFocus;
  late FocusNode usernameFocus;
  late FocusNode firstNameFocus;
  late FocusNode lastNameFocus;
  late FocusNode matricNumberFocus;
  late FocusNode phoneFocus;
  late FocusNode ageFocus;
  late FocusNode genderFocus;

  // Value notifiers for focus states
  final ValueNotifier<bool> emailFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> passwordFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> usernameFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> firstNameFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> lastNameFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> matricNumberFocusNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> phoneFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> ageFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> genderFocusNotifier = ValueNotifier<bool>(false);

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final levelController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final matricNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize focus nodes
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    usernameFocus = FocusNode();
    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    matricNumberFocus = FocusNode();
    phoneFocus = FocusNode();
    ageFocus = FocusNode();
    genderFocus = FocusNode();

    // Add focus listeners
    emailFocus.addListener(() {
      emailFocusNotifier.value = emailFocus.hasFocus;
    });
    passwordFocus.addListener(() {
      passwordFocusNotifier.value = passwordFocus.hasFocus;
    });
    usernameFocus.addListener(() {
      usernameFocusNotifier.value = usernameFocus.hasFocus;
    });
    firstNameFocus.addListener(() {
      firstNameFocusNotifier.value = firstNameFocus.hasFocus;
    });
    lastNameFocus.addListener(() {
      lastNameFocusNotifier.value = lastNameFocus.hasFocus;
    });
    matricNumberFocus.addListener(() {
      matricNumberFocusNotifier.value = matricNumberFocus.hasFocus;
    });
    phoneFocus.addListener(() {
      phoneFocusNotifier.value = phoneFocus.hasFocus;
    });
    ageFocus.addListener(() {
      ageFocusNotifier.value = ageFocus.hasFocus;
    });
    genderFocus.addListener(() {
      ageFocusNotifier.value = ageFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    // Dispose focus nodes
    emailFocus.dispose();
    passwordFocus.dispose();
    usernameFocus.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    matricNumberFocus.dispose();
    phoneFocus.dispose();
    ageFocus.dispose();
    genderFocus.dispose();

    // Dispose value notifiers
    emailFocusNotifier.dispose();
    passwordFocusNotifier.dispose();
    usernameFocusNotifier.dispose();
    firstNameFocusNotifier.dispose();
    lastNameFocusNotifier.dispose();
    matricNumberFocusNotifier.dispose();
    phoneFocusNotifier.dispose();
    ageFocusNotifier.dispose();
    genderFocusNotifier.dispose();

    super.dispose();
  }

  InputDecoration _getInputDecoration({
    required String label,
    required String hint,
    required bool isFocused,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
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
    );
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
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                width: 600,
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
                    return _signUpForm(context);
                  },
                  loading: () {
                    return AbsorbPointer(
                      // absorbing: true,
                      child: Stack(
                        children: [
                          _signUpForm(context),
                          Container(
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    );
                  },
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

  Form _signUpForm(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Student Registration',
            style: TextStyle(
              color: Color(0xFF009ECE),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Create your account'),
          SizedBox(height: context.highValue),
          // Email and Password Row
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: emailFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,
                      validator: (string) {
                        return ref
                            .read(
                              authNotifierProvider.notifier,
                            )
                            .validateEmail(string);
                      },
                      decoration: _getInputDecoration(
                        label: 'Email',
                        hint: 'Enter your email',
                        isFocused: isFocused,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: passwordFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      obscureText: ref.watch(visibilityProvider),
                      validator: (string) {
                        return ref
                            .read(
                              authNotifierProvider.notifier,
                            )
                            .validatePassword(string);
                      },
                      decoration: _getInputDecoration(
                        label: 'Password',
                        hint: 'Enter your password',
                        isFocused: isFocused,
                        suffixIcon: IconButton(
                          onPressed: () {
                            ref
                                .read(
                                  visibilityProvider.notifier,
                                )
                                .update((state) => !state);
                          },
                          icon: ref.watch(visibilityProvider)
                              ? const Icon(Icons.visibility)
                              : const Icon(
                                  Icons.visibility_off,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.sevenPercentValue),
          // Level and Username Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: _getInputDecoration(
                    label: 'Level',
                    hint: 'Select your level',
                    isFocused: false,
                  ),
                  items: [100, 200, 300, 400, 500].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    levelController.text = newValue.toString();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: usernameFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: userNameController,
                      focusNode: usernameFocus,
                      decoration: _getInputDecoration(
                        label: 'Username',
                        hint: 'Enter your username',
                        isFocused: isFocused,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.sevenPercentValue),
          // Matric Number and First Name Row
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: matricNumberFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: matricNumberController,
                      focusNode: matricNumberFocus,
                      decoration: _getInputDecoration(
                        label: 'Matric Number',
                        hint: 'Enter your matric number',
                        isFocused: isFocused,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: firstNameFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: firstNameController,
                      focusNode: firstNameFocus,
                      decoration: _getInputDecoration(
                        label: 'First Name',
                        hint: 'Enter your first name',
                        isFocused: isFocused,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.sevenPercentValue),
          // Last Name and Phone Number Row
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: lastNameFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: lastNameController,
                      focusNode: lastNameFocus,
                      decoration: _getInputDecoration(
                        label: 'Last Name',
                        hint: 'Enter your last name',
                        isFocused: isFocused,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: phoneFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: phoneNumberController,
                      focusNode: phoneFocus,
                      decoration: _getInputDecoration(
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        isFocused: isFocused,
                      ),
                      keyboardType: TextInputType.phone,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.sevenPercentValue),
          // Age and Gender Row
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: ageFocusNotifier,
                  builder: (_, isFocused, __) {
                    return TextFormField(
                      controller: ageController,
                      focusNode: ageFocus,
                      decoration: _getInputDecoration(
                        label: 'Age',
                        hint: 'Enter your age',
                        isFocused: isFocused,
                      ),
                      keyboardType: TextInputType.number,
                    );
                  },
                ),
              ),
              SizedBox(width: context.defaultValue),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: genderFocusNotifier,
                  builder: (_, isFocused, __) {
                    return DropdownButtonFormField<String>(
                      decoration: _getInputDecoration(
                        label: 'Gender',
                        hint: '',
                        isFocused: isFocused,
                      ),
                      items: ['Male', 'Female', 'Other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Handle gender change
                        genderController.text = newValue!;
                        debugPrint(newValue);
                        //TODO - Get selected value here
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.sevenPercentValue),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: SizedBox(
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
                  // Handle form submission
                  if (formKey.currentState!.validate()) {
                    ref.read(authNotifierProvider.notifier).signUp(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          levelController.text.trim(),
                          userNameController.text.trim(),
                          matricNumberController.text.trim(),
                          firstNameController.text.trim(),
                          lastNameController.text.trim(),
                          phoneNumberController.text.trim(),
                          ageController.text.trim(),
                          genderController.text.trim(),
                        );
                  }
                },
                child: ref.watch(authNotifierProvider).maybeWhen(
                      orElse: () => const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white),
                      ),
                      loading: () => const CircularProgressIndicator(),
                    ),
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              context.replaceRoute(const SignInPage());
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
