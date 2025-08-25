import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/home/data/category_model.dart';
import 'package:ecommerce_app/features/home/data/home_carousal_item_model.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> fetchProducts();
  Future<List<HomeCarouselItemModel>> fetchHomeCarouselItems();
  Future<List<CategoryModel>> fetchCategories();
}

class HomeServicesImpl implements HomeServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    final resultOfProducts = await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
    );
    return resultOfProducts;
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final resultOfCategory =
        await firestoreServices.getCollection<CategoryModel>(
      path: ApiPaths.categories(),
      builder: (data, documentId) => CategoryModel.fromMap(data),
    );
    return resultOfCategory;
  }

  @override
  Future<List<HomeCarouselItemModel>> fetchHomeCarouselItems() async {
    final result = await firestoreServices.getCollection<HomeCarouselItemModel>(
      path: ApiPaths.announcments(),
      builder: (data, documentId) => HomeCarouselItemModel.fromMap(data),
    );
    return result;
  }

  // @override
  // Future<void> addFavouriteProduct(
  //     {required String userId, required ProductItemModel product}) async {
  //   await firestoreServices.setData(
  //     path: ApiPaths.favouriteProduct(userId, product.id),
  //     data: product.toMap(),
  //   );
  // }

  // @override
  // Future<void> removeFavouriteProduct(
  //     {required String userId, required String productId}) async {
  //   await firestoreServices.deleteData(
  //       path: ApiPaths.favouriteProduct(userId, productId));
  // }

  // @override
  // Future<List<ProductItemModel>> fetchFavouriteProducts({ required String userId}) async {
  //   final result = await firestoreServices.getCollection<ProductItemModel>(
  //     path: ApiPaths.favouriteProducts(userId),
  //     builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
  //   );
  //   return result;
  // }
}
