import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazzle_app/models/product_model.dart';
import 'package:get/get.dart';
import '../../../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  // State for the product list
  final RxList<Product> products = <Product>[].obs;

  // State for the currently selected category filter
  final RxString selectedCategory = 'All'.obs;

  // Pagination and loading states
  static const int _pageSize = 10; // You can adjust the page size
  final RxBool isLoading = false.obs; // For the initial load
  final RxBool isLoadingMore = false.obs; // For subsequent loads (pagination)
  final Rx<DocumentSnapshot?> lastDocument = Rx<DocumentSnapshot?>(null);
  final RxBool hasMore = true.obs; // To know if there are more products to fetch

  // Error handling state
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch the first page of products when the controller is initialized
    fetchProducts(isInitialLoad: true);
  }

  /// Changes the category, resets the product list, and fetches the first page of new data.
  void setCategory(String category) {
    if (selectedCategory.value == category) return; // Don't reload if the same category is selected

    selectedCategory.value = category;

    // Reset all state for the new category
    products.clear();
    lastDocument.value = null;
    hasMore.value = true;
    errorMessage.value = '';

    // Fetch products for the new category
    fetchProducts(isInitialLoad: true);
  }

  /// Fetches products from the service. Can be an initial load or a subsequent "load more" call.
  Future<void> fetchProducts({bool isInitialLoad = false}) async {
    // Prevent duplicate calls while loading
    if (isLoading.value || isLoadingMore.value) return;
    // If it's not an initial load, and we've already loaded everything, do nothing
    if (!isInitialLoad && !hasMore.value) return;

    try {
      // Set the appropriate loading flag
      if (isInitialLoad) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      errorMessage.value = '';

      // Call the service, passing the category and the last document for pagination
      final ProductQueryResult result = await _productService.getProducts(
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
        limit: _pageSize,
        startAfter: isInitialLoad ? null : lastDocument.value,
      );

      final fetchedProducts = result.products;

      if (fetchedProducts.isEmpty) {
        // No more products to load
        hasMore.value = false;
      } else {
        if (isInitialLoad) {
          // For an initial load, replace the list
          products.value = fetchedProducts;
        } else {
          // For subsequent loads, add to the existing list
          products.addAll(fetchedProducts);
        }
        // Update the last document for the next pagination call
        lastDocument.value = result.lastDocument;
        // If the number of items fetched is less than the page size, we've reached the end
        hasMore.value = fetchedProducts.length == _pageSize;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load products. Please try again.';
      print('Error in fetchProducts: $e');
    } finally {
      // Reset loading flags
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Public method to be called by the UI to load the next page.
  void loadMoreProducts() {
    fetchProducts(isInitialLoad: false);
  }

  /// Refreshes the current list, clearing existing data and fetching from the start.
  Future<void> refreshProducts() async {
    // Reset state and fetch the first page again
    products.clear();
    lastDocument.value = null;
    hasMore.value = true;
    await fetchProducts(isInitialLoad: true);
  }
}
