import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/core/services/favourite_services.dart';
import 'package:ecommerce_app/core/services/home_services.dart';
import 'package:ecommerce_app/features/favourite/logic/cubit/favourite_cubit.dart';
import 'package:ecommerce_app/features/home/data/home_carousal_item_model.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  
  final homeServices = HomeServicesImpl();
  final authServices = AuthServicesImpl();
  final favouriteServices = FavouriteServicesImpl();
  
  // حفظ حالة المفضلة محلياً لتحسين الأداء
  Set<String> _favouriteProductIds = {};
  List<ProductItemModel> _cachedProducts = [];

  void getHomeData() async {
    emit(HomeLoading());
    try {
      final products = await homeServices.fetchProducts();
      final homeCarouselItems = await homeServices.fetchHomeCarouselItems();
      final favouriteProducts = await favouriteServices.getFavourite(
        userId: authServices.currentUser()!.uid,
      );
      
      // تحديث مجموعة المفضلة
      _favouriteProductIds = favouriteProducts.map((product) => product.id).toSet();
      
      final List<ProductItemModel> finalProducts = products.map(
        (product) {
          final isFavorite = _favouriteProductIds.contains(product.id);
          return product.copyWith(isFavorite: isFavorite);
        },
      ).toList();
      
      _cachedProducts = finalProducts;
      
      emit(HomeLoaded(
        carouselItems: homeCarouselItems,
        products: finalProducts,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(HomeError("Error: $e"));
    }
  }

  Future<void> setFavourite(ProductItemModel product, BuildContext context) async {
    emit(SetFavouriteLoading(productId: product.id));
    
    try {
      final currentUser = authServices.currentUser();
      final isFavourite = _favouriteProductIds.contains(product.id);
      
      if (isFavourite) {
        await favouriteServices.removeFavourite(
            userId: currentUser!.uid, productId: product.id);
        _favouriteProductIds.remove(product.id); // إزالة من المجموعة المحلية
      } else {
        await favouriteServices.addFavourite(
            userId: currentUser!.uid, product: product);
        _favouriteProductIds.add(product.id); // إضافة للمجموعة المحلية
      }

      // تحديث المنتج في القائمة المحفوظة محلياً
      _updateProductInCache(product.id, !isFavourite);
      
      emit(SetFavouriteSuccess(isFav: !isFavourite, productId: product.id));
      
      // تحديث قائمة المفضلة في الصفحة الأخرى
      if (context.mounted) {
        BlocProvider.of<FavouriteCubit>(context).getFavoriteProducts();
      }
    } catch (e) {
      emit(SetFavouriteFailure(e.toString(), product.id));
    }
  }
  
  // تحديث المنتج في القائمة المحفوظة محلياً
  void _updateProductInCache(String productId, bool isFavorite) {
    for (int i = 0; i < _cachedProducts.length; i++) {
      if (_cachedProducts[i].id == productId) {
        _cachedProducts[i] = _cachedProducts[i].copyWith(isFavorite: isFavorite);
        break;
      }
    }
  }
  
  // الحصول على حالة المفضلة لمنتج معين
  bool isProductFavorite(String productId) {
    return _favouriteProductIds.contains(productId);
  }
}

