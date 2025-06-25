import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzle_app/controllers/cart_controller.dart'; // Import CartController
import 'package:dazzle_app/controllers/wishlist_controller.dart';
import 'package:dazzle_app/models/product_model.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;
  final WishlistController wishlistController = Get.find<WishlistController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final List<String> galleryImages =
        widget.product.allProductPics.isNotEmpty
            ? widget.product.allProductPics.map((e) => e.toString()).toList()
            : [widget.product.photo ?? ''];

    double calculatedTotalCatalogPrice = 0.0;
    final dynamic moqValue = widget.product.MOQ;
    log("MOQ value---->${widget.product.MOQ}");
    log("Product ID---->${widget.product.id}");

    double? moq;
    if (moqValue is String) {
      moq = double.tryParse(moqValue) ?? 1.0;
    } else if (moqValue is num) {
      moq = moqValue.toDouble();
    } else {
      moq = 1.0;
    }

    log("Parsed MOQ---->$moq");

    if (moq != null) {
      calculatedTotalCatalogPrice = widget.product.price * moq;
    } else {
      calculatedTotalCatalogPrice = widget.product.fullCatalogPrice ?? 0.0;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        centerTitle: true,
        actions: [
          Obx(() {
            final bool isFavorite = wishlistController.isInWishlist(widget.product.id);
            return IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
              onPressed: () {
                if (isFavorite) {
                  wishlistController.removeFromWishlist(widget.product.id);
                  Get.snackbar('Removed', 'Removed from your wishlist', snackPosition: SnackPosition.BOTTOM);
                } else {
                  wishlistController.addToWishlist(widget.product.id);
                  Get.snackbar('Added', 'Added to your wishlist', snackPosition: SnackPosition.BOTTOM);
                }
              },
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(context, galleryImages, widget.product.inStock),
            if (galleryImages.length > 1) _buildThumbnailGallery(galleryImages),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text(
                    '₹${widget.product.price.toStringAsFixed(2)} per piece',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.red.shade700),
                  ),
                  SizedBox(height: 24.h),
                  _buildInfoRow('Category', widget.product.category),
                  _buildInfoRow('Brand', widget.product.brandName),
                  _buildInfoRow('Fabric', widget.product.fabric),
                  _buildInfoRow('MOQ', (widget.product.MOQ != null) ? '${widget.product.MOQ} pcs' : '-'),
                  _buildInfoRow('Total Catalog Price', '₹${calculatedTotalCatalogPrice.toStringAsFixed(2)}'),
                  _buildInfoRow('Total Available Qty.', '${widget.product.availableQuantity}'),
                  SizedBox(height: 24.h),
                  Text('Description', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text(
                    widget.product.description,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87, height: 1.5),
                  ),
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
                  Text('Total Catalog Price', style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
                  Text(
                    '₹${calculatedTotalCatalogPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Obx(() {
                final bool isInCart = cartController.isInCart(widget.product.id);
                return ElevatedButton(
                  onPressed:
                      !widget.product.inStock || isInCart
                          ? null
                          : () {
                            cartController.addToCart(widget.product);
                          },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: !widget.product.inStock || isInCart ? Colors.grey : AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    !widget.product.inStock
                        ? 'Stock Out'
                        : isInCart
                        ? 'In Cart'
                        : 'Add to Cart',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context, List<String> imageUrls, bool inStock) {
    if (imageUrls.isEmpty) {
      return Container(height: 450.h, color: Colors.grey[200], child: const Icon(Icons.image_not_supported));
    }
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: imageUrls.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FullScreenImageGallery(imageUrls: imageUrls, initialIndex: index)),
                );
              },
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder:
                    (context, url) =>
                        Container(color: Colors.grey[200], child: const Center(child: CupertinoActivityIndicator())),
                errorWidget:
                    (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.error)),
              ),
            );
          },
          options: CarouselOptions(
            height: 490.h,
            viewportFraction: 1.0,
            enableInfiniteScroll: imageUrls.length > 1,
            autoPlay: imageUrls.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        if (!inStock)
          Container(
            height: 490.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Center(
              child: Text(
                'Stock Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildThumbnailGallery(List<String> imageUrls) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      color: Colors.grey.shade100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          bool isSelected = _currentIndex == index;
          return GestureDetector(
            onTap: () {
              _carouselController.animateToPage(index);
            },
            child: Container(
              width: 70.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: 2.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[300]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black54)),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// FullScreenImageGallery remains unchanged
class FullScreenImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageGallery({super.key, required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(imageUrls[index]),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, event) => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
      ),
    );
  }
}
