import 'package:dazzle_app/controllers/home_controller.dart';
import 'package:dazzle_app/controllers/order_controller.dart';
import 'package:dazzle_app/screens/products/product_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(OrderController());
    Get.put(ProductController());
  }
}
