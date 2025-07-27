import 'dart:developer';
import 'package:dazzle_app/screens/orders/orderscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/theme.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    // return Obx(() {
    //   final user = authController.currentUserModel.value;
    //   if (user == null) {
    //     return const Center(child: Text('No user data available'));
    //   }
    final user = FirebaseAuth.instance.currentUser;
    log("UID -->${user?.uid}");
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User data not found'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final firstName = userData['firstName'] ?? 'Unknown';
        final email = userData['email'] ?? 'Unknown';
        final businessName = userData['businessName'] ?? 'Unknown';
        final businessType = userData['businessType'] ?? 'Unknown';
        final city = userData['city'] ?? 'Unknown';
        final state = userData['state'] ?? 'Unknown';

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(firstName, email),
              SizedBox(height: 24.h),
              _buildProfileSection('Personal Information', [
                _buildInfoRow('Name', firstName),
                _buildInfoRow('Email', email),
              ]),
              SizedBox(height: 16.h),
              _buildProfileSection('Business Information', [
                _buildInfoRow('Business Name', businessName),
                _buildInfoRow('Business Type', businessType),
                _buildInfoRow('City', city),
                _buildInfoRow('State', state),
              ]),
              SizedBox(height: 24.h),
              _buildActionButtons(authController),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildProfileHeader(String firstName, String email) {
  return Center(
    child: Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, size: 50.r, color: AppTheme.primaryColor),
        ),
        SizedBox(height: 16.h),
        Text(firstName, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        SizedBox(height: 8.h),
        Text(email, style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])),
      ],
    ),
  );
}

Widget _buildProfileSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
      SizedBox(height: 12.h),
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(children: children),
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
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

Widget _buildActionButtons(AuthController authController) {
  return Column(
    children: [
      // ElevatedButton(
      //   onPressed: () => Get.toNamed('/edit-profile'),
      //   style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48.h)),
      //   child: const Text('Edit Profile'),
      // ),
      // SizedBox(height: 12.h),
      ElevatedButton(
        onPressed: () => Get.to(() => const OrdersScreen()),
        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48.h)),
        child: const Text('View My Orders'),
      ),
      SizedBox(height: 12.h),
      OutlinedButton(
        onPressed: authController.signOut,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 48.h),
          side: BorderSide(color: AppTheme.dangerColor),
        ),
        child: Text('Sign Out', style: TextStyle(color: AppTheme.dangerColor)),
      ),
    ],
  );
}
