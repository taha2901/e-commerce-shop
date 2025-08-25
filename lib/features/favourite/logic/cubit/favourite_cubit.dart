import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/core/services/favourite_services.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:ecommerce_app/features/home/logic/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());
  
  final favoriteServices = FavouriteServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getFavoriteProducts() async {
    emit(FavouriteLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FavouriteError(errorMessage: "يجب تسجيل الدخول أولاً"));
        return;
      }
      
      final favoriteProducts = await favoriteServices.getFavourite(
        userId: currentUser.uid,
      );
      emit(FavouriteLoaded(favouriteProduct: favoriteProducts));
    } catch (e) {
      emit(FavouriteError(errorMessage: e.toString()));
    }
  }

  Future<void> removeFavorite(String productId, BuildContext context) async {
    try {
      // تحديث الـ UI فوراً بإزالة العنصر
      if (state is FavouriteLoaded) {
        final currentState = state as FavouriteLoaded;
        final updatedProducts = currentState.favouriteProduct
            .where((product) => product.id != productId)
            .toList();
        
        emit(FavouriteLoaded(favouriteProduct: updatedProducts));
      }

      final currentUser = authServices.currentUser();
      if (currentUser == null) return;

      // حذف من Firebase في الخلفية
      await favoriteServices.removeFavourite(
        userId: currentUser.uid,
        productId: productId,
      );

      // تحديث الـ HomeCubit بدون انتظار
      if (context.mounted) {
        BlocProvider.of<HomeCubit>(context).getHomeData();
      }
      
    } catch (e) {
      // في حالة الخطأ، إعادة تحميل القائمة
      getFavoriteProducts();
      
      // إظهار رسالة خطأ
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove item: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}