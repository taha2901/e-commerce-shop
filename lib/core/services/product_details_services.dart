import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/home/data/add_to_cart.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> fetchProductDetails(String productId);

  Future<void> addToCart(AddToCartModel cartItem, String userId);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<ProductItemModel> fetchProductDetails(String productId) async {
    final selectedProduct =
        await firestoreServices.getDocument<ProductItemModel>(
      path: ApiPaths.product(productId),
      builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
    );
    return selectedProduct;
  }

  @override
  Future<void> addToCart(AddToCartModel cartItem, String userId) async {
    await firestoreServices.setData(
      path: ApiPaths.cartItem(userId, cartItem.id),
      data: cartItem.toMap(),
    );
  }
}
