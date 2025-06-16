import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/user_model.dart';
import '../../../utils/theme.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.currentUserModel.value;
      if (user == null) {
        return const Center(child: Text('No user data available'));
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user),
            SizedBox(height: 24.h),
            _buildProfileSection('Personal Information', [
              _buildInfoRow('Name', user.firstName),
              _buildInfoRow('Email', user.email),
            ]),
            SizedBox(height: 16.h),
            _buildProfileSection('Business Information', [
              _buildInfoRow('Business Name', user.businessName),
              _buildInfoRow('Business Type', user.businessType),
              _buildInfoRow('City', user.city),
              _buildInfoRow('State', user.state),
            ]),
            SizedBox(height: 24.h),
            _buildActionButtons(authController),
          ],
        ),
      );
    });
  }

  Widget _buildProfileHeader(UserModel user) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 50.r,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            user.firstName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AuthController authController) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => Get.toNamed('/edit-profile'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 48.h),
          ),
          child: const Text('Edit Profile'),
        ),
        SizedBox(height: 12.h),
        OutlinedButton(
          onPressed: authController.signOut,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 48.h),
            side: BorderSide(color: AppTheme.dangerColor),
          ),
          child: Text(
            'Sign Out',
            style: TextStyle(color: AppTheme.dangerColor),
          ),
        ),
      ],
    );
  }
}