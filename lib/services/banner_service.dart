import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class BannerService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> getBannerImages() async {
    try {
      // Get banner images directly from Firebase Storage
      final ListResult result = await _storage.ref().child('Carousel Banners').listAll();
      List<String> bannerUrls = [];
      
      for (var item in result.items) {
        // Get download URL for each image
        final url = await item.getDownloadURL();
        bannerUrls.add(url);
      }

      return bannerUrls;
    } catch (e) {
      print('Error getting banner images: $e');
      return [];
    }
  }
}