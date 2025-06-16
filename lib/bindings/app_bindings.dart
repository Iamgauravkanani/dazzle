import 'package:dazzle_app/controllers/cart_controller.dart';
import 'package:dazzle_app/controllers/wishlist_controller.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/splash_controller.dart';
import '../services/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize services first
    // Get.putAsync(() => AuthService().init());
    
    // Initialize controllers with proper order
    Get.put(SplashController(), permanent: true); // Make splash controller permanent
    Get.put(AuthController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
  }
} 