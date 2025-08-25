import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorDashboardPage extends StatelessWidget {
  const VendorDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        title: const Text('لوحة التاجر'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // تسجيل خروج التاجر
              context.read<AuthCubit>().logOut();
              Navigator.of(context).pushReplacementNamed(Routers.loginRoute);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 30.r,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أهلاً بالتاجر 👨‍🔧',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'إدارة متجرك بسهولة وفعالية',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Statistics Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'منتجاتي',
                    value: '24',
                    icon: Icons.inventory,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    title: 'الطلبات',
                    value: '18',
                    icon: Icons.shopping_bag,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'المبيعات',
                    value: '\$2,450',
                    icon: Icons.attach_money,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    title: 'التقييم',
                    value: '4.8',
                    icon: Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 32.h),
            
            // Main Features Grid
            Text(
              'إدارة المتجر',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1.1,
              children: [
                _buildDashboardCard(
                  context: context,
                  title: 'منتجاتي',
                  subtitle: 'إدارة وتعديل المنتجات',
                  icon: Icons.inventory,
                  color: Colors.blue,
                  onTap: () {
                    // Navigator.of(context).pushNamed(Routers.vendorProductsRoute);
                  },
                ),
                _buildDashboardCard(
                  context: context,
                  title: 'الطلبات',
                  subtitle: 'متابعة طلبات العملاء',
                  icon: Icons.shopping_bag,
                  color: Colors.green,
                  onTap: () {
                    // Navigator.of(context).pushNamed(Routers.vendorOrdersRoute);
                  },
                ),
                _buildDashboardCard(
                  context: context,
                  title: 'التقارير',
                  subtitle: 'إحصائيات المبيعات',
                  icon: Icons.analytics,
                  color: Colors.purple,
                  onTap: () {
                    // Navigator.of(context).pushNamed(Routers.vendorReportsRoute);
                  },
                ),
                _buildDashboardCard(
                  context: context,
                  title: 'الملف الشخصي',
                  subtitle: 'إعدادات المتجر',
                  icon: Icons.person,
                  color: Colors.orange,
                  onTap: () {
                    // Navigator.of(context).pushNamed(Routers.vendorProfileRoute);
                  },
                ),
              ],
            ),
            
            SizedBox(height: 32.h),
            
            // Quick Actions
            Text(
              'إجراءات سريعة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'إضافة منتج',
                    icon: Icons.add_box,
                    color: Colors.green,
                    onTap: () {
                      // Navigate to add product
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'عرض الطلبات الجديدة',
                    icon: Icons.notifications,
                    color: Colors.red,
                    onTap: () {
                      // Navigate to new orders
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 20.r,
              color: color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  icon,
                  size: 30.r,
                  color: color,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 24.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 16.r,
            ),
          ],
        ),
      ),
    );
  }
}