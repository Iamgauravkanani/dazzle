import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final int quantity;
  final double pricePerPiece;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.pricePerPiece,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
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
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String status;
  final double totalAmount;
  final String paymentStatus;
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? '',
      orderDate: (json['orderDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    String? status,
    double? totalAmount,
    String? paymentStatus,
    DateTime? orderDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderDate: orderDate ?? this.orderDate,
    );
  }
} 