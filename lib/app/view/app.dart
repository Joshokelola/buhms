import 'package:buhms/app/constants/string_constants.dart';
import 'package:buhms/app/l10n/l10n.dart';
import 'package:buhms/app/router/app_router.dart';
import 'package:buhms/app/router/auth_listenable.dart';
import 'package:buhms/app/router/custom_route_observer.dart';
import 'package:buhms/app/theme/dark/dark_theme.dart';
import 'package:buhms/app/theme/light/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;
final supabase = getIt<SupabaseClient>();

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  final authStateNotifier = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // App Name
      title: StringConstants.appName,

      // Theme
      theme: LightTheme().theme,

      //TODO: Ceate theme mode switch.
      themeMode: ThemeMode.light,
      darkTheme: DarkTheme().theme,

      // Localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Routing
      routerConfig: _appRouter.config(
        navigatorObservers: () => [CustomRouteObserver()],
        // reevaluateListenable: authStateNotifier,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
