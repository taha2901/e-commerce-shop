import 'dart:io';
import 'package:ecommerce_app/features/admin/logic/product/product_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/product/product_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'admin_theme.dart';

enum _ImgSource { device, url }

class _ImageState {
  _ImgSource source;
  String? url;
  String? filePath;
  _ImageState({this.source = _ImgSource.url, this.url, this.filePath});
  String? get resolvedUrl => source == _ImgSource.url ? url : filePath;
  void clear() {
    url = null;
    filePath = null;
  }
}

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});
  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _catCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminProductsCubit>().fetchAllProducts();
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _priceCtrl, _catCtrl, _descCtrl, _urlCtrl])
      c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AdminAppBar(
        title: 'إدارة المنتجات',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: _AddButton(onTap: () => _openDialog(null)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: AdminSearchBar(hint: 'البحث في المنتجات...'),
          ),
          Expanded(
            child: BlocConsumer<AdminProductsCubit, AdminProductsState>(
              listener: (ctx, state) {
                if (state is AdminProductsSuccess) {
                  _snack(ctx, state.message, isError: false);
                  ctx.read<AdminProductsCubit>().fetchAllProducts();
                } else if (state is AdminProductsError) {
                  _snack(ctx, state.message, isError: true);
                }
              },
              builder: (ctx, state) {
                if (state is AdminProductsLoading)
                  return Center(
                      child:
                          CircularProgressIndicator(color: AdminColors.accent));
                if (state is AdminProductsLoaded) {
                  if (state.products.isEmpty) return _emptyState();
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
                    itemCount: state.products.length,
                    itemBuilder: (_, i) => _productCard(state.products[i]),
                  );
                }
                return _emptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Product Card ──────────────────────────────────────
  Widget _productCard(ProductItemModel p) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.adminBorder),
        boxShadow: [
          BoxShadow(
              color: AdminColors.accent.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r)),
            child: Container(
              width: 80.w,
              height: 90.h,
              color: AdminColors.accent.withOpacity(0.08),
              child: _imgWidget(p.imgUrl),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: context.adminTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 5.h),
                    Row(children: [
                      Text('\$${p.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: AdminColors.accent)),
                      SizedBox(width: 8.w),
                      Flexible(
                          child: StatusBadge(
                              label: p.category, color: AdminColors.info)),
                    ]),
                    if (p.description?.isNotEmpty == true) ...[
                      SizedBox(height: 5.h),
                      Text(p.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: context.adminTextSecondary)),
                    ],
                  ]),
            ),
          ),
          Column(children: [
            _ActionIconBtn(
                icon: Icons.edit_outlined,
                color: AdminColors.accent,
                onTap: () => _openDialog(p)),
            _ActionIconBtn(
                icon: Icons.delete_outline_rounded,
                color: AdminColors.danger,
                onTap: () => _confirmDelete(p.id)),
          ]),
          SizedBox(width: 4.w),
        ],
      ),
    );
  }

  Widget _imgWidget(String? url) {
    if (url == null || url.isEmpty) return _placeholder();
    if (!url.startsWith('http'))
      return Image.file(File(url),
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder());
    return Image.network(url,
        fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder());
  }

  Widget _placeholder() => Center(
      child: Icon(Icons.image_outlined,
          color: AdminColors.accent.withOpacity(0.4), size: 28.r));

  Widget _emptyState() => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.inventory_2_outlined,
            size: 56.r, color: context.adminTextSecondary),
        SizedBox(height: 12.h),
        Text('لا توجد منتجات بعد',
            style: TextStyle(
                fontSize: 15.sp,
                color: context.adminTextSecondary,
                fontWeight: FontWeight.w500)),
      ]));

  // ══════════════════════════════════════════════════════
  //  Add / Edit Dialog
  // ══════════════════════════════════════════════════════
  void _openDialog(ProductItemModel? existing) {
    final isEdit = existing != null;
    if (isEdit) {
      _nameCtrl.text = existing.name;
      _priceCtrl.text = existing.price.toString();
      _catCtrl.text = existing.category;
      _descCtrl.text = existing.description ?? '';
    }

    // ── variables منفصلة عشان StatefulBuilder يشتغل صح ──
    var imgSource = (existing?.imgUrl?.startsWith('http') ?? true)
        ? _ImgSource.url
        : _ImgSource.device;
    String? imgFilePath =
        imgSource == _ImgSource.device ? existing?.imgUrl : null;

    if (imgSource == _ImgSource.url) {
      _urlCtrl.text = isEdit ? (existing?.imgUrl ?? '') : '';
    } else {
      _urlCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final outerCtx = context;
          return Dialog(
            backgroundColor: outerCtx.adminCard,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'تعديل المنتج' : 'إضافة منتج',
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: outerCtx.adminTextPrimary),
                    ),
                    SizedBox(height: 20.h),
                    _field(_nameCtrl, 'اسم المنتج', Icons.inventory_2_outlined),
                    SizedBox(height: 12.h),
                    _field(_priceCtrl, 'السعر', Icons.attach_money_rounded,
                        type: TextInputType.number),
                    SizedBox(height: 12.h),
                    _field(_catCtrl, 'الفئة', Icons.category_outlined),
                    SizedBox(height: 12.h),
                    _field(_descCtrl, 'الوصف', Icons.description_outlined,
                        maxLines: 2),
                    SizedBox(height: 20.h),
                    Text('صورة المنتج',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: outerCtx.adminTextSecondary)),
                    SizedBox(height: 10.h),
                    // ── Toggle بين URL والجهاز ──
                    _SourceToggle(
                      selected: imgSource,
                      isDark: outerCtx.isDark,
                      onChanged: (s) => setS(() {
                        imgSource = s;
                        imgFilePath = null;
                        _urlCtrl.clear();
                      }),
                    ),
                    SizedBox(height: 14.h),
                    // ── URL field أو Device picker ──
                    if (imgSource == _ImgSource.url)
                      _field(_urlCtrl, 'رابط الصورة', Icons.link_rounded)
                    else
                      _DevicePicker(
                        filePath: imgFilePath,
                        isDark: outerCtx.isDark,
                        onPick: () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );

                          if (picked != null) {
                            final dir = await Directory.systemTemp.createTemp();
                            final newPath =
                                '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
                            final newFile =
                                await File(picked.path).copy(newPath);

                            setS(() => imgFilePath = newFile.path);
                          }
                        },
                        onRemove: () => setS(() => imgFilePath = null),
                      ),
                    SizedBox(height: 24.h),
                    Row(children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _clear();
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: outerCtx.adminTextSecondary),
                          child: const Text('إلغاء'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final resolvedImg = imgSource == _ImgSource.url
                                ? _urlCtrl.text
                                : imgFilePath ?? '';
                            final product = ProductItemModel(
                              id: existing?.id ??
                                  DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                              name: _nameCtrl.text,
                              price: double.tryParse(_priceCtrl.text) ?? 0,
                              category: _catCtrl.text,
                              description: _descCtrl.text,
                              imgUrl: resolvedImg,
                            );
                            if (isEdit) {
                              outerCtx
                                  .read<AdminProductsCubit>()
                                  .updateProduct(existing!.id, product);
                            } else {
                              outerCtx
                                  .read<AdminProductsCubit>()
                                  .addProduct(product);
                            }
                            Navigator.pop(ctx);
                            _clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdminColors.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                          child: Text(isEdit ? 'حفظ' : 'إضافة'),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {TextInputType type = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      style: TextStyle(color: context.adminTextPrimary, fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: context.adminTextSecondary, fontSize: 13.sp),
        prefixIcon: Icon(icon, color: AdminColors.accent, size: 18.r),
        filled: true,
        fillColor: context.isDark
            ? Colors.white.withOpacity(0.04)
            : AdminColors.accent.withOpacity(0.04),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: context.adminBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: context.adminBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AdminColors.accent, width: 1.5)),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: context.adminCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                    color: AdminColors.danger.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: Icon(Icons.delete_outline_rounded,
                    color: AdminColors.danger, size: 32.r)),
            SizedBox(height: 16.h),
            Text('حذف المنتج',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: context.adminTextPrimary)),
            SizedBox(height: 8.h),
            Text('هل تريد حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp, color: context.adminTextSecondary)),
            SizedBox(height: 20.h),
            Row(children: [
              Expanded(
                  child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('إلغاء',
                          style:
                              TextStyle(color: context.adminTextSecondary)))),
              SizedBox(width: 8.w),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  context.read<AdminProductsCubit>().deleteProduct(id);
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.danger,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r))),
                child: const Text('حذف'),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  void _clear() {
    for (final c in [_nameCtrl, _priceCtrl, _catCtrl, _descCtrl, _urlCtrl])
      c.clear();
  }

  void _snack(BuildContext ctx, String msg, {required bool isError}) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AdminColors.danger : AdminColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      margin: EdgeInsets.all(16.w),
    ));
  }
}

