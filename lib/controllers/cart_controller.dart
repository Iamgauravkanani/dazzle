import 'package:get/get.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  final _items = <String, CartItem>{}.obs;
  final _total = 0.0.obs;

  Map<String, CartItem> get items => _items;
  double get total => _total.value;

  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: 1,
      );
    }
    _calculateTotal();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    _calculateTotal();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity > 0) {
        _items[productId]!.quantity = quantity;
      } else {
        _items.remove(productId);
      }
      _calculateTotal();
    }
  }

  void clearCart() {
    _items.clear();
    _calculateTotal();
  }

  void _calculateTotal() {
    _total.value = _items.values.fold(
      0.0,
      (sum, item) => sum + (item.product.totalPrice * item.quantity),
    );
  }
}

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
} 