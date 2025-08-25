import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_order_manage.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_product.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_profile_page.dart';
import 'package:ecommerce_app/features/admin/ui/widget/admin_user_managment.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

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

  final List<String> _titles = [
    "إدارة المنتجات",
    "إدارة الطلبات",
    "إدارة المستخدمين",
    "البروفايل"
  ];

  @override
  Widget build(BuildContext context) {
    // جلب theme الحالي
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // يتغير تلقائي مع الداكن/الفاتح
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
