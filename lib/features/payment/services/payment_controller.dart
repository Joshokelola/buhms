// ignore_for_file: strict_raw_type

import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/payment/data/payment_repo.dart';
import 'package:buhms/features/payment/services/payment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentNotifier extends Notifier<PaymentState> {
  late PaymentRepoImpl paymentRepoImpl;

  @override
  PaymentState build() {
    paymentRepoImpl = ref.read(paymentProviderProvider);
    return const PaymentState.initial();
  }

  Future<void> checkPaymentState() async {
    state = const PaymentState.loading();
    final res = await paymentRepoImpl.checkIfUserHasPaid(
      userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
    );
    state = res.fold((l) {
      return PaymentState.error(message: l);
    }, (r) {
      return PaymentState.successful(data: r);
    });
  }

  Future<void> makePayment() async {
    state = const PaymentState.loading();
    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(seconds: 5));
    final res = await paymentRepoImpl.makePayment(
      userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
    );
    state = res.fold((l) {
      return PaymentState.error(message: l);
    }, (r) {
      return PaymentState.successful(data: r);
    });
  }
}

final paymentNotifierProvider =
    NotifierProvider<PaymentNotifier, PaymentState>(PaymentNotifier.new);
