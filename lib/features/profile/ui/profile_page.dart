import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easy_localization/easy_localization.dart';
//
import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/core/widget/custom_app_bar.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:ecommerce_app/features/profile/ui/widget/language_dialouge.dart';
import 'package:ecommerce_app/features/profile/ui/widget/logout_button_widget.dart';
import 'package:ecommerce_app/features/profile/ui/widget/change_password.dart';
import 'package:ecommerce_app/features/profile/ui/widget/setting_item.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomHomeHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    verticalSpace(40),

                    // 🟢 Edit profile
                    SettingItem(
                      color: t.colorScheme.primary,
                      icon: Iconsax.profile_2user,
                      title: LocaleKeys.edit_profile.tr(),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(Routers.userProfileRoute);
                      },
                    ),

                    verticalSpace(12),

                    // 🟢 Change password
                    SettingItem(
                      color: Colors.orange,
                      icon: Iconsax.password_check4,
                      title: LocaleKeys.change_password.tr(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),

                    verticalSpace(12),

                    // 🟢 Notifications
                    SettingItem(
                      color: Colors.blue,
                      icon: Iconsax.notification,
                      title: LocaleKeys.notifications.tr(),
                      onTap: () {},
                    ),

                    verticalSpace(12),

                    // 🟢 Toggle Theme
                    SettingItem(
                      color: Colors.purple,
                      icon: Iconsax.moon,
                      title: "Toggle Theme",
                      onTap: () async {
                        AdaptiveTheme.of(context).toggleThemeMode();
                      },
                    ),

                    verticalSpace(12),

                    // 🟢 Security
                    SettingItem(
                      color: Colors.red,
                      icon: Iconsax.security_safe4,
                      title: LocaleKeys.security_guards.tr(),
                      onTap: () {},
                    ),

                    verticalSpace(12),

                    // 🟢 Language
                    SettingItem(
                      color: Colors.teal,
                      icon: Iconsax.language_circle4,
                      title: LocaleKeys.language.tr(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const LanguageDialog(),
                        );
                        debugPrint('Language Dialog Opened ${context.locale}');
                      },
                    ),

                    verticalSpace(12),

                    // 🟢 Logout
                    LogoutButtonWidget(cubit: cubit),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
