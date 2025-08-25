import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // بيانات مؤقتة للأدمن
    final adminEmail = "admin@example.com";
    final adminName = "Admin User";

    // theme الحالي
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // صورة شخصية
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(Icons.person, size: 50, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),

            // اسم الأدمن
            Text(
              adminName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // ايميل الأدمن
            Text(
              adminEmail,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),

            const Divider(height: 40),

            // إعدادات / أزرار
            ListTile(
              leading: Icon(Icons.lock, color: theme.iconTheme.color),
              title: const Text("تغيير كلمة المرور"),
              onTap: () {
                // TODO: افتح صفحة تغيير الباسورد
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: theme.iconTheme.color),
              title: const Text("الإعدادات"),
              onTap: () {
                // TODO: افتح صفحة إعدادات الأدمن
              },
            ),

            const Spacer(),

            // زرار تسجيل الخروج
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text("تسجيل الخروج"),
              onPressed: () {
                context.read<AuthCubit>().logOut();
                Navigator.of(context).pushReplacementNamed(Routers.loginRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
