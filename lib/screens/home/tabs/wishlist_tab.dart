import 'package:dazzle_app/controllers/wishlist_controller.dart';
import 'package:dazzle_app/models/product_model.dart';
import 'package:dazzle_app/screens/product_detail/product_detail_screen.dart'; // Import detail screen
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WishlistTab extends StatelessWidget {
  WishlistTab({super.key});

  final WishlistController wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // It's good practice for tabs to be Scaffolds
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(
        () =>
            wishlistController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildWishlistContent(context), // Pass context
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context) {
    if (wishlistController.items.isEmpty) {
      return _buildEmptyWishlist();
    }
    return _buildWishlistItems(context); // Pass context
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64.w, color: AppTheme.borderGray),
          SizedBox(height: 16.h),
          Text('Your wishlist is empty', style: TextStyle(fontSize: 16.sp, color: AppTheme.primaryColor)),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'Tap the heart on any product to save it here.',
              style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItems(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: wishlistController.items.length,
      itemBuilder: (context, index) {
        final product = wishlistController.items[index];
        return _buildWishlistItem(context, product); // Pass context
      },
    );
  }

  Widget _buildWishlistItem(BuildContext context, Product product) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product),
            SizedBox(width: 16.w),
            Expanded(child: _buildProductDetails(product)),
            _buildProductActions(context, product), // Pass context
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: CachedNetworkImage(
        imageUrl:
            product.photo.isNotEmpty
                ? product.photo
                : 'https://imgs.search.brave.com/rwF4fL7C2P06m0zFwJAhGVBwOOjJrWIBjKa8caFDZzc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAwLzc1LzYzLzM3/LzM2MF9GXzc1NjMz/NzI0X0JtWjVuNGpP/TVFBYXR2Q21PTHFR/RHNwTTVPMWY4dU05/LmpwZw',
        width: 100.w,
        height: 100.w,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(color: Colors.grey.shade200),
        errorWidget: (context, url, error) => Container(color: Colors.grey.shade200, child: const Icon(Icons.error)),
      ),
    );
  }

  Widget _buildProductDetails(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Text(
          '₹${product.price.toStringAsFixed(2)} per piece',
          style: TextStyle(fontSize: 14.sp, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.h),
        Text('${product.availableQuantity} pcs available', style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
      ],
    );
  }

  Widget _buildProductActions(BuildContext context, Product product) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red.shade700,
          onPressed: () {
            wishlistController.removeFromWishlist(product.id);
            Get.snackbar('Removed', 'Item removed from wishlist', snackPosition: SnackPosition.BOTTOM);
          },
        ),
        SizedBox(height: 8.h),
        ElevatedButton(
          onPressed: () {
            // --- CORRECTED NAVIGATION ---
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            minimumSize: Size(80.w, 36.h),
          ),
          child: Text('View', style: TextStyle(fontSize: 12.sp)),
        ),
      ],
    );
  }
}
