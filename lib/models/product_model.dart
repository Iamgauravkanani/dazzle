import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productNumber;
  final String productType;
  final double rating;
  final int reviewCount;
  final int sales;
  final String season;
  final List<dynamic> sizes;
  final List<dynamic> tags;
  final String type;
  final DateTime updatedAt;
  final int views;
  final double weight;
  final String work;
  final List<dynamic> allProductPics;
  final int availableQuantity;
  final String brandName;
  final String category;
  final String clothingType;
  final List<dynamic> colors;
  final DateTime createdAt;
  final String description;
  final String design;
  final String fabric;
  final double fullCatalogPrice;
  final String gender;
  final String id;
  final List<dynamic> imageUrls;
  final bool isActive;
  final String material;
  final String name;
  final String occasion;
  final String photo;
  final String placeOfOrigin;
  final double price;
  final dynamic MOQ; // Added MOQ parameter
  final bool isNewArrival; // Added new parameter
  final bool isNewTrending; // Added new parameter
  final bool inStock; // Added new parameter with default true

  Product({
    required this.productNumber,
    required this.productType,
    required this.rating,
    required this.reviewCount,
    required this.sales,
    required this.season,
    required this.sizes,
    required this.tags,
    required this.type,
    required this.updatedAt,
    required this.views,
    required this.weight,
    required this.work,
    required this.allProductPics,
    required this.availableQuantity,
    required this.brandName,
    required this.category,
    required this.clothingType,
    required this.colors,
    required this.createdAt,
    required this.description,
    required this.design,
    required this.fabric,
    required this.fullCatalogPrice,
    required this.gender,
    required this.id,
    required this.imageUrls,
    required this.isActive,
    required this.material,
    required this.name,
    required this.occasion,
    required this.photo,
    required this.placeOfOrigin,
    required this.price,
    this.MOQ, // Initialize MOQ
    this.isNewArrival = false, // Default to false
    this.isNewTrending = false, // Default to false
    this.inStock = true, // Default to true
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productNumber: map['productNumber'] ?? '',
      productType: map['productType'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: (map['reviewCount'] ?? 0).toInt(),
      sales: (map['sales'] ?? 0).toInt(),
      season: map['season'] ?? '',
      sizes: map['sizes'] ?? [],
      tags: map['tags'] ?? [],
      type: map['type'] ?? '',
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      views: (map['views'] ?? 0).toInt(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      work: map['work'] ?? '',
      allProductPics: map['allProductPics'] ?? [],
      availableQuantity: (map['availableQuantity'] ?? 0).toInt(),
      brandName: map['brandName'] ?? '',
      category: map['category'] ?? '',
      clothingType: map['clothingType'] ?? '',
      colors: map['colors'] ?? [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      description: map['description'] ?? '',
      design: map['design'] ?? '',
      fabric: map['fabric'] ?? '',
      fullCatalogPrice: (map['fullCatalogPrice'] ?? 0.0).toDouble(),
      gender: map['gender'] ?? '',
      id: map['id'] ?? '',
      imageUrls: map['imageUrls'] ?? [],
      isActive: map['isActive'] ?? false,
      material: map['material'] ?? '',
      name: map['name'] ?? '',
      occasion: map['occasion'] ?? '',
      photo: map['photo'] ?? '',
      placeOfOrigin: map['placeOfOrigin'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      MOQ: map['MOQ'], // Assigning MOQ from the map
      isNewArrival: map['isNewArrival'] ?? false, // Assign from map with default false
      isNewTrending: map['isNewTrending'] ?? false, // Assign from map with default false
      inStock: map['inStock'] ?? true, // Assign from map with default true
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productNumber': productNumber,
      'productType': productType,
      'rating': rating,
      'reviewCount': reviewCount,
      'sales': sales,
      'season': season,
      'sizes': sizes,
      'tags': tags,
      'type': type,
      'updatedAt': updatedAt,
      'views': views,
      'weight': weight,
      'work': work,
      'allProductPics': allProductPics,
      'availableQuantity': availableQuantity,
      'brandName': brandName,
      'category': category,
      'clothingType': clothingType,
      'colors': colors,
      'createdAt': createdAt,
      'description': description,
      'design': design,
      'fabric': fabric,
      'fullCatalogPrice': fullCatalogPrice,
      'gender': gender,
      'id': id,
      'imageUrls': imageUrls,
      'isActive': isActive,
      'material': material,
      'name': name,
      'occasion': occasion,
      'photo': photo,
      'placeOfOrigin': placeOfOrigin,
      'price': price,
      'MOQ': MOQ,
      'isNewArrival': isNewArrival,
      'isNewTrending': isNewTrending,
      'inStock': inStock, // Adding to map
    };
  }
}
