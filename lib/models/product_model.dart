class ProductModel {
  final String id;
  final String title;
  final double pricePerPiece;
  final String category;
  final List<String> imageUrls;
  final int pcs;
  final String brand;
  final String fabric;
  final String description;

  ProductModel({
    required this.id,
    required this.title,
    required this.pricePerPiece,
    required this.category,
    required this.imageUrls,
    required this.pcs,
    required this.brand,
    required this.fabric,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      pricePerPiece: (json['pricePerPiece'] as num).toDouble(),
      category: json['category'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      pcs: json['pcs'] as int,
      brand: json['brand'] as String? ?? '',
      fabric: json['fabric'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'pricePerPiece': pricePerPiece,
      'category': category,
      'imageUrls': imageUrls,
      'pcs': pcs,
      'brand': brand,
      'fabric': fabric,
      'description': description,
    };
  }

  double get totalPrice => pricePerPiece * pcs;

  ProductModel copyWith({
    String? id,
    String? title,
    double? pricePerPiece,
    String? category,
    List<String>? imageUrls,
    int? pcs,
    String? brand,
    String? fabric,
    String? description,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      pricePerPiece: pricePerPiece ?? this.pricePerPiece,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      pcs: pcs ?? this.pcs,
      brand: brand ?? this.brand,
      fabric: fabric ?? this.fabric,
      description: description ?? this.description,
    );
  }
} 