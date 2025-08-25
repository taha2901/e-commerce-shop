// features/admin/data/admin_services.dart
import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';

abstract class AdminServices {
  Future<void> addProduct(ProductItemModel product);
  Future<void> updateProduct(String productId, ProductItemModel product);
  Future<void> deleteProduct(String productId);
  Future<List<ProductItemModel>> fetchAllProducts();
}

class AdminServicesImpl implements AdminServices {
  final FirestoreServices _firestore = FirestoreServices.instance;

  @override
  Future<void> addProduct(ProductItemModel product) async {
    try {
      // نستخدم الـ ID الموجود في الموديل نفسه
      await _firestore.setData(
        path: ApiPaths.product(product.id),
        data: product.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateProduct(String productId, ProductItemModel product) async {
    try {
      await _firestore.setData(
        path: ApiPaths.product(productId),
        data: product.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.deleteData(
        path: ApiPaths.product(productId),
      );
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<List<ProductItemModel>> fetchAllProducts() async {
    try {
      final products = await _firestore.getCollection<ProductItemModel>(
        path: ApiPaths.products(),
        builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
      );
      return products;
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}