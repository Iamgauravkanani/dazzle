import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/auth_service.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      orders.clear();

      if (_authService.currentUser.value == null) return;

      final QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: _authService.currentUser.value!.uid)
          .orderBy('orderDate', descending: true)
          .get();

      orders.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    } catch (e) {
      print('Error loading orders: $e');
      Get.snackbar(
        'Error',
        'Failed to load orders. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderModel?> getOrderById(String id) async {
    try {
      final doc = await _firestore.collection('orders').doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return OrderModel.fromJson({
          'id': doc.id,
          ...data,
        });
      }
      return null;
    } catch (e) {
      print('Error getting order: $e');
      return null;
    }
  }

  Future<void> createOrder({
    required List<OrderItem> items,
    required double totalAmount,
  }) async {
    try {
      if (_authService.currentUser.value == null) return;

      final order = OrderModel(
        id: '', // Will be set by Firestore
        userId: _authService.currentUser.value!.uid,
        items: items,
        status: 'pending',
        totalAmount: totalAmount,
        paymentStatus: 'pending',
        orderDate: DateTime.now(),
      );

      final docRef = await _firestore.collection('orders').add(order.toJson());
      await loadOrders(); // Reload orders after creating new one
    } catch (e) {
      print('Error creating order: $e');
      Get.snackbar(
        'Error',
        'Failed to create order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
      await loadOrders(); // Reload orders after updating status
    } catch (e) {
      print('Error updating order status: $e');
      Get.snackbar(
        'Error',
        'Failed to update order status. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updatePaymentStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'paymentStatus': status,
      });
      await loadOrders(); // Reload orders after updating payment status
    } catch (e) {
      print('Error updating payment status: $e');
      Get.snackbar(
        'Error',
        'Failed to update payment status. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 