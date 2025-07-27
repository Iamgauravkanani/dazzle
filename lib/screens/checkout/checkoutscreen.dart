import 'package:dazzle_app/controllers/cart_controller.dart';
import 'package:dazzle_app/controllers/checkout_controller.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'adressedit_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CheckoutController());
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: GoogleFonts.poppins(fontSize: 20)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 1,
      ),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Address', style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  checkoutController.address.isEmpty
                      ? Text('No address saved', style: GoogleFonts.poppins())
                      : Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                checkoutController.address['name'] ?? '',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(checkoutController.address['phone'] ?? '', style: TextStyle(fontSize: 14.sp)),
                              Text(checkoutController.address['addressLine1'] ?? '', style: TextStyle(fontSize: 14.sp)),
                              if (checkoutController.address['addressLine2'] != null &&
                                  checkoutController.address['addressLine2'].isNotEmpty)
                                Text(checkoutController.address['addressLine2'], style: TextStyle(fontSize: 14.sp)),
                              Text(
                                '${checkoutController.address['city'] ?? ''}, ${checkoutController.address['state'] ?? ''} ${checkoutController.address['postalCode'] ?? ''}',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Get.to(() => const AddressEditScreen()),
                                  child: Text('Edit Address', style: GoogleFonts.poppins()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  SizedBox(height: 16.h),
                  if (checkoutController.address.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            checkoutController.isLoading.value
                                ? null
                                : () => checkoutController.placeOrder(cartController),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            checkoutController.isLoading.value ? null : () => Get.to(() => const AddressEditScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text('Add Address', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
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
