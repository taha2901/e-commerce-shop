import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/core/services/cart_services.dart';
import 'package:ecommerce_app/core/services/product_details_services.dart';
import 'package:ecommerce_app/features/cart/logic/cart/cart_cubit.dart';
import 'package:ecommerce_app/features/home/data/add_to_cart.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? selectedSize;
  int quantity = 1;
  Set<String> _cartProductIds = {}; // استخدام Set للبحث السريع

  final productDetailsSercices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getProductDetails(String id) async {
    emit(ProductDetailsLoading());

    try {
      final selectedProduct = await productDetailsSercices.fetchProductDetails(id);
      
      // جلب معرفات المنتجات في الكارت فقط
      await _loadCartProductIds();
      
      emit(ProductDetailsLoaded(product: selectedProduct));
    } catch (e) {
      emit(ProductDetailsError(message: "Error: $e"));
    }
  }

  // جلب معرفات المنتجات في الكارت فقط (تحسين في الذاكرة)
  Future<void> _loadCartProductIds() async {
    try {
      final currentUser = authServices.currentUser();
      if (currentUser != null) {
        final cartServices = CartServicesImp();
        final cartItems = await cartServices.fetchCartItems(currentUser.uid);
        _cartProductIds = cartItems.map((item) => item.product.id).toSet();
      }
    } catch (e) {
      debugPrint("Error loading cart items: $e");
    }
  }

  // التحقق من وجود المنتج في الكارت بشكل أسرع
  bool isProductInCart(String productId) {
    return _cartProductIds.contains(productId);
  }

  void incrementCounter() {
    quantity++;
    emit(QuantityCounterLoaded(value: quantity));
  }

  void decrementCounter() {
    if (quantity > 1) {
      quantity--;
      emit(QuantityCounterLoaded(value: quantity));
    }
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  Future<void> addToCart(String productId, BuildContext context) async {
    if (selectedSize == null) {
      _showSnackBar(context, 'Please select size', Colors.orange);
      return;
    }

    if (isProductInCart(productId)) {
      _showSnackBar(context, 'This product is already in your cart', Colors.orange);
      return;
    }

    emit(ProductAddingToCart());
    
    try {
      final selectedProduct = await productDetailsSercices.fetchProductDetails(productId);

      final cartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: selectedProduct,
        size: selectedSize!,
        quantity: quantity,
      );

      await productDetailsSercices.addToCart(cartItem, authServices.currentUser()!.uid);

      // إضافة المعرف للمجموعة المحلية
      _cartProductIds.add(productId);
      
      // تحديث الكارت في الصفحة الأخرى
      if (context.mounted) {
        final cartCubit = BlocProvider.of<CartCubit>(context);
        await cartCubit.getCartItems();
      }

      emit(ProductAddedToCart(productId: productId));
      
      if (context.mounted) {
        _showSnackBar(context, 'Product added to cart successfully!', Colors.green);
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      emit(ProductAddedToCartError(message: "Error: $e"));
      
      if (context.mounted) {
        _showSnackBar(context, 'Failed to add product to cart: $e', Colors.red);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
    }
  }

  // إعادة تعيين القيم عند مغادرة الصفحة
  void resetValues() {
    selectedSize = null;
    quantity = 1;
    _cartProductIds.clear();
  }
}