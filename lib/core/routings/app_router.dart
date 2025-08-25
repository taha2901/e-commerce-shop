import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/core/widget/cutome_bottom_nav_bar.dart';
// ignore: unused_import
import 'package:ecommerce_app/features/admin/logic/order/order_state.dart';
import 'package:ecommerce_app/features/admin/ui/admin_dashbord.dart';
import 'package:ecommerce_app/features/auth/ui/register_page.dart';
import 'package:ecommerce_app/features/cart/ui/cart_page.dart';
import 'package:ecommerce_app/features/home/logic/products_details_cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/home/ui/product_details_page.dart';
import 'package:ecommerce_app/features/profile/ui/user_profile.dart';
import 'package:ecommerce_app/features/vendor/vendor_dashbord.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/ui/login_page.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routers.homeRoute:
        return MaterialPageRoute(
          builder: (_) => const CustomBottomNavbar(),
          settings: settings,
        );

      case Routers.loginRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case Routers.registerRoute:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );

      case Routers.productDetailsRoute:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ProductDetailsCubit()..getProductDetails(productId),
            child: ProductDetailsPage(
              productId: productId,
            ),
          ),
          settings: settings,
        );
      case Routers.adminDashboardRoute:
        return MaterialPageRoute(
          builder: (_) => AdminHomePage(),
          settings: settings,
        );

      case Routers.adminVendorRoute:
        return MaterialPageRoute(
          builder: (_) => VendorDashboardPage(),
          settings: settings,
        );

      case Routers.userProfileRoute:
        return MaterialPageRoute(
          builder: (_) => const UserProfilePage(),
          settings: settings,
        );

      case Routers.editProfileRoute:
        return MaterialPageRoute(
          builder: (_) => Container(),
          settings: settings,
        );

      case Routers.cartRoute:
        return MaterialPageRoute(
          builder: (_) => CartPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error Page')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
