import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:ecommerce_app/features/profile/ui/widget/language_dialouge.dart';
import 'package:ecommerce_app/features/profile/ui/widget/logout_button_widget.dart';
import 'package:ecommerce_app/features/profile/ui/widget/change_password.dart';
import 'package:ecommerce_app/features/profile/ui/widget/setting_item.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final t = Theme.of(context);

    // اسم اليوزر من AuthCubit لو موجود
    final username = cubit.user?.username ?? 'User';
    final email = cubit.user?.email ?? '';
    final initials = username.trim().split(' ')
        .map((e) => e[0].toUpperCase())
        .take(2)
        .join();

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──
          SliverAppBar(
            expandedHeight: 220.h,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: t.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      t.colorScheme.primary,
                      t.colorScheme.primary.withOpacity(0.72),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      verticalSpace(16),

                      // ── Avatar ──
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.55),
                            width: 2.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(10),

                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (email.isNotEmpty) ...[
                        verticalSpace(4),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.78),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
          ),

          // ── Settings Body ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Group: Account ──
                  _SectionLabel(label: 'Account'),
                  verticalSpace(10),

                  SettingItem(
                    color: t.colorScheme.primary,
                    icon: Iconsax.profile_2user,
                    title: LocaleKeys.edit_profile.tr(),
                    subtitle: 'Manage your personal info',
                    onTap: () => Navigator.of(context, rootNavigator: true)
                        .pushNamed(Routers.userProfileRoute),
                  ),
                  verticalSpace(8),

                  SettingItem(
                    color: Colors.orange,
                    icon: Iconsax.password_check4,
                    title: LocaleKeys.change_password.tr(),
                    subtitle: 'Update your password',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ChangePasswordPage()),
                    ),
                  ),
                  verticalSpace(8),

                  SettingItem(
                    color: Colors.red.shade400,
                    icon: Iconsax.security_safe4,
                    title: LocaleKeys.security_guards.tr(),
                    subtitle: 'Privacy & security settings',
                    onTap: () {},
                  ),

                  verticalSpace(20),

                  // ── Group: Preferences ──
                  _SectionLabel(label: 'Preferences'),
                  verticalSpace(10),

                  SettingItem(
                    color: Colors.blue,
                    icon: Iconsax.notification,
                    title: LocaleKeys.notifications.tr(),
                    subtitle: 'Manage push notifications',
                    onTap: () {},
                  ),
                  verticalSpace(8),

                  // ── Dark Mode Toggle ──
                  _ThemeToggleItem(t: t),
                  verticalSpace(8),

                  SettingItem(
                    color: Colors.teal,
                    icon: Iconsax.language_circle4,
                    title: LocaleKeys.language.tr(),
                    subtitle: context.locale.languageCode == 'ar'
                        ? 'العربية'
                        : 'English',
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => const LanguageDialog(),
                    ),
                  ),

                  verticalSpace(28),

                  // ── Logout ──
                  LogoutButtonWidget(cubit: cubit),

                  verticalSpace(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ──
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: t.textTheme.labelSmall?.copyWith(
          color: t.hintColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

// ── Theme Toggle with Switch ──
class _ThemeToggleItem extends StatelessWidget {
  final ThemeData t;
  const _ThemeToggleItem({required this.t});

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode.isDark;

    return Material(
      color: Colors.transparent,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: t.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.colorScheme.outline.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: t.shadowColor.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDark ? Iconsax.moon5 : Iconsax.sun_1,
                color: Colors.purple,
                size: 20,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dark Mode',
                    style: t.textTheme.bodyLarge?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isDark ? 'Dark theme is on' : 'Light theme is on',
                    style: t.textTheme.labelSmall?.copyWith(
                      color: t.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: isDark,
              activeColor: Colors.purple,
              onChanged: (_) => AdaptiveTheme.of(context).toggleThemeMode(),
            ),
          ],
        ),
      ),
    );
  }
}