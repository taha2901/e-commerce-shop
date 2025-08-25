import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';

abstract class FavouriteServices {
  Future<void> addFavourite(
      {required String userId, required ProductItemModel product});
  Future<void> removeFavourite({required String userId,required String productId});
  Future<List<ProductItemModel>> getFavourite({required String userId});
}

class FavouriteServicesImpl implements FavouriteServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<void> addFavourite(
      {required String userId, required ProductItemModel product}) async {
    await firestoreServices.setData(
      path: ApiPaths.favouriteProduct(userId, product.id),
      data: product.toMap(),
    );
  }

  @override
  Future<void> removeFavourite({required String userId,required String productId}) async {
    await firestoreServices.deleteData(
        path: ApiPaths.favouriteProduct(userId, productId));
  }

  @override
  Future<List<ProductItemModel>> getFavourite({required String userId}) async {
    final res = await firestoreServices.getCollection(
      path: ApiPaths.favouriteProducts(userId),
      builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
    );
    return res;
  }
}
