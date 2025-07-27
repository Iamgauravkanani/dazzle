import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dazzle_app/controllers/cart_controller.dart';
import 'package:dazzle_app/controllers/checkout_controller.dart';
import 'package:dazzle_app/screens/home/home_screen.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:developer'; // For logging

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const PaymentScreen({super.key, required this.orderData});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Remove event listeners
    super.dispose();
  }

  void _openRazorpayCheckout() {
    final user = FirebaseAuth.instance.currentUser;
    final totalAmount = widget.orderData['totalAmount'] as double;
    final orderId = widget.orderData['orderId'] as String?;

    if (user == null || orderId == null || orderId.isEmpty) {
      checkoutController.isLoading.value = false;
      Get.snackbar('Error', 'Invalid user or order ID', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final options = {
      'key': 'rzp_live_BIHy33yWhoKBnx',
      'amount': (totalAmount * 100).toInt(),
      'name': 'Dazzles Fashion',
      'description': 'Order Payment for $orderId',
      'prefill': {'contact': checkoutController.address['phone'] ?? '', 'email': user.email ?? ''},
      'external': {
        'wallets': ['paytm'],
      },
      'theme': {'color': '#510B0B'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      checkoutController.isLoading.value = false;
      Get.snackbar('Error', 'Failed to initiate payment: $e', snackPosition: SnackPosition.BOTTOM);
      log('Error initiating Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final orderId = widget.orderData['orderId'] as String?;
      log('Payment Success: ${response.paymentId}, OrderId: $orderId');

      if (user == null) {
        throw Exception('User not authenticated');
      }
      if (orderId == null || orderId.isEmpty) {
        throw Exception('Invalid order ID');
      }

      // Update order status to confirmed
      await FirebaseFirestore.instance
          .collection('received_orders')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .update({'status': 'confirmed'});

      checkoutController.isLoading.value = false;
      cartController.clearCart();
      Get.off(() => HomeScreen());
      Get.snackbar(
        'Success',
        'Payment processed successfully. Payment ID: ${response.paymentId}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      checkoutController.isLoading.value = false;
      Get.snackbar('Error', 'Failed to update order: $e', snackPosition: SnackPosition.BOTTOM);
      log('Error updating order status: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    checkoutController.isLoading.value = false;
    Get.snackbar(
      'Payment Failed',
      'Error: ${response.message}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.dangerColor,
      colorText: Colors.white,
    );
    log('Payment Error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    checkoutController.isLoading.value = false;
    Get.snackbar('External Wallet', 'Selected wallet: ${response.walletName}', snackPosition: SnackPosition.BOTTOM);
    log('External Wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.orderData['items'] as List<dynamic>;
    final subtotal = widget.orderData['subtotal'] as double;
    final deliveryCharge = widget.orderData['deliveryCharge'] as double;
    final gst = widget.orderData['gst'] as double;
    final totalAmount = widget.orderData['totalAmount'] as double;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary', style: GoogleFonts.poppins(fontSize: 20)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section
                  Text('Delivery Address', style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: Container(
                      width: double.maxFinite,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child:
                            checkoutController.address.isEmpty
                                ? Text('No address available', style: GoogleFonts.poppins(fontSize: 14.sp))
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      checkoutController.address['name'] ?? '',
                                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(checkoutController.address['phone'] ?? '', style: TextStyle(fontSize: 14.sp)),
                                    Text(
                                      checkoutController.address['addressLine1'] ?? '',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    if (checkoutController.address['addressLine2'] != null &&
                                        checkoutController.address['addressLine2'].isNotEmpty)
                                      Text(
                                        checkoutController.address['addressLine2'],
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    Text(
                                      '${checkoutController.address['city'] ?? ''}, ${checkoutController.address['state'] ?? ''} ${checkoutController.address['postalCode'] ?? ''}',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Order Details Section
                  Text('Order Details', style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final weight = (item['weight'] as double?) ?? 0.0;
                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: CachedNetworkImage(
                                  imageUrl: item['photo'],
                                  width: 80.w,
                                  height: 150.h,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Container(color: Colors.grey.shade200),
                                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Quantity:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          '${item['quantity']}',
                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Price:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          '₹${item['price'].toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Weight/per Piece:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          '${weight.toStringAsFixed(2)} g',
                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Billing Summary Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal:', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                              Text(
                                '₹${subtotal.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Charge (₹50/kg):',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '₹${deliveryCharge.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('GST (5%):', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                              Text(
                                '₹${gst.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount:', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                              Text(
                                '₹${totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          checkoutController.isLoading.value
                              ? null
                              : () {
                                checkoutController.isLoading.value = true;
                                Get.snackbar('Payment', 'Initiating payment...', snackPosition: SnackPosition.BOTTOM);
                                _openRazorpayCheckout();
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
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
