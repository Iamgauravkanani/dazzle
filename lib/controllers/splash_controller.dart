import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazzle_app/screens/home/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../utils/shared_prefs_helper.dart';
import '../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = true.obs;
  final RxBool isInitialized = false.obs;
  bool _hasNavigated = false;
  final RxBool showTagline = true.obs;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() async {
    super.onInit();
    debugPrint('SplashController initialized');
    // await testFirestoreWrite();
    _initializeApp();
  }

  Future<void> testFirestoreWrite() async {
    try {
      await _firestore.collection('test').doc('testDoc').set({
        'testField': 'testValue',
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('Test write successful');
    } catch (e) {
      debugPrint('Test write failed: $e');
    }
  }

  Future<void> _initializeApp() async {
    if (_hasNavigated) {
      debugPrint('Already navigated, skipping initialization');
      return;
    }

    try {
      debugPrint('Starting app initialization');
      // Add a small delay to show splash screen
      await Future.delayed(const Duration(seconds: 4));
      showTagline.value = true;
      // Check authentication state
      await _checkAuthState();
    } catch (e) {
      debugPrint('Error initializing app: $e');
      if (!_hasNavigated) {
        _navigateToSignIn();
      }
    } finally {
      isLoading.value = false;
      isInitialized.value = true;
    }
  }

  Future<void> _checkAuthState() async {
    if (_hasNavigated) {
      debugPrint('Already navigated, skipping auth check');
      return;
    }

    try {
      debugPrint('Checking authentication state');
      // First check SharedPreferences
      final isLoggedIn = await SharedPrefsHelper.isLoggedIn();
      debugPrint('SharedPreferences isLoggedIn: $isLoggedIn');

      if (isLoggedIn) {
        // Verify the session is still valid
        final userData = await SharedPrefsHelper.getUserData();
        debugPrint('User data from SharedPreferences: ${userData != null}');

        if (userData != null) {
          _navigateToHome();
          return;
        }
      }

      // If SharedPreferences check fails, verify with Firebase
      final currentUser = _authService.currentUser.value;
      debugPrint('Firebase currentUser: ${currentUser != null}');

      if (currentUser != null) {
        _navigateToHome();
      } else {
        _navigateToSignIn();
      }
    } catch (e) {
      debugPrint('Error checking auth state: $e');
      if (!_hasNavigated) {
        _navigateToSignIn();
      }
    }
  }

  void _navigateToHome() {
    if (_hasNavigated) {
      debugPrint('Already navigated, skipping home navigation');
      return;
    }

    debugPrint('Navigating to home');
    _hasNavigated = true;

    // Use Get.offAllNamed with predicate to clear the stack
    // Get.offAllNamed(
    //   Routes.HOME,
    //   predicate: (route) => false,
    //   arguments: {'fromSplash': true},
    // );
    Get.to(() => HomeScreen());
  }

  void _navigateToSignIn() {
    if (_hasNavigated) {
      debugPrint('Already navigated, skipping sign in navigation');
      return;
    }

    debugPrint('Navigating to sign in');
    _hasNavigated = true;

    // Use Get.offAllNamed with predicate to clear the stack
    Get.offAllNamed(Routes.SIGNIN, predicate: (route) => false, arguments: {'fromSplash': true});
  }

  @override
  void onClose() {
    debugPrint('SplashController closed');
    super.onClose();
  }
}
