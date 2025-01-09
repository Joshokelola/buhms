import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/payment/domain/payment.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'payment_repo.g.dart';

abstract class PaymentRepo {
  Future<Either<Failed, bool>> checkIfUserHasPaid({
    required String userId,
  });

  Future<Either<Failed, Payment>> makePayment({
    required String userId,
  });
}

class PaymentRepoImpl extends PaymentRepo {
  PaymentRepoImpl(this.getIt);
  final GetIt getIt;
  @override
  Future<Either<Failed, bool>> checkIfUserHasPaid(
      //For this usecase, its a mock payment hence status is going to be of type 'pending' or 'completed'
      {
    required String userId,
  }) async {
    final supabase = getIt<SupabaseClient>();
    try {
      final response = await supabase.from('payments').select('status').eq(
            'user_id',
            userId,
          ); //This gives a response of --> [{status: pending}]
      final decodedResponse = response[0]['status'];
      debugPrint(decodedResponse.toString());
      if (decodedResponse == 'pending') {
        return right(false);
      } else {
        return right(true);
      }
      // //Need to get the response
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, Payment>> makePayment({required String userId}) async {
    final supabase = getIt<SupabaseClient>();
    try {
      final response = await supabase
          .from('payments')
          .update({
            'status': 'completed',
            'payment_date': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select();
      final decodedResponse = response[0];
      final paymentDecoded = Payment(
        id: decodedResponse['id'] as String,
        userId: decodedResponse['user_id'] as String,
        amount: decodedResponse['amount'] as double,
        paymentDate: DateTime.now(),
        status: decodedResponse['status'] as String,
      );
      //debugPrint(response.toString());
      debugPrint(paymentDecoded.toString());
      return right(paymentDecoded);
      //return right(Payment.defaultPayment());
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }
}

@riverpod
PaymentRepoImpl paymentProvider(PaymentProviderRef ref) {
  return PaymentRepoImpl(ref.read(getItProvider));
}
