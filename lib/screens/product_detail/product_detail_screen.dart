import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static product data
    final product = {
      'id': '1',
      'title': 'Asra Silk Saree - Sanskriti Collection',
      'pricePerPiece': 4599.00,
      'totalPrice': 45999.00,
      'category': 'Sarees',
      'brand': 'Asra Silk',
      'fabric': 'Pure Silk',
      'pcs': 1,
      'description':
          'This exquisite Kanjeevaram silk saree features intricate zari work and traditional motifs. Handwoven by skilled artisans, it comes with a matching blouse piece. Perfect for weddings and special occasions.',
      'imageUrls': [
        'https://firebasestorage.googleapis.com/v0/b/dazzle-fashion-ef4c1.firebasestorage.app/o/Asra%20Silk%20Saree%2Fsanskriti%20V1113%2FV11135_B5.jpg?alt=media&token=e9dfdb8d-3a23-4134-ab42-8a2ed1547e3b',
        'https://firebasestorage.googleapis.com/v0/b/dazzle-fashion-ef4c1.firebasestorage.app/o/Asra%20Silk%20Saree%2Fsanskriti%20V1115%2FV11151_B5.jpg?alt=media&token=74aa4f06-4cef-4427-9f8c-2a3609b910f5',
        'https://firebasestorage.googleapis.com/v0/b/dazzle-fashion-ef4c1.firebasestorage.app/o/Asra%20Silk%20Saree%2Fsanskriti%20V1115%2FV11153_B5.jpg?alt=media&token=f6dc4f56-8f2b-44a1-a2f0-01960bc6bcae',
      ],
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to wishlist')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(product['imageUrls'] as List<String>),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] as String,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppTheme.primaryColor),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '₹${(product['pricePerPiece'] as double).toStringAsFixed(2)} per piece',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow('Category', product['category'] as String),
                  _buildInfoRow('Brand', product['brand'] as String),
                  _buildInfoRow('Fabric', product['fabric'] as String),
                  _buildInfoRow('MOQ Pieces', '${product['pcs']} pcs'),
                  _buildInfoRow('Total', '45999/-'),
                  SizedBox(height: 16.h),
                  Text('Description', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
                  Text(product['description'] as String, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Price', style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
                  Text(
                    '₹${(product['totalPrice'] as double).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added to cart')));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(List<String> imageUrls) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 500.h,
        viewportFraction: 1.0,
        enableInfiniteScroll: imageUrls.length > 1,
        autoPlay: imageUrls.length > 1,
      ),
      items:
          imageUrls.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  placeholder:
                      (context, url) =>
                          Container(color: Colors.grey[200], child: const Center(child: CupertinoActivityIndicator())),
                  errorWidget:
                      (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.error)),
                );
              },
            );
          }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black54)),
          Text(value, style: TextStyle(fontSize: 14.sp, color: Colors.black87, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
