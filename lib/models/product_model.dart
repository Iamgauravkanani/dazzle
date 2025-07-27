import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  // All your existing fields...
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
  final dynamic MOQ;
  final bool inStock;

  // ***** KEY VARIABLES *****
  final bool isNewArrival; // Mapped from 'isNA'
  final bool isNewTrending; // Mapped from 'isTN'

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
    this.MOQ,
    required this.inStock,
    required this.isNewArrival,
    required this.isNewTrending,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      // Mapping all your existing fields...
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
      id: map['id'] ?? '', // IMPORTANT: ensure 'id' is in the map from the service
      imageUrls: map['imageUrls'] ?? [],
      isActive: map['isActive'] ?? false,
      material: map['material'] ?? '',
      name: map['name'] ?? '',
      occasion: map['occasion'] ?? '',
      photo: map['photo'] ?? '',
      placeOfOrigin: map['placeOfOrigin'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      MOQ: map['MOQ'],
      inStock: map['inStock'] ?? true,

      // ***** THIS LOGIC IS PERFECT *****
      // It safely handles missing fields by defaulting to false.
      isNewArrival: map['isNA'] ?? false,
      isNewTrending: map['isTN'] ?? false,
    );
  }
}
