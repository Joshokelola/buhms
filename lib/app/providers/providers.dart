import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final getItProvider = Provider<GetIt>((ref) {
  return GetIt.instance;
});

final visibilityProvider = StateProvider<bool>((ref) {
  return true;
});
