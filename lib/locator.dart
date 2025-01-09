import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [Locator] is responsible for locating and registering all the
/// services of the application.
abstract final class Locator {
  /// [GetIt] instance
  @visibleForTesting
  static final instance = GetIt.instance;

  /// Responsible for registering all the dependencies
  static Future<void> locateServices() async {
    instance
        .registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
    // instance
    //   // Clients
    //   ..registerLazySingleton(
    //       () => NetworkClient(dio: instance(), baseUrl: environment.baseUrl))
    //   // Client Dependencies
    //   ..registerFactory(Dio.new);
  }
}
