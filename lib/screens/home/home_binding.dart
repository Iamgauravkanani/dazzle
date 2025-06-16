import 'package:get/get.dart';

import '../orders/order_controller.dart';
import '../products/product_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize HomeController
    Get.put(HomeController());
    
    // Initialize OrderController
    Get.put(OrderController());
    
    // Initialize ProductController
    Get.put(ProductController());
  }
} 