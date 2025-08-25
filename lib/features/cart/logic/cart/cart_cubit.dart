import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/core/services/cart_services.dart';
import 'package:ecommerce_app/features/home/data/add_to_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final cartServices = CartServicesImp();
  final authServices = AuthServicesImpl();

  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(CartError("يجب تسجيل الدخول أولاً"));
        return;
      }

      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      emit(CartLoaded(cartItems, _subtotal(cartItems)));
    } on FirebaseAuthException catch (e) {
      emit(CartError(_handleFirebaseError(e)));
    } catch (e) {
      emit(CartError("حدث خطأ في تحميل عربة التسوق: ${e.toString()}"));
    }
  }

  Future<void> incrementCounter(AddToCartModel cartItem, [int? initialValue]) async {
    await _updateQuantity(cartItem, isIncrement: true, initialValue: initialValue);
  }

  Future<void> decrementCounter(AddToCartModel cartItem, [int? initialValue]) async {
    await _updateQuantity(cartItem, isIncrement: false, initialValue: initialValue);
  }

  // دالة موحدة لتحديث الكمية
  Future<void> _updateQuantity(
    AddToCartModel cartItem, {
    required bool isIncrement,
    int? initialValue,
  }) async {
    try {
      if (state is! CartLoaded) return;
      
      final currentState = state as CartLoaded;
      final currentCartItems = List<AddToCartModel>.from(currentState.cartItems);
      
      final itemIndex = currentCartItems.indexWhere(
        (item) => item.id == cartItem.id
      );
      
      if (itemIndex == -1) return;

      final currentItem = currentCartItems[itemIndex];
      final currentQuantity = initialValue ?? currentItem.quantity;
      
      int newQuantity;
      if (isIncrement) {
        newQuantity = currentQuantity + 1;
      } else {
        if (currentQuantity <= 1) return; // لا نقص أقل من 1
        newQuantity = currentQuantity - 1;
      }
      
      // تحديث العنصر والـ UI فوراً
      final updatedItem = currentItem.copyWith(quantity: newQuantity);
      currentCartItems[itemIndex] = updatedItem;
      
      final newSubtotal = _subtotal(currentCartItems);
      emit(CartLoaded(currentCartItems, newSubtotal));
      
      // حفظ في الخلفية
      _saveCartItemInBackground(updatedItem);
      
    } catch (e) {
      // في حالة الخطأ، إعادة التحميل
      getCartItems();
    }
  }

  // حفظ في الخلفية بدون await لتجنب التأخير
  void _saveCartItemInBackground(AddToCartModel cartItem) {
    cartServices.setCartItem(
      authServices.currentUser()?.uid ?? '',
      cartItem,
    ).catchError((error) {
      // في حالة فشل الحفظ، إعادة تحميل الكارت
      getCartItems();
    });
  }

  Future<void> removeFromCart(AddToCartModel cartItem) async {
  try {
    if (state is! CartLoaded) return;
    
    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      emit(CartError("يجب تسجيل الدخول أولاً"));
      return;
    }
    
    // تحديث الـ UI فوراً بإزالة العنصر (Optimistic Update)
    final currentState = state as CartLoaded;
    final updatedCartItems = currentState.cartItems
        .where((item) => item.id != cartItem.id)
        .toList();
    
    final newSubtotal = _subtotal(updatedCartItems);
    emit(CartLoaded(updatedCartItems, newSubtotal));
    
    // حذف من Firebase في الخلفية
    try {
      await cartServices.removeFromCart(currentUser.uid, cartItem.id);
    } catch (e) {
      // إذا فشل الحذف من Firebase، أعد تحميل الكارت لإظهار البيانات الصحيحة
      getCartItems();
      rethrow;
    }
    
  } on FirebaseAuthException catch (e) {
    // أعد تحميل الكارت في حالة خطأ المصادقة
    getCartItems();
    emit(CartError(_handleFirebaseError(e)));
  } catch (e) {
    // أعد تحميل الكارت في حالة أي خطأ آخر
    getCartItems();
    emit(CartError("حدث خطأ في حذف المنتج: ${e.toString()}"));
  }
}

  Future<void> clearCart() async {
    try {
      emit(CartLoading());
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(CartError("يجب تسجيل الدخول أولاً"));
        return;
      }
      
      await cartServices.clearCart(currentUser.uid);
      emit(CartLoaded([], 0.0));
      
    } on FirebaseAuthException catch (e) {
      emit(CartError(_handleFirebaseError(e)));
    } catch (e) {
      emit(CartError("حدث خطأ في تفريغ عربة التسوق: ${e.toString()}"));
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'permission-denied':
        return "ليس لديك صلاحية للقيام بهذه العملية";
      case 'unavailable':
        return "الخدمة غير متاحة حالياً، حاول مرة أخرى لاحقاً";
      case 'network-request-failed':
        return "خطأ في الاتصال بالشبكة، تأكد من اتصالك بالإنترنت";
      case 'unauthenticated':
        return "انتهت جلسة التسجيل، يرجى تسجيل الدخول مرة أخرى";
      default:
        return "حدث خطأ في النظام: ${e.message ?? e.code}";
    }
  }

  double _subtotal(List<AddToCartModel> cartItems) => cartItems.fold<double>(
      0,
      (previousValue, item) =>
          previousValue + (item.product.price * item.quantity));
}