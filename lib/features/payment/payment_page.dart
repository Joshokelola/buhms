import 'package:auto_route/auto_route.dart';
import 'package:buhms/features/payment/r.dart';
import 'package:buhms/features/payment/services/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});
  //TODO - Check guard docs on auto_route . something about creating a callback property for this class.
//TODO - Figure out how to automatically navigate to the expected page once payment has been made.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch payment state for loading/error states
    final paymentState = ref.watch(paymentNotifierProvider);

    return const Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text('Payment Required'),
      // ),
      body: TestPaymentPage(),
    );
  }
}


// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Please make payment to access this feature'),
//             const SizedBox(height: 20),
//             if (paymentState.isLoading)
//               const CircularProgressIndicator()
//             else
//               ElevatedButton(
//                 onPressed: () async {
//                   await ref
//                       .read(paymentNotifierProvider.notifier)
//                       .makePayment();
//                  ref.read(authChangesProvider).notifyChange();
            
      
//                   // After payment, recheck payment status
//                   await ref
//                       .read(paymentNotifierProvider.notifier)
//                       .checkPaymentState();
//                 },
//                 child: const Text('Make Payment'),
//               ),
//             if (paymentState.hasError)
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   'Error: ${paymentState.error?.message}',
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),