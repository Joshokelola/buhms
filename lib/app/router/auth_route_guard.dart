import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/features/booking/data/book_hostel_repo.dart';
import 'package:buhms/features/payment/data/payment_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    final getIt = GetIt.instance;
    final supabase = getIt<SupabaseClient>();
    if (supabase.auth.currentSession != null) {
      // if user is authenticated we continue
      resolver.next();
    } else if (supabase.auth.currentSession == null) {
      // we redirect the user to our login page
      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirect(
        const ChooseRolePage(),
      );
    }
  }
}

// class LoginGuard extends AutoRouteGuard {
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     final getIt = GetIt.instance;
//     final supabase = getIt<SupabaseClient>();
//     if (supabase.auth.currentSession != null) {
//       resolver.redirect(const HomeRoute());
//     }
//   }
// }

class PaymentGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final getIt = GetIt.instance;
    final container = ProviderContainer();

    var hasPaid = container.read(hasUserPaidProvider);
    if (hasPaid == null) {
      final supabase = getIt<SupabaseClient>();
      final paymentRepo = PaymentRepoImpl(getIt);

      final res = await paymentRepo.checkIfUserHasPaid(
        userId: supabase.auth.currentSession!.user.id,
      );

      hasPaid = res.fold(
        (l) => false,
        (r) => r,
      );

      // Cache the result
      container.read(hasUserPaidProvider.notifier).state = hasPaid;
    }

    Logger().i(hasPaid);

    if (!hasPaid!) {
      await resolver.redirect(const PaymentPage());
    } else {
      resolver.next();
    }
  }
}

//TODO - Remove this guard eventually
//Just show that the user has selected a room already.
class CheckIfUserHasRoomGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final getIt = GetIt.instance;
    final container = ProviderContainer();

    var userHasRoom = container.read(userHasRoomProvider);

    if (userHasRoom == null) {
      final supabase = getIt<SupabaseClient>();
      final hostelRepo = BookHostelRepoImpl(getIt);
      final res = await hostelRepo.checkIfUserHasRoom(
        userId: supabase.auth.currentSession!.user.id,
      );

      userHasRoom = res.fold((l) => false, (r) => true);
      container.read(userHasRoomProvider.notifier).state = userHasRoom;

      if (userHasRoom!) {
        await resolver.redirect(const RoomDetailsPage());
      } else {
        resolver.next();
      }
    }
  }
}

final hasUserPaidProvider = StateProvider<bool?>((ref) => null);
final userHasRoomProvider = StateProvider<bool?>((ref) => null);
