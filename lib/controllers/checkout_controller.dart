import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazzle_app/screens/checkout/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import 'dart:developer'; // For logging

class CheckoutController extends GetxController {
  final RxMap<String, dynamic> address = <String, dynamic>{}.obs;
  final RxString gstError = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddress();
  }

  void validateGST(String value) {
    if (value.isEmpty) {
      gstError.value = '';
      return;
    }
    // Indian GST format: 2 digits (state code), 10 alphanumeric (PAN), 1 digit (entity code), 1 alphabet (Z), 1 digit (checksum)
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z0-9]{10}[0-9]{1}[A-Z]{1}[0-9]{1}$');
    if (!gstRegex.hasMatch(value)) {
      gstError.value = 'Invalid GST Number. Must be 15 characters (e.g., 22ABCDE1234F1Z5)';
    } else {
      gstError.value = '';
    }
  }

  Future<void> fetchAddress() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('checkout_address').doc(user.uid).get();
        if (doc.exists) {
          address.value = doc.data()!;
          nameController.text = address['name'] ?? '';
          phoneController.text = address['phone'] ?? '';
          addressLine1Controller.text = address['addressLine1'] ?? '';
          addressLine2Controller.text = address['addressLine2'] ?? '';
          cityController.text = address['city'] ?? '';
          stateController.text = address['state'] ?? '';
          postalCodeController.text = address['postalCode'] ?? '';
          gstController.text = address['gstNumber'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch address: $e');
      log('Error fetching address: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAddress() async {
    try {
      if (gstController.text.isNotEmpty && gstError.value.isNotEmpty) {
        Get.snackbar('Error', 'Please enter a valid GST Number or leave it empty');
        return;
      }
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final addressData = {
          'name': nameController.text,
          'phone': phoneController.text,
          'addressLine1': addressLine1Controller.text,
          'addressLine2': addressLine2Controller.text,
          'city': cityController.text,
          'state': stateController.text,
          'postalCode': postalCodeController.text,
          'gstNumber': gstController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance.collection('checkout_address').doc(user.uid).set(addressData);

        address.value = addressData;
        Get.back();
        Get.snackbar('Success', 'Address saved successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save address: $e');
      log('Error saving address: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> placeOrder(CartController cartController) async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Generate unique order ID
        final orderId = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}';
        log('Generated orderId: $orderId'); // Log orderId

        // Calculate total weight in grams and convert to kg for delivery charge
        final totalWeight = cartController.items.values.fold<double>(
          0.0,
          (sum, item) => sum + (item.quantity * (item.product.weight ?? 0.0)),
        );
        final deliveryCharge = (totalWeight / 1000.0) * 50.0; // ₹50 per kg
        final subtotal = cartController.totalAmount;
        final gst = subtotal * 0.05; // 5% GST
        final totalAmount = subtotal + gst + deliveryCharge;

        final orderData = {
          'userId': user.uid,
          'orderId': orderId, // Store orderId for reference
          'items':
              cartController.items.values
                  .map(
                    (item) => {
                      'productId': item.product.id,
                      'productNumber': item.product.productNumber ?? 'unknown', // Include productNumber, handle null
                      'name': item.product.name,
                      'photo': item.product.photo,
                      'price': item.product.price,
                      'quantity': item.quantity,
                      'moq': item.product.MOQ,
                      'weight': item.product.weight ?? 0.0, // Weight in grams
                    },
                  )
                  .toList(),
          'subtotal': subtotal,
          'deliveryCharge': deliveryCharge,
          'gst': gst,
          'totalAmount': totalAmount,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'pending',
        };

        log('orderData: $orderData'); // Log orderData for debugging

        // Store user data in received_orders/<user_uid>
        final userData = {
          'logged_username': user.displayName ?? 'Unknown', // From FirebaseAuth
          'logged_email': user.email ?? 'Unknown', // From FirebaseAuth
          'uid': user.uid, // From FirebaseAuth
          'logged_phoneNumber': user.phoneNumber ?? address['phone'] ?? 'Unknown', // Prefer FirebaseAuth phoneNumber
          'name': address['name'] ?? '',
          'phone': address['phone'] ?? '',
          'addressLine1': address['addressLine1'] ?? '',
          'addressLine2': address['addressLine2'] ?? '',
          'city': address['city'] ?? '',
          'state': address['state'] ?? '',
          'postalCode': address['postalCode'] ?? '',
          'gstNumber': address['gstNumber'] ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance.collection('received_orders').doc(user.uid).set({
          'userData': userData,
        }, SetOptions(merge: true));

        // Store order in received_orders/<user_uid>/orders/<order_id>
        await FirebaseFirestore.instance
            .collection('received_orders')
            .doc(user.uid)
            .collection('orders')
            .doc(orderId)
            .set(orderData);

        Get.to(() => PaymentScreen(orderData: orderData));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
      log('Error placing order: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
