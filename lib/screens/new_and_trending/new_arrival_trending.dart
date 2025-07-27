import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzle_app/controllers/home_controller.dart';
import 'package:dazzle_app/models/product_model.dart';
import 'package:dazzle_app/screens/product_detail/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrendingAndArrivalScreen extends StatefulWidget {
  final String filterType;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFilteredProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    // No state changes needed here. The controller will reset itself on the next initial load.
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_scrollController.position.outOfRange) {
      homeController.loadMoreProducts(filterType: widget.filterType);
    }
  }

  void _loadFilteredProducts() {
    // This call correctly resets the state and fetches the new filtered list.
    homeController.loadProducts(isInitialLoad: true, filterType: widget.filterType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filterType, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        // This logic is now safe. It will show a loader on first entry.
        if (homeController.isLoadingProducts.value && homeController.products.isEmpty) {
          return const Center(child: CupertinoActivityIndicator(radius: 18));
        }

        if (homeController.products.isEmpty) {
          return Center(
            child: Text(
              'No products currently in ${widget.filterType}',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
            ),
          );
        }

        return GridView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 350.h,
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: homeController.products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(homeController.products[index]);
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

  // Your _buildProductCard widget remains the same.
  Widget _buildProductCard(Product product) {
    // ...
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
                      placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
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
                            Text(
                              'MOQ - ${product.MOQ ?? 0} pcs',
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                            ),
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
                        style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
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
