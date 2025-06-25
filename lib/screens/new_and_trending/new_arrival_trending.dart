import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzle_app/controllers/home_controller.dart';
import 'package:dazzle_app/models/product_model.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../product_detail/product_detail_screen.dart';

class TrendingAndArrivalScreen extends StatefulWidget {
  final String filterType; // "New Arrival" or "Trending Now"

  const TrendingAndArrivalScreen({super.key, required this.filterType});

  @override
  State<TrendingAndArrivalScreen> createState() => _TrendingAndArrivalScreenState();
}

class _TrendingAndArrivalScreenState extends State<TrendingAndArrivalScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load products based on filter type
    _loadFilteredProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_scrollController.position.outOfRange &&
        !homeController.isLoadingMore.value) {
      _loadMoreFilteredProducts();
    }
  }

  void _loadFilteredProducts() async {
    homeController.products.clear();
    homeController.lastDocument.value = null;
    homeController.hasMore.value = true;
    await homeController.loadProducts(isInitialLoad: true);
  }

  void _loadMoreFilteredProducts() async {
    if (!homeController.isLoadingMore.value && homeController.hasMore.value) {
      await homeController.loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filterType, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        final filteredProducts =
            homeController.products.where((product) {
              if (widget.filterType == "New Arrival") return product.isNewArrival;
              if (widget.filterType == "Trending Now") return product.isNewTrending;
              return false; // Default case (should not happen)
            }).toList();

        if (homeController.isLoadingProducts.value) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 350.h,
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
              ),
              itemCount: 6,
              itemBuilder:
                  (context, index) => Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                  ),
            ),
          );
        }

        if (filteredProducts.isEmpty) {
          return Container(
            height: 200.h,
            child: Center(
              child: Text(
                'No ${widget.filterType.toLowerCase()} products found',
                style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              ),
            ),
          );
        }

        return GridView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 350.h,
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return _buildProductCard(filteredProducts[index]);
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        if (homeController.isLoadingMore.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap:
          !product.inStock
              ? null
              : () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
              },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2)),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    child: CachedNetworkImage(
                      imageUrl: product.photo.isNotEmpty ? product.photo : 'https://via.placeholder.com/300',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            (product.MOQ != null)
                                ? Text(
                                  'MOQ - ${product.MOQ} pcs',
                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                )
                                : Text('MOQ - 0 pcs', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!product.inStock)
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stock Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'This item is currently out of stock. Don\'t miss out! We\'ll notify you as soon as it\'s available again. Stay tuned or check back later!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
