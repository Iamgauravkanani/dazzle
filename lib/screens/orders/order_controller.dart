import 'package:get/get.dart';

class OrderController extends GetxController {
  final RxList<dynamic> orders = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // TODO: Implement order loading logic
      // For now, using dummy data
      await Future.delayed(const Duration(seconds: 1));
      orders.value = [
        {
          'id': '1',
          'customerName': 'John Doe',
          'total': 299.99,
          'status': 'pending',
          'date': DateTime.now().toString(),
        },
        {
          'id': '2',
          'customerName': 'Jane Smith',
          'total': 199.99,
          'status': 'completed',
          'date': DateTime.now().toString(),
        },
      ];
    } catch (e) {
      errorMessage.value = 'Failed to load orders';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }
} 