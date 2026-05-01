import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, User?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null) {
    _loadCachedUser();
  }

  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> _loadCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(AppConstants.userPrefsKey);
    if (json != null) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      state = User(
        id: map['id'] as String,
        email: map['email'] as String,
        displayName: map['displayName'] as String?,
        photoUrl: map['photoUrl'] as String?,
      );
    }
  }

  Future<void> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return;
      final user = User(
        id: account.id,
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
      );
      state = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userPrefsKey,
        jsonEncode({
          'id': user.id,
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
        }),
      );
    } catch (_) {}
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userPrefsKey);
  }
}
