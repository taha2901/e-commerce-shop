// features/admin/ui/admin_users_page.dart
import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/features/admin/logic/users/users_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/users/users_states.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'العملاء'),
            Tab(text: 'التجار'),
          ],
        ),
      ),
      body: BlocBuilder<UserManagementCubit, UserManagementState>(
        builder: (context, state) {
          if (state is UserManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserManagementLoaded) {
            final allUsers = state.users;

            return Column(
              children: [
                /// الإحصائيات
                _buildStatsSection(allUsers),

                /// البحث + الفلترة
                _buildSearchAndFilter(),

                /// عرض القوائم بالتبويب
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUsersList(allUsers),
                      _buildUsersList(
                          allUsers.where((u) => u.role == 'user').toList()),
                      _buildUsersList(
                          allUsers.where((u) => u.role == 'vendor').toList()),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is UserManagementError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatsSection(List<UserData> users) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'إجمالي المستخدمين',
              value: '${users.length}',
              icon: Icons.people,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              title: 'العملاء',
              value: '${users.where((u) => u.role == "customer").length}',
              icon: Icons.person,
              color: Colors.green,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              title: 'التجار',
              value: '${users.where((u) => u.role == "vendor").length}',
              icon: Icons.store,
              color: Colors.orange,
            ),
          ),
        ],
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.r),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'البحث بالاسم أو البريد الإلكتروني...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Container(
          //   decoration: BoxDecoration(
          //     color: AppColors.primary,
          //     borderRadius: BorderRadius.circular(12.r),
          //   ),
          //   child: IconButton(
          //     onPressed: _showFilterDialog,
          //     icon: const Icon(Icons.tune, color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<UserData> users) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد مستخدمون',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user, index);
      },
    );
  }

  Widget _buildUserCard(UserData user, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            user.username[0],
            style: TextStyle(color: AppColors.primary),
          ),
        ),
        title: Text(user.username),
        subtitle: Text(user.email),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'delete') {
              context.read<UserManagementCubit>().deleteUser(user.id);
            } else if (value == 'view') {
              _showUserDetailsDialog(user);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Text('حذف'),
            ),
            const PopupMenuItem(
              value: 'view',
              child: Text('عرض التفاصيل'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetailsDialog(UserData user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("بيانات ${user.username}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("الاسم: ${user.username}"),
              Text("البريد: ${user.email}"),
              Text("Role: ${user.role}"),
              Text("تاريخ الإنشاء: ${user.createdAt}"),

              // if (user. != null) Text("الهاتف: ${user.phone}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // _showEditUserDialog(user);
              },
              child: const Text("تعديل"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إغلاق"),
            ),
          ],
        );
      },
    );
  }
}