// ══════════════════════════════════════════════════════════
//  Source Toggle
// ══════════════════════════════════════════════════════════
class _SourceToggle extends StatelessWidget {
  final _ImgSource selected;
  final bool isDark;
  final ValueChanged<_ImgSource> onChanged;
  const _SourceToggle(
      {required this.selected, required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.adminBorder),
      ),
      child: Row(children: [
        _Opt(
            icon: Icons.link_rounded,
            label: 'رابط الإنترنت',
            active: selected == _ImgSource.url,
            onTap: () => onChanged(_ImgSource.url)),
        _Opt(
            icon: Icons.photo_library_outlined,
            label: 'من الجهاز',
            active: selected == _ImgSource.device,
            onTap: () => onChanged(_ImgSource.device)),
      ]),
    );
  }
}

class _Opt extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Opt(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            gradient: active
                ? LinearGradient(
                    colors: [AdminColors.accent, AdminColors.accentDark])
                : null,
            borderRadius: BorderRadius.circular(9.r),
            boxShadow: active
                ? [
                    BoxShadow(
                        color: AdminColors.accent.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ]
                : null,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon,
                size: 15.r,
                color: active ? Colors.white : context.adminTextSecondary),
            SizedBox(width: 6.w),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : context.adminTextSecondary)),
          ]),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Device Picker
