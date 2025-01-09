import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/app/router/auth_route_guard.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
@AutoRouterConfig(replaceInRouteName: 'Page,Route')

/// Holds all the routes that are defined in the app
/// Used to generate the Router object
final class AppRouter extends RootStackRouter {
//
  @override
  List<AutoRoute> get routes => [
        // TODO: Add routes here
        //TODO: When i need to implement auth, check out everything on guards in auto-route generator.
        AutoRoute(
          initial: true,
          path: '/home',
          page: HomeRoute.page,
          children: [
            AutoRoute(
              path: '',
              page: DashboardRoute.page,
              guards: [AuthGuard()],
            ),
            AutoRoute(
              path: 'room-details',
              page: RoomDetailsPage.page,
              guards: [
                PaymentGuard(),
              ],
            ),
            // AutoRoute(path: 'book-hostel',page: BookHostelPage.page,guards: [PaymentGuard(), ]),
            AutoRoute(
              path: 'book-hostel',
              page: RoomAllocationRoute.page,

              //TODO - add the checkifuserhasroomguard back
              guards: [
                PaymentGuard(),
              ],
            ),
            AutoRoute(
              path: 'maintenance-requests',
              page: MaintenancePage.page,
              guards: [PaymentGuard()],
            ),
            AutoRoute(page: PaymentPage.page),
            AutoRoute(
              path: 'complaint',
              page: ComplaintSubmissionPage.page,
            ),
          ],
          guards: [
            AuthGuard(),
            // PaymentGuard()
          ],
        ),
        AutoRoute(
          page: SignUpPage.page,
        ),
        AutoRoute(
          page: StaffSignInPage.page,
        ),
        AutoRoute(page: AdminDashboardScreen.page),
        AutoRoute(page: ChooseRolePage.page),
        AutoRoute(page: SignInPage.page),
        AutoRoute(page: AdminMaintenancePage.page),
      ];
}
