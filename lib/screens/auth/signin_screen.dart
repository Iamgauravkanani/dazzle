import 'package:dazzle_app/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/theme.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Sign In'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(AppAssets.logoPath, height: 200, width: 200),
            SizedBox(height: 24.h),
            _buildTextField(
              controller: _authController.emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _authController.passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _showResetPasswordDialog(context);
                },
                child: const Text('Forgot Password?'),
              ),
            ),
            SizedBox(height: 24.h),
            Obx(() {
              if (_authController.errorMessage.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text(
                    _authController.errorMessage.value,
                    style: TextStyle(color: AppTheme.dangerColor, fontSize: 14.sp),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              return ElevatedButton(
                onPressed: _authController.isLoading.value ? null : _authController.signIn,
                child:
                    _authController.isLoading.value
                        ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                          ),
                        )
                        : const Text('Sign In'),
              );
            }),
            SizedBox(height: 16.h),
            TextButton(onPressed: () => Get.toNamed('/signup'), child: const Text('Don\'t have an account? Sign Up')),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Reset Password'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _authController.emailController.text = emailController.text;
                _authController.resetPassword();
                Get.back();
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
