import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/web.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repo.g.dart';

abstract class AuthRepo {
  Future<Either<Failed, AuthResponse>> signUp({
    required String email,
    required String password,
    required String level,
    required String userName,
    required String matricNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String age,
    required String gender,
  });

  Future<Either<Failed, AuthResponse>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failed, AuthResponse>> signInAsStaff({
    required String email,
    required String password,
  });

  Future<void> logOut();
}

class AuthRepoImpl extends AuthRepo {
  AuthRepoImpl(this.getIt);
  final GetIt getIt;

  @override
  Future<Either<Failed, AuthResponse>> signIn({
    required String email,
    required String password,
  }) async {
    final supabase = getIt<SupabaseClient>();
    try {
      final response = await supabase.auth
          .signInWithPassword(password: password, email: email);
      return right(response);
    } on AuthException catch (e) {
      return left(Failed(code: e.statusCode, message: e.message));
    }
  }

  @override
  Future<Either<Failed, AuthResponse>> signUp({
    required String email,
    required String password,
    required String level,
    required String userName,
    required String matricNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String age,
    required String gender,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'level': level,
          'userName': userName,
          'matricNumber': matricNumber,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'age': age,
          'gender': gender,
        },
      );
      return right(response);
    } on AuthException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<void> logOut() {
    final supabase = getIt<SupabaseClient>();
    return supabase.auth.signOut();
  }

  @override
  Future<Either<Failed, AuthResponse>> signInAsStaff({
    required String email,
    required String password,
  }) async {
    // TODO: Check if present in staff table first
    final supabase = getIt<SupabaseClient>();
    try {
      final response = await supabase.auth
          .signInWithPassword(password: password, email: email);

      final userEmail = response.session?.user.email;
      Logger().i(userEmail);
      final checkIfUserEmailInStaffs =
          await supabase.from('staffs').select().eq('email', userEmail!);
      Logger().i(checkIfUserEmailInStaffs);
      if (checkIfUserEmailInStaffs.isEmpty) {
        return left(
          Failed(code: 'not-an-admin', message: "You're not an admin."),
        );
      }

      return right(response);
    } on AuthException catch (e) {
      return left(Failed(code: e.statusCode, message: e.message));
    }
  }
}

@riverpod
AuthRepoImpl authRepoImpl(AuthRepoImplRef ref) {
  return AuthRepoImpl(ref.read(getItProvider));
}
