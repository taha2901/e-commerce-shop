part of 'cart_cubit.dart';

@immutable
sealed class CartState {
  const CartState();
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<AddToCartModel> cartItems;
  final double subtotal;

  const CartLoaded(this.cartItems, this.subtotal);
  
  // إضافة equality للتحكم في rebuilds
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartLoaded && 
           other.cartItems.length == cartItems.length &&
           other.subtotal == subtotal;
  }

  @override
  int get hashCode => cartItems.length.hashCode ^ subtotal.hashCode;
}

final class CartError extends CartState {
  final String message;

  const CartError(this.message);
}

// حالات الحذف فقط - باقي الحالات تم حذفها لعدم الحاجة إليها
final class CartItemRemoving extends CartState {
  final String productId;

  const CartItemRemoving(this.productId);
}