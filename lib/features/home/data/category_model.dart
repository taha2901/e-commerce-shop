import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final Color bgColor;
  final Color textColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    this.bgColor = AppColors.primary,
    this.textColor = AppColors.white,
  });



  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      productsCount: map['productsCount']?.toInt() ?? 0,
      bgColor: Color(
          int.tryParse(map['bgColor'].toString()) ?? AppColors.primary.value),
      textColor: Color(
          int.tryParse(map['textColor'].toString()) ?? AppColors.white.value),
    );
  }
}

List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: '1',
    name: 'New Arrivals',
    productsCount: 208,
    bgColor: AppColors.grey,
    textColor: AppColors.black,
  ),
  CategoryModel(
    id: '2',
    name: 'Clothes',
    productsCount: 358,
    bgColor: AppColors.green,
    textColor: AppColors.white,
  ),
  CategoryModel(
    id: '3',
    name: 'Bags',
    productsCount: 160,
    bgColor: AppColors.black,
    textColor: const Color(0xFFFFFFFF),
  ),
  CategoryModel(
      id: '4',
      name: 'Shoes',
      productsCount: 230,
      bgColor: const Color(0xFF9E9E9E),
      textColor: const Color(0xFF000000)),
  CategoryModel(
      id: '5',
      name: 'Electronics',
      productsCount: 101,
      bgColor: AppColors.blue,
      textColor: AppColors.white),
];
