import 'package:dazzle_app/screens/home/home_controller.dart';
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
  String selectedCategory = 'All';
  HomeController homeController = Get.put(HomeController());

  // Dummy product data
  final List<Map<String, dynamic>> dummyProducts = [
    {
      'id': '1',
      'title': 'Floral Printed Saree',
      'price': 1299.00,
      'pcs': 1,
      'imageUrl': 'https://via.placeholder.com/300?text=Saree',
      'category': 'Sarees',
    },
    {
      'id': '2',
      'title': 'Designer Lehenga Choli',
      'price': 5999.00,
      'pcs': 3,
      'imageUrl': 'https://via.placeholder.com/300?text=Lehenga',
      'category': 'Lehenga Choli',
    },
    {
      'id': '3',
      'title': 'Cotton Salwar Suit',
      'price': 1999.00,
      'pcs': 2,
      'imageUrl': 'https://via.placeholder.com/300?text=Salwar',
      'category': 'Salwar Suits',
    },
    {
      'id': '4',
      'title': 'Embroidered Kurti',
      'price': 899.00,
      'pcs': 1,
      'imageUrl': 'https://via.placeholder.com/300?text=Kurti',
      'category': 'Kurtis',
    },
    {
      'id': '5',
      'title': 'Party Wear Dress',
      'price': 2499.00,
      'pcs': 1,
      'imageUrl': 'https://via.placeholder.com/300?text=Dress',
      'category': 'Dresses',
    },
    {
      'id': '6',
      'title': 'Silk Saree',
      'price': 3599.00,
      'pcs': 1,
      'imageUrl': 'https://via.placeholder.com/300?text=Silk+Saree',
      'category': 'Sarees',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          _buildBannerSlider(),
          SizedBox(height: 12.h),
          _wpCommunityBTN(),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(child: _buildTrendingNewArrivalBanner("Trending")),
                SizedBox(width: 16.w),
                Expanded(child: _buildTrendingNewArrivalBanner("New Arrival")),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          _buildCategoryTabs(),
          SizedBox(height: 16.h),
          _buildProductGrid(),
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
            launchUrl(Uri.parse("https://chat.whatsapp.com/DcmnzTm3xTIJTHzREOYKQs"));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svg/wlogo2.svg", color: Colors.white, height: 25, width: 25),
              SizedBox(width: 5),
              Text("Join Our WhatsApp Community", style: GoogleFonts.poppins(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Obx(() {
      if (homeController.isLoadingBanners.value) {
        return Container(
          height: 200.h,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
        );
      }

      if (homeController.bannerImages.isEmpty) {
        return Container(
          height: 200.h,
          child: Center(child: Text('No banners available')),
        );
      }

      return CarouselSlider(
        options: CarouselOptions(
          height: 200.h,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.95,
        ),
        items: homeController.bannerImages.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildCategoryTabs() {
    final categories = ['All', 'Sarees', 'Lehenga Choli', 'Salwar Suits', 'Kurtis', 'Dresses'];

    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            categories.map((category) {
              return _buildCategoryTab(category);
            }).toList(),
      ),
    );
  }

  Widget _buildCategoryTab(String category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    // Filter products based on selected category
    final filteredProducts =
        selectedCategory == 'All'
            ? dummyProducts
            : dummyProducts.where((p) => p['category'] == selectedCategory).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('No products found', style: TextStyle(fontSize: 16.sp, color: Colors.black))],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 350.h,
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail if needed
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/dazzle-fashion-ef4c1.firebasestorage.app/o/Asra%20Silk%20Saree%2FSanskriti%20V1111%20%E2%80%93%20Kanjeevaram%20Saree%2FWhatsApp%20Image%202025-05-09%20at%204.07.35%20PM%20(1).jpeg?alt=media&token=c8955ae6-a1a2-4623-a98a-26dcefe7a91b",
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CupertinoActivityIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey[200], child: const Icon(Icons.error));
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['title'],
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text('MOQ - ${product['pcs']} pcs', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                      ],
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

  Widget _buildTrendingNewArrivalBanner(String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen()));
      },
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Stack(
          children: [
            // Image with fade overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/dazzle-fashion-ef4c1.firebasestorage.app/o/Asra%20Silk%20Saree%2FSanskriti%20V1111%20%E2%80%93%20Kanjeevaram%20Saree%2FWhatsApp%20Image%202025-05-09%20at%204.07.35%20PM%20(1).jpeg?alt=media&token=c8955ae6-a1a2-4623-a98a-26dcefe7a91b",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: Colors.grey[200], child: const Center(child: CupertinoActivityIndicator()));
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[200], child: const Icon(Icons.error));
                },
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.white.withOpacity(0.7), Colors.transparent],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),
            // Label text
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
  }
}
