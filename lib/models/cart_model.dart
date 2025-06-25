import 'package:dazzle_app/models/product_model.dart';
import 'package:get/get.dart';

// The CartItem class holds a product and its quantity in the cart.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartController extends GetxController {
  // Use .obs to make the map of cart items reactive.
  // The key is the product ID (String), and the value is the CartItem object.
  final _items = <String, CartItem>{}.obs;

  // Public getter to allow UI to access the cart items.
  Map<String, CartItem> get items => _items;

  // Public getter for the total cart amount.
  // It automatically recalculates whenever '_items' changes.
  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

  /// Checks if a product with the given ID is already in the cart.
  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  /// Adds a product to the cart.
  /// The initial quantity is set to the product's MOQ.
  void addToCart(Product product) {
    // Prevent adding if the item is already in the cart.
    if (isInCart(product.id)) {
      // Optionally, navigate to the cart or show a more prominent message.
      Get.snackbar('Already Added', '${product.name} is already in your cart.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Safely parse the MOQ string. Default to 1 if it's invalid, null, or empty.
    final int moq = int.tryParse(product.MOQ ?? '') ?? 1;

    if (moq > 0) {
      // Add the new item to the cart.
      _items[product.id] = CartItem(product: product, quantity: moq);
      Get.snackbar('Added to Cart', '${product.name} (Qty: $moq) added.', snackPosition: SnackPosition.BOTTOM);
    } else {
      // Handle cases where MOQ might be '0' or a non-numeric string.
      Get.snackbar('Error', 'Product has an invalid Minimum Order Quantity.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Removes a product completely from the cart using its ID.
  void removeFromCart(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      Get.snackbar('Removed', 'Product removed from cart.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Increases the quantity of a cart item by its MOQ.
  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;
      final int moq = int.tryParse(item.product.MOQ ?? '') ?? 1;

      item.quantity += moq;
      _items.refresh(); // Crucial for updating the UI when a property of an object in a list/map changes.
    }
  }

  /// Decreases the quantity of a cart item by its MOQ.
  /// Prevents the quantity from dropping below the initial MOQ.
  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;
      final int moq = int.tryParse(item.product.MOQ ?? '') ?? 1;

      // Only decrease if the new quantity will be at least the MOQ.
      if ((item.quantity - moq) >= moq) {
        item.quantity -= moq;
        _items.refresh(); // Update the UI
      } else {
        Get.snackbar(
          'Limit Reached',
          'Quantity cannot be less than the Minimum Order Quantity ($moq).',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  /// Clears all items from the cart.
  void clearCart() {
    _items.clear();
  }
}
