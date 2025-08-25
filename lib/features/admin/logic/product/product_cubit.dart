// features/admin/logic/admin_products_cubit/admin_products_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/core/services/admin_product_services.dart';
import 'package:ecommerce_app/features/admin/logic/product/product_states.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';


class AdminProductsCubit extends Cubit<AdminProductsState> {
  final AdminServices _adminServices;

  AdminProductsCubit(this._adminServices) : super(AdminProductsInitial());

  // إضافة منتج جديد
  Future<void> addProduct(ProductItemModel product) async {
    emit(AdminProductsLoading());
    try {
      await _adminServices.addProduct(product);
      emit(AdminProductsSuccess('تم إضافة المنتج بنجاح'));
    } catch (e) {
      emit(AdminProductsError('فشل في إضافة المنتج: $e'));
    }
  }

  // تحديث منتج موجود
  Future<void> updateProduct(String productId, ProductItemModel product) async {
    emit(AdminProductsLoading());
    try {
      await _adminServices.updateProduct(productId, product);
      emit(AdminProductsSuccess('تم تحديث المنتج بنجاح'));
    } catch (e) {
      emit(AdminProductsError('فشل في تحديث المنتج: $e'));
    }
  }

  // حذف منتج
  Future<void> deleteProduct(String productId) async {
    emit(AdminProductsLoading());
    try {
      await _adminServices.deleteProduct(productId);
      emit(AdminProductsSuccess('تم حذف المنتج بنجاح'));
    } catch (e) {
      emit(AdminProductsError('فشل في حذف المنتج: $e'));
    }
  }

  // جلب جميع المنتجات
  Future<void> fetchAllProducts() async {
    emit(AdminProductsLoading());
    try {
      final products = await _adminServices.fetchAllProducts();
      emit(AdminProductsLoaded(products));
    } catch (e) {
      emit(AdminProductsError('فشل في جلب المنتجات: $e'));
    }
  }

  // إعادة تعيين الحالة
  void resetState() {
    emit(AdminProductsInitial());
  }
}