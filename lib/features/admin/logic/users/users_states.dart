// features/admin/logic/admin_products_cubit/admin_products_state.dart

import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserManagementState {}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class UserManagementLoaded extends UserManagementState {
  final List<UserData> users;
  UserManagementLoaded(this.users);
}

class UserManagementSuccess extends UserManagementState {
  final String message;
  UserManagementSuccess(this.message);
}

class UserManagementError extends UserManagementState {
  final String message;
  UserManagementError(this.message);
}