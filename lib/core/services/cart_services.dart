import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/home/data/add_to_cart.dart';
import 'package:flutter/widgets.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> fetchCartItems(String userId);
  Future<void> setCartItem(String userId, AddToCartModel cartItem);
}

class CartServicesImp implements CartServices {
  final fireStoreServices = FirestoreServices.instance;
  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) async {
    return await fireStoreServices.getCollection(
      path: ApiPaths.cartItems(userId),
      builder: (data, documentId) => AddToCartModel.fromMap(data),
    );
  }

  @override
  Future<void> setCartItem(String userId, AddToCartModel cartItem) async {
    await fireStoreServices.setData(
        path: ApiPaths.cartItem(userId, cartItem.id), data: cartItem.toMap());
  }

  Future<void> removeFromCart(String userId, String cartItemId) async {
    await fireStoreServices.deleteData(
      path: ApiPaths.cartItem(userId, cartItemId),
    );
  }

  // مسح الكارت بالكامل
  Future<void> clearCart(String userId) async {
    try {
      // جلب جميع العناصر أولاً
      final cartItems = await fetchCartItems(userId);

      // حذف كل عنصر
      for (final item in cartItems) {
        await removeFromCart(userId, item.id);
      }
    } catch (e) {
      debugPrint("Error clearing cart: $e");
      rethrow;
    }
  }
}
