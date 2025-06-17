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
        url: 'https://btqryrtjbxcvqhourtty.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ0cXJ5cnRqYnhjdnFob3VydHR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxODY0NzYsImV4cCI6MjA2NTc2MjQ3Nn0.V3kx4a-zrm_ffVHY68AoIo_65NGbRXqmvb3PK6M2i0I',
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
