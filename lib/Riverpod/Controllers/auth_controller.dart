import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:six_pack_30/Core/Network/api_service_provider.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref.watch(apiServiceProvider));
});

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS ? '653562759267-cmoum4066rfseegvvnccjjonm11vdsfq.apps.googleusercontent.com' : null,
  );

  AuthController(this._apiService) : super(const AsyncValue.data(null));

  Future<bool?> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = const AsyncValue.data(null);
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      bool hasCompletedSurvey = false;

      if (user != null) {
        OneSignal.login(user.uid);
        
        final idToken = await user.getIdToken();
        if (idToken != null) {
          final result = await _apiService.syncUserWithBackend(idToken);
          if (result != null) {
            hasCompletedSurvey = result['hasCompletedSurvey'] ?? false;
            state = AsyncValue.data(user);
            return hasCompletedSurvey;
          } else {
            state = AsyncValue.data(user);
            return null; 
          }
        }
      }

      state = AsyncValue.data(user);
      return hasCompletedSurvey;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool?> signInWithApple() async {
    try {
      state = const AsyncValue.loading();
      
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      bool hasCompletedSurvey = false;

      if (user != null) {
        OneSignal.login(user.uid);
        
        final idToken = await user.getIdToken();
        if (idToken != null) {
          final result = await _apiService.syncUserWithBackend(idToken);
          if (result != null) {
            hasCompletedSurvey = result['hasCompletedSurvey'] ?? false;
            state = AsyncValue.data(user);
            return hasCompletedSurvey;
          } else {
            state = AsyncValue.data(user);
            return null; 
          }
        }
      }

      state = AsyncValue.data(user);
      return hasCompletedSurvey;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool?> signInWithFacebook() async {
    try {
      state = const AsyncValue.loading();

      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status != LoginStatus.success) {
        state = const AsyncValue.data(null);
        return null;
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      bool hasCompletedSurvey = false;

      if (user != null) {
        OneSignal.login(user.uid);

        final idToken = await user.getIdToken();
        if (idToken != null) {
          final result = await _apiService.syncUserWithBackend(idToken);
          if (result != null) {
            hasCompletedSurvey = result['hasCompletedSurvey'] ?? false;
            state = AsyncValue.data(user);
            return hasCompletedSurvey;
          } else {
            state = AsyncValue.data(user);
            return null;
          }
        }
      }

      state = AsyncValue.data(user);
      return hasCompletedSurvey;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Map<String, dynamic>> checkInitialStatus() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        return {'isLoggedIn': false, 'hasCompletedSurvey': false};
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return {'isLoggedIn': false, 'hasCompletedSurvey': false};
      }

      OneSignal.login(user.uid);

      final result = await _apiService.syncUserWithBackend(idToken);
      if (result == null) {
        state = AsyncValue.data(user);
        return {'isLoggedIn': true, 'hasCompletedSurvey': null};
      }
      
      final bool hasCompletedSurvey = result['hasCompletedSurvey'] ?? false;

      state = AsyncValue.data(user);
      return {'isLoggedIn': true, 'hasCompletedSurvey': hasCompletedSurvey};
    } catch (e) {
      return {'isLoggedIn': false, 'hasCompletedSurvey': false};
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      OneSignal.logout();
      state = const AsyncValue.data(null);
    } catch (e) {
    }
  }
}
