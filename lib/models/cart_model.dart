class CartItem {
  final String productId;
  final int quantity;
  final double pricePerPiece;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.pricePerPiece,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      pricePerPiece: (json['pricePerPiece'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'pricePerPiece': pricePerPiece,
    };
  }

  double get totalPrice => pricePerPiece * quantity;

  CartItem copyWith({
    String? productId,
    int? quantity,
    double? pricePerPiece,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      pricePerPiece: pricePerPiece ?? this.pricePerPiece,
    );
  }
}

class CartModel {
  final String userId;
  final List<CartItem> items;

  CartModel({
    required this.userId,
    required this.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  CartModel copyWith({
    String? userId,
    List<CartItem>? items,
  }) {
    return CartModel(
      userId: userId ?? this.userId,
      items: items ?? this.items,
    );
  }
} 