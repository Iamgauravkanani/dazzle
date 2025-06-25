import 'package:dazzle_app/controllers/home_controller.dart';
import 'package:dazzle_app/models/product_model.dart';
import 'package:dazzle_app/screens/new_and_trending/new_arrival_trending.dart';
import 'package:dazzle_app/screens/product_detail/product_detail_screen.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final HomeController homeController = Get.find<HomeController>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
      homeController.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          _buildBannerSlider(),
          SizedBox(height: 12.h),
          _wpCommunityBTN(),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(child: _buildTrendingNewArrivalBanner("Trending Now")),
                SizedBox(width: 16.w),
                Expanded(child: _buildTrendingNewArrivalBanner("New Arrival")),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          _buildCategoryTabs(),
          SizedBox(height: 16.h),
          _buildProductGrid(),
          Obx(() {
            if (homeController.isLoadingMore.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: CupertinoActivityIndicator()),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _wpCommunityBTN() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.wpColor),
          onPressed: () {
            launchUrl(Uri.parse("https://chat.whatsapp.com/DcmnzTm3xTIJTHzREOYKQs")).catchError((e) {
              print('Error launching URL: $e');
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svg/wlogo2.svg", color: Colors.white, height: 25, width: 25),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  "Join Our WhatsApp Community",
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    height: 1.2, // Adjust line height for better alignment
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Ensures text stays in a single line
                  maxLines: 1, // Restricts text to one line
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Obx(() {
      if (homeController.isLoadingBanners.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 200.h,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
          ),
        );
      }

      if (homeController.bannerImages.isEmpty) {
        return Container(height: 200.h, child: Center(child: Text('No banners available')));
      }

      return CarouselSlider.builder(
        itemCount: homeController.bannerImages.length,
        itemBuilder: (context, index, realIndex) {
          final imageUrl = homeController.bannerImages[index];
          return Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                errorWidget:
                    (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.error)),
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 200.h,
          autoPlay: homeController.bannerImages.length > 1,
          enlargeCenterPage: true,
          enableInfiniteScroll: homeController.bannerImages.length > 1,
          viewportFraction: 0.95,
        ),
      );
    });
  }

  Widget _buildTrendingNewArrivalBanner(String label) {
    return Obx(() {
      final bool isLoading = homeController.isLoadingPromoBanners.value;
      final String imageUrl =
          (label == "Trending Now") ? homeController.trendingImageUrl.value : homeController.newArrivalImageUrl.value;

      if (isLoading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 250.h,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
          ),
        );
      }

      if (imageUrl.isEmpty) {
        return Container(
          height: 250.h,
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12.r)),
          child: Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey.shade500, size: 40)),
        );
      }

      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TrendingAndArrivalScreen(filterType: label)));
        },
        child: Container(
          height: 250.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    stops: const [0.0, 0.5],
                  ),
                ),
              ),
              Positioned(
                left: 16.w,
                bottom: 16.h,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCategoryTabs() {
    return Obx(() {
      if (homeController.isLoadingCategories.value) {
        return Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder:
                  (context, index) => Container(
                    width: 80.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
                  ),
            ),
          ),
        );
      }

      if (homeController.categories.isEmpty) {
        return SizedBox.shrink(); // Don't show anything if no categories
      }

      return Container(
        height: 40.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: homeController.categories.length,
          itemBuilder: (context, index) {
            final category = homeController.categories[index];
            return _buildCategoryTab(category);
          },
        ),
      );
    });
  }

  Widget _buildCategoryTab(String category) {
    return Obx(() {
      final isSelected = homeController.selectedCategory.value == category;
      return GestureDetector(
        onTap: () => homeController.updateSelectedCategory(category),
        child: Container(
          margin: EdgeInsets.only(right: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade400),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProductGrid() {
    return Obx(() {
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
                (context, index) =>
                    Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r))),
          ),
        );
      }

      final products = homeController.products;

      if (products.isEmpty) {
        return Container(
          height: 200.h,
          child: Center(child: Text('No products found', style: TextStyle(fontSize: 16.sp, color: Colors.black54))),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 350.h,
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index]);
        },
      );
    });
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
                height: 490.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r), bottom: Radius.circular(12.r)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stock Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                        ),
                      ),
                      SizedBox(height: 15.h), // Increased spacing for detail screen
                      Text(
                        'This item is currently out of stock. Don\'t miss out! We\'ll notify you as soon as it\'s available again. Stay tuned or check back later!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp, // Adjusted for detail screen readability
                          fontWeight: FontWeight.w400,
                          height: 1.5, // Enhanced line height for better text flow
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
