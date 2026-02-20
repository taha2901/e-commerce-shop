import 'package:ecommerce_app/features/admin/logic/users/users_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/users/users_states.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'admin_theme.dart';

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
      backgroundColor: Colors.transparent,
      appBar: AdminAppBar(
        title: 'إدارة المستخدمين',
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
          unselectedLabelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
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
            return Center(
              child: CircularProgressIndicator(color: AdminColors.accent),
            );
          } else if (state is UserManagementLoaded) {
            final allUsers = state.users;
            final customers = allUsers.where((u) => u.role == 'user').toList();
            final vendors = allUsers.where((u) => u.role == 'vendor').toList();

            return Column(
              children: [
                _buildStatsSection(allUsers, customers, vendors),
                _buildSearchBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUsersList(allUsers),
                      _buildUsersList(customers),
                      _buildUsersList(vendors),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is UserManagementError) {
            return _buildErrorState(state.message);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatsSection(
    List<UserData> all,
    List<UserData> customers,
    List<UserData> vendors,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: AdminStatCard(
              title: 'المستخدمين',
              value: '${all.length}',
              icon: Icons.people_rounded,
              color: AdminColors.accent,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: AdminStatCard(
              title: 'العملاء',
              value: '${customers.length}',
              icon: Icons.person_rounded,
              color: AdminColors.success,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: AdminStatCard(
              title: 'التجار',
              value: '${vendors.length}',
              icon: Icons.storefront_rounded,
              color: AdminColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: AdminSearchBar(
        hint: 'البحث بالاسم أو البريد الإلكتروني...',
      ),
    );
  }

  Widget _buildUsersList(List<UserData> users) {
    if (users.isEmpty) {
      return _buildEmptyState('لا يوجد مستخدمون', Icons.people_outline_rounded);
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: users.length,
      itemBuilder: (context, index) => _buildUserCard(users[index]),
    );
  }

  Widget _buildUserCard(UserData user) {
    final isVendor = user.role == 'vendor';
    final roleColor = isVendor ? AdminColors.warning : AdminColors.info;
    final roleLabel = isVendor ? 'تاجر' : 'عميل';
    final initial = user.username.isNotEmpty ? user.username[0].toUpperCase() : '?';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: context.adminBorder),
        boxShadow: [
          BoxShadow(
            color: AdminColors.accent.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        leading: Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AdminColors.accent, AdminColors.accentDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                user.username,
                style: TextStyle(
                  color: context.adminTextPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            StatusBadge(label: roleLabel, color: roleColor),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Text(
            user.email,
            style: TextStyle(
              color: context.adminTextSecondary,
              fontSize: 12.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert_rounded, color: context.adminTextSecondary, size: 20.r),
          color: context.adminCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'view',
              child: _popupItem(Icons.visibility_outlined, 'عرض التفاصيل', context.adminTextPrimary),
            ),
            PopupMenuItem(
              value: 'delete',
              child: _popupItem(Icons.delete_outline_rounded, 'حذف', AdminColors.danger),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              context.read<UserManagementCubit>().deleteUser(user.id);
            } else if (value == 'view') {
              _showUserDetailsDialog(user);
            }
          },
        ),
      ),
    );
  }

  Widget _popupItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56.r, color: context.adminTextSecondary),
          SizedBox(height: 12.h),
          Text(
            message,
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

  void _showUserDetailsDialog(UserData user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.adminCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AdminColors.accent, AdminColors.accentDark],
                  ),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  user.username[0].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                user.username,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: context.adminTextPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              Divider(color: context.adminDivider),
              SizedBox(height: 12.h),
              _detailRow(Icons.email_outlined, 'البريد', user.email),
              SizedBox(height: 10.h),
              _detailRow(Icons.badge_outlined, 'الدور', user.role),
              SizedBox(height: 10.h),
              _detailRow(Icons.calendar_today_outlined, 'تاريخ الإنشاء', '${user.createdAt}'),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: context.adminTextSecondary,
                      ),
                      child: const Text('إغلاق'),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const Text('تعديل'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: AdminColors.accent),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            color: context.adminTextSecondary,
            fontWeight: FontWeight.w600,
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}