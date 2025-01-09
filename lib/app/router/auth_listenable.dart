import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AuthStateNotifier extends ChangeNotifier {
//   AuthStateNotifier(this._supabase) {
//     _supabase.auth.onAuthStateChange.listen((data) {
//       notifyListeners();
//     });
//   }

//   final SupabaseClient _supabase;

//   bool get isAuthenticated => _supabase.auth.currentUser != null;
// }

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void notifyChange() {
    notifyListeners();
  }
}

final authChangesProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});
