class WishlistModel {
  final String userId;
  final List<String> productIds;

  WishlistModel({
    required this.userId,
    required this.productIds,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      userId: json['userId'] ?? '',
      productIds: List<String>.from(json['productIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productIds': productIds,
    };
  }

  WishlistModel copyWith({
    String? userId,
    List<String>? productIds,
  }) {
    return WishlistModel(
      userId: userId ?? this.userId,
      productIds: productIds ?? this.productIds,
    );
  }

  bool containsProduct(String productId) {
    return productIds.contains(productId);
  }

  WishlistModel addProduct(String productId) {
    if (!productIds.contains(productId)) {
      return copyWith(
        productIds: [...productIds, productId],
      );
    }
    return this;
  }

  WishlistModel removeProduct(String productId) {
    return copyWith(
      productIds: productIds.where((id) => id != productId).toList(),
    );
  }
} 