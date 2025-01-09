import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_repo.g.dart';

abstract class UserRepo {
  Future<Either<Failed, Student>> getStudentProfile({required String userId});
}

class UserRepoImpl implements UserRepo {
  UserRepoImpl(this.getIt);

  final GetIt getIt;
  @override
  Future<Either<Failed, Student>> getStudentProfile({
    required String userId,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();
      final response = await supabase
          .from('users')
          .select(
            'id, username, first_name, last_name, age, email,gender, level, phone_number, matric_number',
          )
          .eq('id', userId);
      final decodedRes = response[0];
      final decodedStudent = Student(
        id: decodedRes['id'] as String,
        email: decodedRes['email'] as String,
        level: decodedRes['level'] as String,
        userName: decodedRes['username'] as String,
        matricNumber: decodedRes['matric_number'] as String,
        firstName: decodedRes['first_name'] as String,
        lastName: decodedRes['last_name'] as String,
        phoneNumber: decodedRes['phone_number'] as String,
        age: decodedRes['age'] as String,
        gender: decodedRes['gender'] as String,
      );
      Logger().i(decodedStudent);
      return right(decodedStudent);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }
}

@riverpod
UserRepoImpl userRepoImpl(UserRepoImplRef ref) {
  return UserRepoImpl(ref.read(getItProvider));
}
