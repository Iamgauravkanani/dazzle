import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazzle_app/models/product_model.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class WishlistController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();

  final RxList<Product> items = <Product>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      isLoading.value = true;
      items.clear();

      if (_authService.currentUser.value == null) return;

      final doc = await _firestore.collection('wishlists').doc(_authService.currentUser.value!.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        final wishlist = WishlistModel.fromJson(data); // Assuming WishlistModel is defined
        await _loadWishlistProducts(wishlist.productIds);
      }
    } catch (e) {
      print('Error loading wishlist: $e');
      Get.snackbar('Error', 'Failed to load wishlist. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadWishlistProducts(List<String> productIds) async {
    try {
      for (final id in productIds) {
        final doc = await _firestore.collection('products').doc(id).get();
        if (doc.exists) {
          final data = doc.data()!;
          data['id'] = doc.id; // Ensure ID is included
          items.add(Product.fromMap(data));
        }
      }
    } catch (e) {
      print('Error loading wishlist products: $e');
    }
  }

  bool isInWishlist(String productId) {
    return items.any((product) => product.id == productId);
  }

  Future<void> addToWishlist(String productId) async {
    try {
      if (_authService.currentUser.value == null) return;

      final docRef = _firestore.collection('wishlists').doc(_authService.currentUser.value!.uid);

      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data()!;
        final wishlist = WishlistModel.fromJson(data); // Assuming WishlistModel is defined
        if (!wishlist.containsProduct(productId)) {
          await docRef.update({
            'productIds': FieldValue.arrayUnion([productId]),
          });
          await loadWishlist();
        }
      } else {
        await docRef.set({
          'userId': _authService.currentUser.value!.uid,
          'productIds': [productId],
        });
        await loadWishlist();
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
      Get.snackbar('Error', 'Failed to add to wishlist. Please try again.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      if (_authService.currentUser.value == null) return;

      await _firestore.collection('wishlists').doc(_authService.currentUser.value!.uid).update({
        'productIds': FieldValue.arrayRemove([productId]),
      });

      items.removeWhere((product) => product.id == productId);
    } catch (e) {
      print('Error removing from wishlist: $e');
      Get.snackbar('Error', 'Failed to remove from wishlist. Please try again.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> clearWishlist() async {
    try {
      if (_authService.currentUser.value == null) return;

      await _firestore.collection('wishlists').doc(_authService.currentUser.value!.uid).delete();

      items.clear();
    } catch (e) {
      print('Error clearing wishlist: $e');
      Get.snackbar('Error', 'Failed to clear wishlist. Please try again.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class WishlistModel {
  final String userId;
  final List<String> productIds;

  WishlistModel({required this.userId, required this.productIds});

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(userId: json['userId'] ?? '', productIds: List<String>.from(json['productIds'] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'productIds': productIds};
  }

  bool containsProduct(String productId) {
    return productIds.contains(productId);
  }
}
