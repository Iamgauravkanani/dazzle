import 'package:dazzle_app/models/product_model.dart';
import 'package:get/get.dart';

/// A simple data class to hold a Product and its current quantity in the cart.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

/// Manages the state of the shopping cart throughout the application.
///
/// This controller handles adding, removing, and updating product quantities
/// based on their Minimum Order Quantity (MOQ).
class CartController extends GetxController {
  // The core of our state: A reactive map of cart items.
  // The key is the product ID (String) for quick lookups,
  // and the value is the CartItem object.
  // Using .obs makes this map reactive, so UI widgets will update automatically.
  final _items = <String, CartItem>{}.obs;

  // Public getter to allow UI components to read the list of cart items.
  Map<String, CartItem> get items => _items;

  // Public getter for the total cart amount.
  // This is a computed property that automatically recalculates whenever '_items' changes.
  // It iterates through all items and sums up their (price * quantity).
  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

  /// Checks if a product with the given ID is already in the cart.
  /// Returns true if the product exists, false otherwise.
  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  /// Adds a product to the cart.
  ///
  /// If the product is already in the cart, it shows a message and does nothing.
  /// Otherwise, it adds the product with an initial quantity equal to its MOQ.
  void addToCart(Product product) {
    if (isInCart(product.id)) {
      Get.snackbar('Already Added', '${product.name} is already in your cart.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Safely parse the MOQ string.
    // 'tryParse' avoids errors if the string is not a valid number.
    // The '?? 1' provides a fallback to a default MOQ of 1 if the string is null, empty, or invalid.
    final int moq = int.tryParse(product.MOQ ?? '') ?? 1;

    if (moq > 0) {
      // Add the new item to our reactive map.
      _items[product.id] = CartItem(product: product, quantity: moq);
      Get.snackbar('Added to Cart', '${product.name} (Qty: $moq) was added.', snackPosition: SnackPosition.BOTTOM);
    } else {
      // Handle cases where MOQ might be '0' or an invalid string.
      Get.snackbar('Error', 'Product has an invalid Minimum Order Quantity.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Removes a product completely from the cart using its ID.
  void removeFromCart(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      Get.snackbar('Removed', 'Product removed from your cart.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Increases the quantity of a cart item by its MOQ.
  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;
      final int moq = int.tryParse(item.product.MOQ ?? '') ?? 1;

      item.quantity += moq;

      // IMPORTANT: When changing a property of an object inside a reactive list/map,
      // you must call .refresh() to notify GetX widgets to rebuild.
      _items.refresh();
    }
  }

  /// Decreases the quantity of a cart item by its MOQ.
  ///
  /// This method prevents the quantity from dropping below the initial MOQ.
  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;
      final int moq = int.tryParse(item.product.MOQ ?? '') ?? 1;

      // The business logic: only decrease if the new quantity is still
      // greater than or equal to the base MOQ.
      if ((item.quantity - moq) >= moq) {
        item.quantity -= moq;
        _items.refresh(); // Notify UI to update.
      } else {
        Get.snackbar(
          'Limit Reached',
          'Quantity cannot be less than the Minimum Order Quantity ($moq).',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  /// Clears all items from the cart, resetting it to an empty state.
  void clearCart() {
    _items.clear();
  }
}
