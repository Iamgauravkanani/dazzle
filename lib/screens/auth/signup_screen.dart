import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/theme.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController _authController = Get.put(AuthController());

  final List<String> _businessTypes = ['Retail', 'Wholesaler'];
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24.h),
            _buildTextField(
              controller: _authController.firstNameController,
              label: 'First Name',
              icon: Icons.person,
            ),
            SizedBox(height: 16.h),
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
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _authController.businessNameController,
              label: 'Business Name',
              icon: Icons.business,
            ),
            SizedBox(height: 16.h),
            _buildDropdownField(
              controller: _authController.stateController,
              label: 'State',
              icon: Icons.location_city,
              items: _states,
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _authController.cityController,
              label: 'City',
              icon: Icons.location_on,
            ),
            SizedBox(height: 16.h),
            _buildDropdownField(
              controller: _authController.businessTypeController,
              label: 'Business Type',
              icon: Icons.store,
              items: _businessTypes,
            ),
            SizedBox(height: 24.h),
            Obx(() {
              if (_authController.errorMessage.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text(
                    _authController.errorMessage.value,
                    style: TextStyle(
                      color: AppTheme.dangerColor,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              return ElevatedButton(
                onPressed: _authController.isLoading.value ? null : _authController.signUp,
                child: _authController.isLoading.value
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                        ),
                      )
                    : const Text('Sign Up'),
              );
            }),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Already have an account? Sign In'),
            ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.text = newValue;
        }
      },
    );
  }
} 