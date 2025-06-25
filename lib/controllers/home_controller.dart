import 'package:dazzle_app/models/product_model.dart';
import 'package:dazzle_app/services/product_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final ProductService _productService = ProductService();

  // --- THIS IS THE LOGIC THAT WAS MISSING ---
  // State for the Bottom Navigation Bar
  final RxInt currentIndex = 0.obs;
  // ---------------------------------------------

  // State for Main Banner Slider
  final RxList<String> bannerImages = <String>[].obs;
  final RxBool isLoadingBanners = false.obs;

  // State for Promotional Banners from Firebase Storage
  final RxString trendingImageUrl = 'Trending Now'.obs;
  final RxString newArrivalImageUrl = ''.obs;
  final RxBool isLoadingPromoBanners = false.obs;

  // State for Categories
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoadingCategories = false.obs;

  // State for Products
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingMore = false.obs;
  final Rx<DocumentSnapshot?> lastDocument = Rx<DocumentSnapshot?>(null);
  final RxBool hasMore = true.obs;
  final RxString selectedCategory = 'All'.obs;

  static const int _pageSize = 6;
  final List<String> _desiredOrder = [
    'All',
    'Kanjivaram',
    'Silk',
    'Paithani',
    'Banarasi',
    'Linen',
    'Cotton',
    'Organza',
  ];

  @override
  void onInit() {
    super.onInit();
    // Load all necessary data for the home screen when the controller is initialized
    loadBannerImages();
    loadPromoBanners();
    loadCategories();
    loadProducts(isInitialLoad: true);
  }

  // --- THIS IS THE LOGIC THAT WAS MISSING ---
  /// Updates the current index for the bottom navigation bar.
  void setIndex(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }
  // ---------------------------------------------

  /// Fetches the main banner slider images from the 'Banners/' folder in Firebase Storage.
  Future<void> loadBannerImages() async {
    try {
      isLoadingBanners.value = true;
      bannerImages.value = await _productService.getBannerSliderImages();
    } catch (e) {
      print('Error loading banner images: $e');
      bannerImages.value = [];
    } finally {
      isLoadingBanners.value = false;
    }
  }

  /// Fetches the promotional banners from the 'Trending Now' and 'New Arrival' folders concurrently.
  Future<void> loadPromoBanners() async {
    try {
      isLoadingPromoBanners.value = true;
      final List<String> urls = await Future.wait([
        _productService.getPromotionalBannerUrl('Trending Now'),
        _productService.getPromotionalBannerUrl('New Arrival'),
      ]);
      trendingImageUrl.value = urls[0];
      newArrivalImageUrl.value = urls[1];
    } catch (e) {
      print('Error loading promo banners: $e');
      trendingImageUrl.value = '';
      newArrivalImageUrl.value = '';
    } finally {
      isLoadingPromoBanners.value = false;
    }
  }

  /// Fetches the list of enabled categories from Firestore config.
  Future<void> loadCategories() async {
    try {
      isLoadingCategories.value = true;
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('config').doc('Categories').get();
      final List<String> fetchedCategories = [];
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>? ?? {};
        data.forEach((key, value) {
          if (value is bool && value == true) fetchedCategories.add(key);
        });
      }
      fetchedCategories.sort((a, b) {
        final lowerDesiredOrder = _desiredOrder.map((e) => e.toLowerCase()).toList();
        final indexA = lowerDesiredOrder.indexOf(a.toLowerCase());
        final indexB = lowerDesiredOrder.indexOf(b.toLowerCase());
        if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
        if (indexA != -1) return -1;
        if (indexB != -1) return 1;
        return a.compareTo(b);
      });
      categories.value = fetchedCategories;
    } catch (e) {
      print('Error loading categories: $e');
      categories.value = [];
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// Fetches a paginated list of products based on the selected category.
  Future<void> loadProducts({bool isInitialLoad = true, int limit = _pageSize}) async {
    if (!hasMore.value || (isInitialLoad && isLoadingProducts.value) || (!isInitialLoad && isLoadingMore.value)) return;
    try {
      isLoadingProducts.value = isInitialLoad;
      isLoadingMore.value = !isInitialLoad;
      final ProductQueryResult result = await _productService.getProducts(
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
        startAfter: isInitialLoad ? null : lastDocument.value,
        limit: limit,
      );
      final List<Product> fetchedProducts = result.products;
      if (fetchedProducts.isEmpty) {
        hasMore.value = false;
        return;
      }
      if (isInitialLoad) {
        products.value = fetchedProducts;
      } else {
        products.addAll(fetchedProducts.where((p) => !products.any((existing) => existing.id == p.id)));
      }
      lastDocument.value = result.lastDocument;
      hasMore.value = fetchedProducts.length == limit;
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      isLoadingProducts.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Loads the next page of products when the user scrolls.
  void loadMoreProducts() {
    if (!isLoadingMore.value && hasMore.value) {
      loadProducts(isInitialLoad: false, limit: _pageSize);
    }
  }

  /// Updates the selected category and re-fetches the product list from the beginning.
  void updateSelectedCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    products.clear();
    lastDocument.value = null;
    hasMore.value = true;
    loadProducts(isInitialLoad: true);
  }
}
