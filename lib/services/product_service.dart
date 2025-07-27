import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dazzle_app/models/product_model.dart';

class ProductQueryResult {
  final List<Product> products;
  final DocumentSnapshot? lastDocument;

  ProductQueryResult({required this.products, this.lastDocument});
}

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _productCollection = 'products';

  Future<ProductQueryResult> getProducts({
    String? category,
    String? filterType, // "New Arrival" or "Trending Now"
    DocumentSnapshot? startAfter,
    int limit = 6,
  }) async {
    try {
      Query query = _firestore.collection(_productCollection);

      print('Building query for collection: $_productCollection');
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
        print('Added category filter: $category');
      }
      if (filterType != null) {
        if (filterType == "New Arrival") {
          query = query.where('isNA', isEqualTo: true);
          print('Added filter: isNewArrival = true');
        } else if (filterType == "Trending Now") {
          query = query.where('isTN', isEqualTo: true);
          print('Added filter: isNewTrending = true');
        }
      }
      query = query.orderBy('createdAt', descending: true);
      print('Ordered by createdAt descending');
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
        print('Starting after document: $startAfter');
      }
      final QuerySnapshot snapshot = await query.limit(limit).get();
      print('Query executed, documents fetched: ${snapshot.docs.length}');

      final products =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            final product = Product.fromMap(data);
            print(
              'Product fetched: ${product.name}, isNewArrival: ${product.isNewArrival}, isNewTrending: ${product.isNewTrending}',
            );
            return product;
          }).toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      print('Last document: $lastDoc, Products count: ${products.length}');

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

      final List<Future<String>> urlFutures = result.items.map((ref) => ref.getDownloadURL()).toList();
      return await Future.wait(urlFutures);
    } catch (e) {
      print('Error fetching banner slider images: $e');
      return [];
    }
  }

  Future<String> getPromotionalBannerUrl(String folderName) async {
    try {
      final ListResult result = await _storage.ref(folderName).listAll();
      if (result.items.isEmpty) return '';

      final Reference imageRef = result.items.first;
      return await imageRef.getDownloadURL();
    } catch (e) {
      print('Error fetching banner from storage folder "$folderName": $e');
      return '';
    }
  }
}
