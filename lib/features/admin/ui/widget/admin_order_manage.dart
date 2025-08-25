import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/features/admin/logic/order/order_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/order/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOrderManagement extends StatefulWidget {
  const AdminOrderManagement({Key? key}) : super(key: key);

  @override
  State<AdminOrderManagement> createState() => _AdminOrderManagementState();
}

class _AdminOrderManagementState extends State<AdminOrderManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    // تحميل البيانات الأولية
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلبات'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث برقم الطلب...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onChanged: (value) {
                context.read<OrdersCubit>().searchOrders(value);
              },
            ),
          ),

          // عوامل التصفية
          SizedBox(
            height: 50.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildFilterChip('الكل', 'all'),
                SizedBox(width: 8.w),
                _buildFilterChip('قيد الانتظار', 'pending'),
                SizedBox(width: 8.w),
                _buildFilterChip('قيد المعالجة', 'processing'),
                SizedBox(width: 8.w),
                _buildFilterChip('تم الشحن', 'shipped'),
                SizedBox(width: 8.w),
                _buildFilterChip('تم التسليم', 'delivered'),
              ],
            ),
          ),

          // قائمة الطلبات
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is OrdersError) {
                  return Center(child: Text(state.message));
                } else if (state is OrdersLoaded) {
                  return _buildOrdersList(state.orders);
                }
                return const Center(child: Text('لا توجد بيانات'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _currentFilter == value,
      onSelected: (selected) {
        setState(() {
          _currentFilter = value;
        });
        context.read<OrdersCubit>().loadOrders(statusFilter: value);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: _currentFilter == value ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 60.r,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد طلبات',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  order['order_id'] ?? order['id'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _getStatusText(order['status']),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _getStatusColor(order['status']),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text('العميل: ${order['username'] ?? 'غير معروف'}'),
            SizedBox(height: 4.h),
            Text('العناصر: ${order['items_count'] ?? 0}'),
            SizedBox(height: 4.h),
            Text('المجموع: \$${order['total']?.toStringAsFixed(2) ?? '0.00'}'),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showOrderDetails(order),
                    child: const Text('التفاصيل'),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showUpdateStatusDialog(order),
                    child: const Text('تحديث الحالة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'processing':
        return 'قيد المعالجة';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التسليم';
      default:
        return 'غير محدد';
    }
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب ${order['order_id'] ?? order['id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('العميل:', order['username'] ?? 'غير معروف'),
              _buildDetailRow('رقم الطلب:', order['order_id'] ?? order['id']),
              _buildDetailRow('الحالة:', _getStatusText(order['status'])),
              _buildDetailRow('العناصر:', '${order['items_count'] ?? 0}'),
              _buildDetailRow('المجموع:', '\$${order['total']?.toStringAsFixed(2) ?? '0.00'}'),
              if (order['location'] != null)
                _buildDetailRow('العنوان:', order['location']['address'] ?? 'لا يوجد عنوان'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(Map<String, dynamic> order) {
    String selectedStatus = order['status'] ?? 'pending';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('تحديث حالة الطلب ${order['order_id'] ?? order['id']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('قيد الانتظار'),
                value: 'pending',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('قيد المعالجة'),
                value: 'processing',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('تم الشحن'),
                value: 'shipped',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('تم التسليم'),
                value: 'delivered',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<OrdersCubit>().updateOrderStatus(order['id'], selectedStatus);
                Navigator.pop(context);
              },
              child: const Text('تحديث'),
            ),
          ],
        ),
      ),
    );
  }
}