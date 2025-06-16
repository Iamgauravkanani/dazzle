import 'package:get/get.dart';
import '../../../services/banner_service.dart';

class HomeController extends GetxController {
  final BannerService _bannerService = BannerService();
  final RxInt currentIndex = 0.obs;
  final RxList<String> bannerImages = <String>[].obs;
  final RxBool isLoadingBanners = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBannerImages();
  }

  // Method to update the current index
  void setIndex(int index) {
    // Optional: Prevent unnecessary updates if same index is selected
    if (currentIndex.value != index) {
      currentIndex.value = index;

      // You can add additional logic here when tab changes
      // For example: loadDataForTab(index);
    }
  }

  Future<void> loadBannerImages() async {
    try {
      isLoadingBanners.value = true;
      final images = await _bannerService.getBannerImages();
      bannerImages.value = images;
    } catch (e) {
      print('Error loading banner images: $e');
    } finally {
      isLoadingBanners.value = false;
    }
  }
}
