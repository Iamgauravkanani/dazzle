import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../routes/app_pages.dart';
import '../utils/shared_prefs_helper.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<UserModel?> currentUserModel = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;

    // Initialize auth state listener
    _auth.authStateChanges().listen((User? user) async {
      currentUser.value = user;
      if (user != null) {
        // await _loadUserData(user.uid);
        // _navigateToHome();
      } else {
        currentUserModel.value = null;
        await SharedPrefsHelper.clearUserData();
        // _navigateToSignIn();
      }
    });

    // Check if user is already logged in
    if (_auth.currentUser != null) {
      // await _loadUserData(_auth.currentUser!.uid);
      _navigateToHome();
    }

    isLoading.value = false;
  }

  void _navigateToHome() {
    if (Get.currentRoute != Routes.HOME) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void _navigateToSignIn() {
    if (Get.currentRoute != Routes.SIGNIN) {
      Get.offAllNamed(Routes.SIGNIN);
    }
  }

  /*  Future<void> _loadUserData(String uid) async {
    try {
      log('Loading user data for UID: $uid');
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        currentUserModel.value = UserModel.fromJson({'uid': uid, ...doc.data() as Map<String, dynamic>});
        log('User data loaded: ${currentUserModel.value!.email}');

        await SharedPrefsHelper.saveUserData(
          uid: uid,
          email: currentUserModel.value!.email,
          firstName: currentUserModel.value!.firstName,
          businessName: currentUserModel.value!.businessName,
          city: currentUserModel.value!.city,
          state: currentUserModel.value!.state,
          businessType: currentUserModel.value!.businessType,
          authToken: await currentUser.value!.getIdToken(),
        );
      } else {
        log('No user data found for UID: $uid');
        errorMessage.value = 'User data not found';
      }
    } catch (e, stackTrace) {
      log('Error loading user data: $e\n$stackTrace');
      errorMessage.value = 'Failed to load user data';
    }
  }*/

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String businessName,
    required String city,
    required String state,
    required String businessType,
  }) async {
    Map<String, dynamic> res = {};
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create user in Firebase Auth
      log('Creating user with email: ${email.trim()}');
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      log('User created: ${userCredential.user!.uid}');

      // Create user document in Firestore
      final userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email.trim(),
        firstName: firstName,
        businessName: businessName,
        city: city,
        state: state,
        businessType: businessType,
      );

      // Save to Firestore using UID
      log('Writing to Firestore: users/${userCredential.user!.uid}');
      log('UserModel JSON: ${userModel.toJson()}');
      await _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toJson());
      log('Firestore write completed');

      // Update local state
      currentUserModel.value = userModel;

      // Save to SharedPreferences
      await SharedPrefsHelper.saveUserData(
        uid: userCredential.user!.uid,
        email: email.trim(),
        firstName: firstName,
        businessName: businessName,
        city: city,
        state: state,
        businessType: businessType,
        authToken: await userCredential.user!.getIdToken(),
      );

      res['user'] = userCredential.user;
      errorMessage.value = 'User registered successfully!';
      log('User registered successfully: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      res['error'] = _getAuthErrorMessage(e);
      errorMessage.value = res['error'];
      log('Firebase Auth Error: ${e.code} - ${e.message}');
    } on FirebaseException catch (e) {
      res['error'] = 'Firestore error: ${e.message}';
      errorMessage.value = res['error'];
      log('Firestore Error: ${e.code} - ${e.message}');
    } catch (e, stackTrace) {
      res['error'] = 'Unexpected error: $e';
      errorMessage.value = res['error'];
      log('Unexpected Error: $e\n$stackTrace');
    } finally {
      isLoading.value = false;
    }
    return res;
  }

  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      isLoading.value = true;
      errorMessage.value = '';

      log('Signing in with email: ${email.trim()}');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      log('User signed in: ${userCredential.user!.uid}');

      // await _loadUserData(userCredential.user!.uid);
      res['user'] = userCredential.user;
      log('User signed in successfully: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      res['error'] = _getAuthErrorMessage(e);
      errorMessage.value = res['error'];
      log('Firebase Auth Error: ${e.code} - ${e.message}');
    } catch (e, stackTrace) {
      res['error'] = 'Unexpected error: $e';
      errorMessage.value = res['error'];
      log('Unexpected Error: $e\n$stackTrace');
    } finally {
      isLoading.value = false;
    }
    return res;
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      currentUserModel.value = null;
      await SharedPrefsHelper.clearUserData();
      log('User signed out successfully');
    } catch (e, stackTrace) {
      errorMessage.value = 'Failed to sign out. Please try again.';
      log('Sign out error: $e\n$stackTrace');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _auth.sendPasswordResetEmail(email: email.trim());
      log('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e);
      log('Reset password error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      log('Unexpected error: $e\n$stackTrace');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? businessName,
    String? city,
    String? state,
    String? businessType,
  }) async {
    try {
      if (currentUser.value == null) return;

      isLoading.value = true;
      errorMessage.value = '';

      final updates = <String, dynamic>{};
      if (firstName != null) updates['firstName'] = firstName;
      if (businessName != null) updates['businessName'] = businessName;
      if (city != null) updates['city'] = city;
      if (state != null) updates['state'] = state;
      if (businessType != null) updates['businessType'] = businessType;

      log('Updating profile for UID: ${currentUser.value!.uid}');
      await _firestore.collection('users').doc(currentUser.value!.uid).update(updates);
      log('Profile updated successfully');

      // await _loadUserData(currentUser.value!.uid);
    } catch (e, stackTrace) {
      errorMessage.value = 'Failed to update profile. Please try again.';
      log('Update profile error: $e\n$stackTrace');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Invalid password. Please try again.';
      case 'email-already-in-use':
        return 'This email address is already registered.';
      case 'weak-password':
        return 'The password is too weak (min 6 characters).';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'An authentication error occurred: ${e.message}';
    }
  }
}
