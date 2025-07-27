import 'package:dazzle_app/controllers/checkout_controller.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressEditScreen extends StatelessWidget {
  const AddressEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.find<CheckoutController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Address', style: GoogleFonts.poppins(fontSize: 20)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 1,
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  TextField(
                    controller: checkoutController.nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: checkoutController.phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: checkoutController.addressLine1Controller,
                    decoration: InputDecoration(
                      labelText: 'Address Line 1',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: checkoutController.addressLine2Controller,
                    decoration: InputDecoration(
                      labelText: 'Address Line 2 (Optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: checkoutController.cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: checkoutController.stateController,
                    decoration: InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: checkoutController.postalCodeController,
                    decoration: InputDecoration(
                      labelText: 'Postal Code',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: checkoutController.gstController,
                    decoration: InputDecoration(
                      labelText: 'GST Number (Optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      errorText: checkoutController.gstError.value.isEmpty ? null : checkoutController.gstError.value,
                    ),
                    onChanged: (value) => checkoutController.validateGST(value),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          checkoutController.isLoading.value || checkoutController.gstError.value.isNotEmpty
                              ? null
                              : checkoutController.saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text('Save Address', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                    ),
                  ),
                ],
              ),
            ),
            if (checkoutController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CupertinoActivityIndicator(radius: 20)),
              ),
          ],
        ),
      ),
    );
  }
}
