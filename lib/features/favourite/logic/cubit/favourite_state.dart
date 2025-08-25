part of 'favourite_cubit.dart';

@immutable
sealed class FavouriteState {}

final class FavouriteInitial extends FavouriteState {}

final class FavouriteLoading extends FavouriteState {}

final class FavouriteLoaded extends FavouriteState {
  final List<ProductItemModel> favouriteProduct;

  FavouriteLoaded({required this.favouriteProduct});
  
  // إضافة equality للتحكم في rebuilds
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavouriteLoaded && 
           other.favouriteProduct.length == favouriteProduct.length;
  }

  @override
  int get hashCode => favouriteProduct.length.hashCode;
}

final class FavouriteError extends FavouriteState {
  final String errorMessage;

  FavouriteError({required this.errorMessage});
}

// حالة واحدة للحذف بدلاً من 3 حالات
final class FavouriteRemoving extends FavouriteState {
  final String productId;

  FavouriteRemoving({required this.productId});
}