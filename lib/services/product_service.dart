import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:dazzle_app/models/product_model.dart';

class ProductQueryResult {
  final List<Product> products;
  final DocumentSnapshot? lastDocument;

  ProductQueryResult({required this.products, this.lastDocument});
}

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Add Storage instance
  final String _productCollection = 'products';

  Future<ProductQueryResult> getProducts({String? category, DocumentSnapshot? startAfter, int limit = 6}) async {
    try {
      Query query = _firestore.collection(_productCollection);
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      query = query.orderBy('createdAt', descending: true);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      final QuerySnapshot snapshot = await query.limit(limit).get();
      final products =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return Product.fromMap(data);
          }).toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      return ProductQueryResult(products: products, lastDocument: lastDoc);
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<String>> getBannerSliderImages() async {
    try {
      final ListResult result = await _storage.ref('Carousel Banners').listAll();
      if (result.items.isEmpty) return [];

      // Use Future.wait to get all download URLs in parallel for better performance
      final List<Future<String>> urlFutures = result.items.map((ref) => ref.getDownloadURL()).toList();
      return await Future.wait(urlFutures);
    } catch (e) {
      print('Error fetching banner slider images: $e');
      return [];
    }
  }

  Future<String> getPromotionalBannerUrl(String folderName) async {
    try {
      // List all items in the specified folder
      final ListResult result = await _storage.ref(folderName).listAll();

      // Check if the folder contains at least one item
      if (result.items.isNotEmpty) {
        // Get the reference to the first item
        final Reference imageRef = result.items.first;
        // Return its public download URL
        return await imageRef.getDownloadURL();
      }
      print('Warning: No items found in Firebase Storage folder "$folderName"');
      return '';
    } catch (e) {
      print('Error fetching banner from storage folder "$folderName": $e');
      return '';
    }
  }
}
