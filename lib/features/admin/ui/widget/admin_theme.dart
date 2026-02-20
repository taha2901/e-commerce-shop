// ═══════════════════════════════════════════════════════════
//  Admin Design System — Tokens & Shared Widgets
//  Uses Theme.of(context) everywhere → works in Light & Dark
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Color Tokens ───────────────────────────────────────────
class AdminColors {
  // Accent (same in both modes)
  static const accent = Color(0xFF7C6AF7);
  static const accentLight = Color(0xFFB0A7FF);
  static const accentDark = Color(0xFF5146C8);

  // Status
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFF87171);
  static const info = Color(0xFF60A5FA);

  // Card backgrounds
  static Color cardLight = const Color(0xFFF8F7FF);
  static Color cardDark = const Color(0xFF1E1B2E);

  // Surface
  static Color surfaceLight = const Color(0xFFFFFFFF);
  static Color surfaceDark = const Color(0xFF14111F);

  // Subtle border
  static Color borderLight = const Color(0xFFEAE8FF);
  static Color borderDark = const Color(0xFF2E2A45);
}

// ─── Theme Helper ────────────────────────────────────────────
extension AdminTheme on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get adminCard =>
      isDark ? AdminColors.cardDark : AdminColors.cardLight;

  Color get adminSurface =>
      isDark ? AdminColors.surfaceDark : AdminColors.surfaceLight;

  Color get adminBorder =>
      isDark ? AdminColors.borderDark : AdminColors.borderLight;

  Color get adminTextPrimary =>
      isDark ? Colors.white : const Color(0xFF1A1625);

  Color get adminTextSecondary =>
      isDark ? const Color(0xFF9B95B8) : const Color(0xFF6B6585);

  Color get adminDivider =>
      isDark ? const Color(0xFF2E2A45) : const Color(0xFFEAE8FF);
}

// ═══════════════════════════════════════════════════════════
//  AdminStatCard — used in Users & Products pages
// ═══════════════════════════════════════════════════════════
class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(context.isDark ? 0.15 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chip
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 18.r),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: context.adminTextPrimary,
              height: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: context.adminTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 10.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  AdminAppBar — consistent across all admin pages
// ═══════════════════════════════════════════════════════════
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final PreferredSizeWidget? bottom;

  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = false,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        bottom != null ? kToolbarHeight + bottom!.preferredSize.height : kToolbarHeight,
      );

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AppBar(
      automaticallyImplyLeading: showBack,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A1625), const Color(0xFF2D2450)]
                : [AdminColors.accent, AdminColors.accentDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
      bottom: bottom,
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  AdminSearchBar
// ═══════════════════════════════════════════════════════════
class AdminSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final Widget? trailing;

  const AdminSearchBar({
    super.key,
    required this.hint,
    this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.adminCard,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: context.adminBorder),
        boxShadow: [
          BoxShadow(
            color: AdminColors.accent.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(
                color: context.adminTextPrimary,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: context.adminTextSecondary,
                  fontSize: 13.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AdminColors.accent,
                  size: 20.r,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          if (trailing != null)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  StatusBadge
// ═══════════════════════════════════════════════════════════
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}