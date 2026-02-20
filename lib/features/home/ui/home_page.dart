import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/widget/custom_app_bar.dart';
import 'package:ecommerce_app/features/home/logic/category_cubit/category_cubit.dart';
import 'package:ecommerce_app/features/home/logic/home_cubit/home_cubit.dart';
import 'package:ecommerce_app/features/home/ui/widget/home/category_tab_view.dart';
import 'package:ecommerce_app/features/home/ui/widget/home/home_tab_view.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// ✅ Custom Header
            const CustomHomeHeader(),

            /// ✅ Tabs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TabBar(
                controller: _tabController,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                labelStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
                tabs: [
                  Tab(text: LocaleKeys.home.tr()),
                  Tab(text: LocaleKeys.category.tr()),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            /// ✅ Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BlocProvider(
                    create: (context) => HomeCubit()..getHomeData(),
                    child: const HomeTabView(),
                  ),
                  BlocProvider(
                    create: (context) => CategoryCubit()..getCategory(),
                    child: const CategoryTabView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
