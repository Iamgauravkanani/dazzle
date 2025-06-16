import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  Future<List<ProductModel>> getProducts({String? category}) async {
    try {
      Query query = _firestore.collection(_collection);
      
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      final QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to the data
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }
} 