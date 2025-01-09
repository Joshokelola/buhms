import 'dart:async';

import 'package:buhms/app/router/auth_listenable.dart';
import 'package:buhms/features/authentication/data/auth_repo.dart';
import 'package:buhms/features/authentication/presentation/states/auth_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fzregex/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';

class AuthNotifier extends Notifier<AuthenticationState> {
  late AuthRepoImpl authRepoImpl;
  late AuthProvider authchanges;
  @override
  AuthenticationState build() {
    authRepoImpl = ref.read(authRepoImplProvider);
    authchanges = ref.read(authChangesProvider);
    return const AuthenticationState.initial();
  }

  Future<void> login(String email, String password) async {
    state = const AuthenticationState.loading();
    final response =
        await authRepoImpl.signIn(email: email, password: password);
    //authchanges.login();
    state = response.fold((l) {
      return AuthenticationState.unauthenticated(message: l);
    }, (r) {
      return AuthenticationState.authenticated(response: r);
    });
  }

  Future<void> loginStaff(String email, String password) async {
    state = const AuthenticationState.loading();
    final response =
        await authRepoImpl.signInAsStaff(email: email, password: password);
    //authchanges.login();
    state = response.fold((l) {
      return AuthenticationState.unauthenticated(message: l);
    }, (r) {
      return AuthenticationState.authenticated(response: r);
    });
  }

  Future<void> logout() {
    final res = authRepoImpl.logOut();
    state = const AuthenticationState.unauthenticated();
    return res;
  }

  Future<void> signUp(
    String email,
    String password,
    String level,
    String userName,
    String matricNumber,
    String firstName,
    String lastName,
    String phoneNumber,
    String age,
    String gender,
  ) async {
    state = const AuthenticationState.loading();
    final response = await authRepoImpl.signUp(
      email: email,
      password: password,
      level: level,
      userName: userName,
      matricNumber: matricNumber,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      age: age,
      gender: gender,
    );
    // authchanges.login();
    state = response.fold((l) {
      return AuthenticationState.unauthenticated(message: l);
    }, (r) {
      return AuthenticationState.authenticated(response: r);
    });
  }

  String? validateEmail(String? email) {
    if (Fzregex.hasMatch(email!, FzPattern.email)) {
      return null;
    }
    return 'Please enter valid email';
  }

  String? validatePassword(String? password) {
    if (Fzregex.hasMatch(password!, FzPattern.passwordEasy)) {
      return null;
    }
    //TODO - Need to output a more meaningful msg here.
    return 'Enter minimum of 8 characters';
    // return '''Must contains at least: 1 uppercase letter, 1 lowercase letter,
    //         1 number,& 1 special character (symbol) Minimum character: 8''';
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (Fzregex.hasMatch(phoneNumber!, FzPattern.phone)) {
      return null;
    } else {
      return 'Enter valid phone number';
    }
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthenticationState>(AuthNotifier.new);
