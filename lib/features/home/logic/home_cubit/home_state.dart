// part of 'home_cubit.dart';

// @immutable
// sealed class HomeState {}

// final class HomeInitial extends HomeState {}

// final class HomeLoading extends HomeState {}

// final class HomeLoaded extends HomeState {
//   final List<ProductItemModel> products;
//   final List<HomeCarouselItemModel> carouselItems;
//   HomeLoaded({
//     required this.products,
//     required this.carouselItems,
//   });
// }

// final class HomeError extends HomeState {
//   final String errMessage;

//   HomeError(this.errMessage);
// }

// final class SetFavouriteLoading extends HomeState {
//   final String productId;

//   SetFavouriteLoading({required this.productId});
// }

// final class SetFavouriteSuccess extends HomeState {
//   final bool isFav;
//   final String productId;

//   SetFavouriteSuccess( {required this.isFav, required this.productId});
// }

// final class SetFavouriteFailure extends HomeState {
//   final String errMessage;
//   final String productId;
//   SetFavouriteFailure(this.errMessage, this.productId);
// }

part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ProductItemModel> products;
  final List<HomeCarouselItemModel> carouselItems;

  HomeLoaded({
    required this.products,
    required this.carouselItems,
  });
}

final class HomeError extends HomeState {
  final String errMessage;

  HomeError(this.errMessage);
}

final class SetFavouriteLoading extends HomeState {
  final String productId;

  SetFavouriteLoading({required this.productId});
}

final class SetFavouriteSuccess extends HomeState {
  final bool isFav;
  final String productId;

  SetFavouriteSuccess({required this.isFav, required this.productId});
}

final class SetFavouriteFailure extends HomeState {
  final String errMessage;
  final String productId;

  SetFavouriteFailure(this.errMessage, this.productId);
}
