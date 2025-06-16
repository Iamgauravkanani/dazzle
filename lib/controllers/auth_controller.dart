import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<UserModel?> currentUserModel = Rx<UserModel?>(null);
  final RxBool isLoading = RxBool(false);
  final RxString errorMessage = RxString('');

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final businessTypeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _bindAuthState();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    businessNameController.dispose();
    cityController.dispose();
    stateController.dispose();
    businessTypeController.dispose();
    super.onClose();
  }

  void _bindAuthState() {
    ever(_authService.currentUserModel, (UserModel? user) {
      currentUserModel.value = user;
    });
    ever(_authService.isLoading, (bool loading) {
      isLoading.value = loading;
    });
    ever(_authService.errorMessage, (String message) {
      errorMessage.value = message;
    });
  }

  Future<void> signUp() async {
    if (!_validateSignUpForm()) return;
    
    try {
      await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        firstName: firstNameController.text.trim(),
        businessName: businessNameController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        businessType: businessTypeController.text.trim(),
      );
      
      // Clear form after successful signup
      clearSignUpForm();
    } catch (e) {
      // Error is already handled by AuthService
      rethrow;
    }
  }

  Future<void> signIn() async {
    if (!_validateSignInForm()) return;
    
    try {
      await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      // Clear form after successful signin
      clearSignInForm();
    } catch (e) {
      // Error is already handled by AuthService
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your email address';
      return;
    }
    
    try {
      await _authService.resetPassword(emailController.text.trim());
      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }

  bool _validateSignUpForm() {
    if (firstNameController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your first name';
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }
    if (passwordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }
    if (businessNameController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your business name';
      return false;
    }
    if (cityController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your city';
      return false;
    }
    if (stateController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your state';
      return false;
    }
    if (businessTypeController.text.trim().isEmpty) {
      errorMessage.value = 'Please select your business type';
      return false;
    }
    return true;
  }

  bool _validateSignInForm() {
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }
    return true;
  }

  void clearSignUpForm() {
    firstNameController.clear();
    emailController.clear();
    passwordController.clear();
    businessNameController.clear();
    cityController.clear();
    stateController.clear();
    businessTypeController.clear();
    errorMessage.value = '';
  }

  void clearSignInForm() {
    emailController.clear();
    passwordController.clear();
    errorMessage.value = '';
  }
}