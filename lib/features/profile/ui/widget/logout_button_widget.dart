import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/ui/login_page.dart';
import 'package:ecommerce_app/features/cart/ui/widget/main_button.dart';
import 'package:ecommerce_app/features/profile/ui/widget/setting_item.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class LogoutButtonWidget extends StatelessWidget {
  final AuthCubit cubit;

  const LogoutButtonWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthLogedout || current is AuthLogoutError,
      listener: (context, state) {
        if (state is AuthLogedout) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else if (state is AuthLogoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      buildWhen: (previous, current) => current is AuthLogingout,
      builder: (context, state) {
        if (state is AuthLogingout) {
          return MainButton(isLoading: true, onTap: null);
        }
        return SettingItem(
          color: theme.colorScheme.error, // متوافق مع Light/Dark
          icon: Iconsax.logout,
          title: LocaleKeys.logout.tr(),
          onTap: () async => await cubit.logOut(),
        );
      },
    );
  }
}
