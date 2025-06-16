import 'package:get/get.dart';
import '../../../models/product_model.dart';
import '../../../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final productsList = await _productService.getProducts(
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
      );
      products.value = productsList;
    } catch (e) {
      errorMessage.value = 'Failed to load products';
      print('Error in fetchProducts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }
} 