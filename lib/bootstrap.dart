import 'dart:async';

import 'package:buhms/core/utils/device_info/device_info_utils.dart';
import 'package:buhms/core/utils/logger/logger_utils.dart';
import 'package:buhms/core/utils/package_info/package_info_utils.dart';
import 'package:buhms/locator.dart' as locator;
import 'package:buhms/screensizegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap({
  required FutureOr<Widget> Function() builder,
}) async {
  FlutterError.onError = (details) {
    LoggerUtils.instance
        .logFatalError(details.exceptionAsString(), details.stack);
  };
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Initialize Locator and Utils
      await Supabase.initialize(
        url: 'https://wjoetioiltmhdblvchgz.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indqb2V0aW9pbHRtaGRibHZjaGd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg4NTg1NTcsImV4cCI6MjA0NDQzNDU1N30.9ZHWI5xEalbkYfm0OhOrUmNhG-R_5nvKkFHoDI6tL5I',
      );
      await Future.wait([
        locator.Locator.locateServices(),
        PackageInfoUtils.init(),
        DeviceInfoUtils.init(),
      ]);

      runApp(ProviderScope(child: ScreenSizeGate(child: await builder())));
    },
    (error, stackTrace) {
      LoggerUtils.instance.logFatalError(error.toString(), stackTrace);
    },
  );
}
