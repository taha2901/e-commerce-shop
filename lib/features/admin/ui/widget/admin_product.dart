import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/features/admin/logic/product/product_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/product/product_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({Key? key}) : super(key: key);

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminProductsCubit>().fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : AppColors.kWhiteColor,
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showAddProductDialog,
            icon: const Icon(Icons.add),
            tooltip: 'إضافة منتج جديد',
          ),
        ],
      ),
      body: BlocConsumer<AdminProductsCubit, AdminProductsState>(
        listener: (context, state) {
          if (state is AdminProductsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<AdminProductsCubit>().fetchAllProducts();
          } else if (state is AdminProductsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminProductsLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text("لا يوجد منتجات بعد"));
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index], isDark);
              },
            );
          }
          return const Center(child: Text("ابدأ بإدارة المنتجات"));
        },
      ),
    );
  }

  Widget _buildProductCard(ProductItemModel product, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.r),
            image: product.imgUrl != null
                ? DecorationImage(
                    image: NetworkImage(product.imgUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: product.imgUrl == null
              ? Icon(Icons.image, color: Colors.grey.shade400, size: 30.r)
              : null,
        ),
        title: Text(
          product.name,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              'السعر: \$${product.price}',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'الفئة: ${product.category}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.black),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text("تعديل", style: TextStyle(color: isDark ? Colors.white : Colors.black))),
            const PopupMenuItem(
              value: 'delete',
              child: Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
          onSelected: (value) {
            if (value == "edit") {
              _showEditProductDialog(product);
            } else if (value == "delete") {
              _showDeleteConfirmation(product.id);
            }
          },
        ),
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: const Text("إضافة منتج"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "الاسم")),
                TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: "السعر")),
                TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: "الفئة")),
                TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: "الوصف")),
                TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: "رابط الصورة")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
            ElevatedButton(
              onPressed: () {
                final product = ProductItemModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  price: double.tryParse(_priceController.text) ?? 0,
                  category: _categoryController.text,
                  description: _descriptionController.text,
                  imgUrl: _imageUrlController.text,
                );
                context.read<AdminProductsCubit>().addProduct(product);
                Navigator.pop(context);
              },
              child: const Text("إضافة"),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(ProductItemModel product) {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _categoryController.text = product.category;
    _descriptionController.text = product.description ?? "";
    _imageUrlController.text = product.imgUrl ?? "";

    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: const Text("تعديل المنتج"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "الاسم")),
                TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: "السعر")),
                TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: "الفئة")),
                TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: "الوصف")),
                TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: "رابط الصورة")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
            ElevatedButton(
              onPressed: () {
                final updatedProduct = ProductItemModel(
                  id: product.id,
                  name: _nameController.text,
                  price: double.tryParse(_priceController.text) ?? 0,
                  category: _categoryController.text,
                  description: _descriptionController.text,
                  imgUrl: _imageUrlController.text,
                );
                context.read<AdminProductsCubit>().updateProduct(product.id, updatedProduct);
                Navigator.pop(context);
              },
              child: const Text("حفظ"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف المنتج"),
        content: const Text("هل تريد حذف هذا المنتج؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AdminProductsCubit>().deleteProduct(productId);
              Navigator.pop(context);
            },
            child: const Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}