// ══════════════════════════════════════════════════════════
class _DevicePicker extends StatelessWidget {
  final String? filePath;
  final bool isDark;
  final VoidCallback onPick, onRemove;
  const _DevicePicker(
      {required this.filePath,
      required this.isDark,
      required this.onPick,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final has = filePath != null;
    return GestureDetector(
      onTap: has ? null : onPick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: has ? 140.h : 100.h,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : AdminColors.accent.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: has
                  ? AdminColors.accent.withOpacity(0.5)
                  : context.adminBorder,
              width: has ? 1.5 : 1),
        ),
        child: has
            ? Stack(fit: StackFit.expand, children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: Image.file(File(filePath!), fit: BoxFit.cover)),
                Positioned(
                    top: 8,
                    right: 8,
                    child: Row(children: [
                      _ImgBtn(
                          icon: Icons.edit_rounded,
                          color: AdminColors.accent,
                          onTap: onPick),
                      SizedBox(width: 6.w),
                      _ImgBtn(
                          icon: Icons.close_rounded,
                          color: AdminColors.danger,
                          onTap: onRemove),
                    ])),
              ])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                        color: AdminColors.accent.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: Icon(Icons.add_photo_alternate_outlined,
                        color: AdminColors.accent, size: 24.r)),
                SizedBox(height: 8.h),
                Text('اضغط لاختيار صورة',
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.accent)),
                SizedBox(height: 3.h),
                Text('PNG, JPG, WEBP',
                    style: TextStyle(
                        fontSize: 10.sp, color: context.adminTextSecondary)),
              ]),
      ),
    );
  }
}

class _ImgBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ImgBtn({required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)
                ]),
            child: Icon(icon, color: Colors.white, size: 14.r)),
      );
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white30)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text('إضافة',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ]),
        ),
      );
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionIconBtn(
      {required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 17),
        ),
      );
}
