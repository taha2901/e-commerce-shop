import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'admin_theme.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const adminEmail = "tahahamada2901@gmail.com";
    const adminName = "Admin User";

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AdminAppBar(title: 'الملف الشخصي'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 8.h),

            // ── Profile Card ─────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: context.adminCard,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.adminBorder),
                boxShadow: [
                  BoxShadow(
                    color: AdminColors.accent.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar with gradient ring
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AdminColors.accent, AdminColors.accentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 80.r,
                      height: 80.r,
                      decoration: BoxDecoration(
                        color: context.adminCard,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w800,
                          color: AdminColors.accent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    adminName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: context.adminTextPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    adminEmail,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: context.adminTextSecondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  StatusBadge(label: 'مدير النظام', color: AdminColors.accent),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ── Settings Section ──────────────────────────
            _SectionHeader(title: 'الإعدادات'),
            SizedBox(height: 10.h),

            _SettingsItem(
              icon: Icons.lock_outline_rounded,
              label: 'تغيير كلمة المرور',
              color: AdminColors.info,
              onTap: () {},
            ),
            SizedBox(height: 8.h),
            _SettingsItem(
              icon: Icons.tune_rounded,
              label: 'إعدادات النظام',
              color: AdminColors.accent,
              onTap: () {},
            ),
            SizedBox(height: 8.h),
            _SettingsItem(
              icon: Icons.notifications_outlined,
              label: 'الإشعارات',
              color: AdminColors.warning,
              onTap: () {},
            ),

            SizedBox(height: 20.h),
            _SectionHeader(title: 'الحساب'),
            SizedBox(height: 10.h),

            _SettingsItem(
              icon: Icons.help_outline_rounded,
              label: 'المساعدة والدعم',
              color: AdminColors.success,
              onTap: () {},
            ),
            SizedBox(height: 8.h),
            _SettingsItem(
              icon: Icons.info_outline_rounded,
              label: 'عن التطبيق',
              color: AdminColors.info,
              onTap: () {},
            ),

            SizedBox(height: 28.h),

            // ── Logout Button ─────────────────────────────
            GestureDetector(
              onTap: () {
                context.read<AuthCubit>().logOut();
                Navigator.of(context).pushReplacementNamed(Routers.loginRoute);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: AdminColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AdminColors.danger.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: AdminColors.danger, size: 20.r),
                    SizedBox(width: 8.w),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AdminColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: context.adminTextSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: context.adminCard,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: context.adminBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 18.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: context.adminTextPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.adminTextSecondary,
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }
}