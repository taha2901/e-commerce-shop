import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:ecommerce_app/core/routings/app_router.dart';
import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/core/services/admin_manage_users_services.dart';
import 'package:ecommerce_app/core/services/admin_product_services.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/core/utils/api_key.dart';
import 'package:ecommerce_app/features/admin/logic/order/order_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/product/product_cubit.dart';
import 'package:ecommerce_app/features/admin/logic/users/users_cubit.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:ecommerce_app/features/cart/logic/cart/cart_cubit.dart';
import 'package:ecommerce_app/features/checkout_payment/data/repos/checkout_repo_impl.dart';
import 'package:ecommerce_app/features/checkout_payment/presentation/manger/payment_cubit.dart';
import 'package:ecommerce_app/features/favourite/logic/cubit/favourite_cubit.dart';
import 'package:ecommerce_app/features/home/logic/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app/features/location_picker/logic/location_cubit.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => child!,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PaymenttCubit(CheckoutRepoImpl())),
          BlocProvider<LocationCubit>(create: (_) => LocationCubit()),
          BlocProvider(create: (_) => AuthCubit()..checkAuth()),
          BlocProvider(create: (_) => HomeCubit()..getHomeData()),
          BlocProvider(create: (_) => FavouriteCubit()..getFavoriteProducts()),
          BlocProvider(create: (_) => CartCubit()..getCartItems()),
          BlocProvider(create: (_) => OrdersCubit(FirestoreServices.instance)),
          BlocProvider(
            create: (_) =>
                AdminProductsCubit(AdminServicesImpl())..fetchAllProducts(),
          ),
          BlocProvider(
            create: (_) =>
                UserManagementCubit(ManagementUsersServicesImpl())
                  ..fetchAllUsers(),
          ),
        ],
        child: _AppView(appRouter: appRouter),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  final AppRouter appRouter;
  const _AppView({required this.appRouter});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      buildWhen: (prev, curr) => curr is AuthSuccess || curr is AuthInitial,
      builder: (context, state) {
        String initialRoute = Routers.loginRoute;
        if (state is AuthSuccess) {
          final role = state.userData.role;
          if (role == 'admin') {
            initialRoute = Routers.adminDashboardRoute;
          } else if (role == 'vendor') {
            initialRoute = Routers.adminVendorRoute;
          } else {
            initialRoute = Routers.homeRoute;
          }
        }

        return AdaptiveTheme(
          light: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          dark: ThemeData.dark(),
          initial: AdaptiveThemeMode.system,
          builder: (theme, darkTheme) => MaterialApp(
            // ✅ مهم جداً لـ DevicePreview
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),

            // ✅ الحل الرئيسي لمشكلة الـ keyboard
            // بدل ما نستخدم DevicePreview.appBuilder مباشرة
            // بنعمل custom builder يحافظ على الـ viewInsets الصح
            builder: (context, child) {
              // ✅ نجيب الـ mediaQuery من الـ context الحالي
              final mediaQuery = MediaQuery.of(context);

              return DevicePreview.appBuilder(
                context,
                // ✅ بنلف الـ child في MediaQuery جديد
                // عشان الـ keyboard viewInsets تتنقل صح للـ child
                MediaQuery(
                  data: mediaQuery.copyWith(
                    // ✅ ده اللي بيحل المشكلة:
                    // بيخلي الـ viewInsets (اللي هو الـ keyboard)
                    // يتمرر صح للـ widget tree جوا الـ DevicePreview
                    viewInsets: mediaQuery.viewInsets,
                    viewPadding: mediaQuery.viewPadding,
                    padding: mediaQuery.padding,
                  ),
                  child: child!,
                ),
              );
            },

            navigatorKey: ApiKeys().navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            debugShowCheckedModeBanner: false,
            title: 'E-commerce App',
            theme: theme,
            darkTheme: darkTheme,
            initialRoute: initialRoute,
            onGenerateRoute: appRouter.generateRoute,
          ),
        );
      },
    );
  }
}