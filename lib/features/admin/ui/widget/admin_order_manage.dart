import 'package:ecommerce_app/features/admin/logic/order/order_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/order/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'admin_theme.dart';

class AdminOrderManagement extends StatefulWidget {
  const AdminOrderManagement({super.key});

  @override
  State<AdminOrderManagement> createState() => _AdminOrderManagementState();
}

class _AdminOrderManagementState extends State<AdminOrderManagement> {
  String _currentFilter = 'all';

  static const _filters = [
    ('all', 'الكل'),
  
  ];

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AdminAppBar(title: 'إدارة الطلبات'),
      body: Column(
        children: [
          // Search
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: AdminSearchBar(
              hint: 'ابحث برقم الطلب...',
              onChanged: (v) => context.read<OrdersCubit>().searchOrders(v),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 44.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: _filters.map((f) {
                final isActive = _currentFilter == f.$1;
                final color = _statusColor(f.$1);
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _currentFilter = f.$1);
                      context.read<OrdersCubit>().loadOrders(statusFilter: f.$1);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isActive
                            ? color.withOpacity(0.15)
                            : context.adminCard,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isActive ? color : context.adminBorder,
                          width: isActive ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        f.$2,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? color : context.adminTextSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 8.h),

          // Orders List
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return Center(child: CircularProgressIndicator(color: AdminColors.accent));
                } else if (state is OrdersError) {
                  return _buildErrorState(state.message);
                } else if (state is OrdersLoaded) {
                  return _buildOrdersList(state.orders);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 56.r, color: context.adminTextSecondary),
            SizedBox(height: 12.h),
            Text(
              'لا توجد طلبات',
              style: TextStyle(
                fontSize: 15.sp,
                color: context.adminTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
      itemCount: orders.length,
      itemBuilder: (_, i) => _buildOrderCard(orders[i]),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] as String?;
    final color = _statusColor(status);
    final statusLabel = _statusText(status);
    final orderId = order['order_id'] ?? order['id'] ?? '—';
    final total = order['total']?.toStringAsFixed(2) ?? '0.00';

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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.receipt_long_outlined, color: color, size: 18.r),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#$orderId',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: context.adminTextPrimary,
                        ),
                      ),
                      Text(
                        order['username'] ?? 'غير معروف',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: context.adminTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(label: statusLabel, color: color),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(color: context.adminDivider, height: 1),
            SizedBox(height: 12.h),
            // Info row
            Row(
              children: [
                _infoChip(Icons.shopping_cart_outlined, '${order['items_count'] ?? 0} عناصر'),
                SizedBox(width: 12.w),
                _infoChip(Icons.payments_outlined, '\$$total', color: AdminColors.accent),
              ],
            ),
            SizedBox(height: 12.h),
            // Actions
            Row(
              children: [
                Expanded(
                  child: _OutlinedBtn(
                    label: 'التفاصيل',
                    icon: Icons.visibility_outlined,
                    onTap: () => _showOrderDetails(order),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _FilledBtn(
                    label: 'تحديث الحالة',
                    icon: Icons.update_rounded,
                    onTap: () => _showUpdateStatusDialog(order),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.r, color: color ?? context.adminTextSecondary),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: color ?? context.adminTextSecondary,
            fontWeight: color != null ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48.r, color: AdminColors.danger),
          SizedBox(height: 12.h),
          Text(message, style: TextStyle(color: AdminColors.danger, fontSize: 14.sp)),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: context.adminCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل الطلب',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: context.adminTextPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '#${order['order_id'] ?? order['id']}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AdminColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Divider(color: context.adminDivider),
              SizedBox(height: 12.h),
              _detailRow('العميل', order['username'] ?? '—'),
              SizedBox(height: 8.h),
              _detailRow('الحالة', _statusText(order['status'])),
              SizedBox(height: 8.h),
              _detailRow('العناصر', '${order['items_count'] ?? 0}'),
              SizedBox(height: 8.h),
              _detailRow('المجموع', '\$${order['total']?.toStringAsFixed(2) ?? '0.00'}'),
              if (order['location'] != null) ...[
                SizedBox(height: 8.h),
                _detailRow('العنوان', order['location']['address'] ?? '—'),
              ],
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: const Text('إغلاق'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 13.sp,
              color: context.adminTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: context.adminTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showUpdateStatusDialog(Map<String, dynamic> order) {
    String selected = order['status'] ?? 'pending';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: context.adminCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تحديث الحالة',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: context.adminTextPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                ...['pending', 'processing', 'shipped', 'delivered'].map((s) {
                  final color = _statusColor(s);
                  final isSelected = selected == s;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selected = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.1)
                            : context.isDark
                                ? Colors.white.withOpacity(0.03)
                                : Colors.grey.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? color : context.adminBorder,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? color : context.adminTextSecondary,
                            size: 18.r,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            _statusText(s),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? color : context.adminTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('إلغاء',
                            style: TextStyle(color: context.adminTextSecondary)),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<OrdersCubit>().updateOrderStatus(order['id'], selected);
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: const Text('تحديث'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'pending': return AdminColors.warning;
      case 'processing': return AdminColors.info;
      case 'shipped': return AdminColors.accent;
      case 'delivered': return AdminColors.success;
      default: return AdminColors.info;
    }
  }

  String _statusText(String? status) {
    switch (status) {
      case 'pending': return 'قيد الانتظار';
      case 'processing': return 'قيد المعالجة';
      case 'shipped': return 'تم الشحن';
      case 'delivered': return 'تم التسليم';
      default: return 'غير محدد';
    }
  }
}

// ─── Button helpers ───────────────────────────────────────
class _OutlinedBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlinedBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.adminTextPrimary,
        side: BorderSide(color: context.adminBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

class _FilledBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _FilledBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AdminColors.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}