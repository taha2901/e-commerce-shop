// features/admin/logic/admin_products_cubit/admin_products_state.dart

import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AdminProductsState {}

class AdminProductsInitial extends AdminProductsState {}

class AdminProductsLoading extends AdminProductsState {}

class AdminProductsLoaded extends AdminProductsState {
  final List<ProductItemModel> products;
  AdminProductsLoaded(this.products);
}

class AdminProductsSuccess extends AdminProductsState {
  final String message;
  AdminProductsSuccess(this.message);
}

class AdminProductsError extends AdminProductsState {
  final String message;
  AdminProductsError(this.message);
}