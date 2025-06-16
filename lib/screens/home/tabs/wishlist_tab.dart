import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/product_model.dart';
import '../../../utils/theme.dart';

class WishlistTab extends StatelessWidget {
   WishlistTab({super.key});

  // Static dummy data
  final List<ProductModel> _dummyWishlistItems = [
    ProductModel(
      id: '1',
      title: 'Premium Cotton T-Shirt',
      description: 'Soft premium quality cotton t-shirt for men',
      pricePerPiece: 599.99,
      pcs: 10,
      imageUrls: [
        'https://m.media-amazon.com/images/I/61-8GlaVz5L._AC_UL1500_.jpg',
      ],
      category: 'Clothing',
      brand: 'Premium Brand',
      fabric: 'Cotton',
    ),
    ProductModel(
      id: '2',
      title: 'Wireless Bluetooth Headphones',
      description: 'Noise cancelling wireless headphones with 30hr battery',
      pricePerPiece: 2499.00,
      pcs: 5,
      imageUrls: [
        'https://m.media-amazon.com/images/I/61ItiLm54FL._AC_SL1500_.jpg',
      ],
      category: 'Electronics',
      brand: 'Premium Brand',
      fabric: 'Cotton',
    ),
    ProductModel(
      id: '3',
      title: 'Stainless Steel Water Bottle',
      description: '1L insulated stainless steel water bottle',
      pricePerPiece: 899.50,
      pcs: 15,
      imageUrls: [
        'https://m.media-amazon.com/images/I/71gGPRRlyTL._AC_SL1500_.jpg',
      ],
      category: 'Clothing',
      brand: 'Premium Brand',
      fabric: 'Cotton',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildWishlistContent();
  }

  Widget _buildWishlistContent() {
    if (_dummyWishlistItems.isEmpty) {
      return _buildEmptyWishlist();
    }
    return _buildWishlistItems();
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64.w,
            color: AppTheme.borderGray,
          ),
          SizedBox(height: 16.h),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add items to your wishlist to save them for later',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItems() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _dummyWishlistItems.length,
      itemBuilder: (context, index) {
        final product = _dummyWishlistItems[index];
        return _buildWishlistItem(product);
      },
    );
  }

  Widget _buildWishlistItem(ProductModel product) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildProductDetails(product),
            ),
            _buildProductActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: CachedNetworkImage(
        imageUrl: product.imageUrls.first,
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppTheme.borderGray,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppTheme.borderGray,
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildProductDetails(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Text(
          '₹${product.pricePerPiece.toStringAsFixed(2)} per piece',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.accentColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${product.pcs} pcs available',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildProductActions() {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: AppTheme.dangerColor,
          onPressed: () {
            // In a real app, this would remove from wishlist
            Get.snackbar(
              'Removed',
              'Item removed from wishlist',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        SizedBox(height: 8.h),
        ElevatedButton(
          onPressed: () {
            // Navigate to product detail page
            Get.toNamed('/product-detail');
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            minimumSize: Size(80.w, 36.h),
          ),
          child: Text(
            'View',
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}