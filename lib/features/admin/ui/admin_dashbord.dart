import 'package:ecommerce_app/features/admin/ui/widget/admin_order_manage.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_product.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_profile_page.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_theme.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_user_managment.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminProductsPage(),
    const AdminOrderManagement(),
    const AdminUsersPage(),
    const AdminProfilePage(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2_rounded, label: "المنتجات"),
    _NavItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag_rounded, label: "الطلبات"),
    _NavItem(icon: Icons.people_outline_rounded, activeIcon: Icons.people_rounded, label: "المستخدمين"),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: "الملف"),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AdminColors.surfaceDark : const Color(0xFFF4F2FF),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AdminColors.cardDark : Colors.white,
          border: Border(
            top: BorderSide(color: context.adminBorder, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: AdminColors.accent.withOpacity(isDark ? 0.2 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isActive = _currentIndex == i;

                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AdminColors.accent.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            key: ValueKey(isActive),
                            color: isActive
                                ? AdminColors.accent
                                : context.adminTextSecondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive
                                ? AdminColors.accent
                                : context.adminTextSecondary,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}