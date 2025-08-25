import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/features/cart/ui/widget/main_button.dart';
import 'package:ecommerce_app/features/profile/logic/change_password_cubit/change_pass_cubit.dart';
import 'package:ecommerce_app/features/profile/logic/change_password_cubit/change_pass_state.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: Scaffold(
        appBar: AppBar(title:  Text(LocaleKeys.change_password.tr())),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully')),
                );
                Navigator.pop(context);
              } else if (state is ChangePasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<ChangePasswordCubit>();
              return Column(
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      labelText: LocaleKeys.currentPassword.tr(),
                      prefixIcon: Icon(Iconsax.lock),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      labelText: LocaleKeys.new_password.tr(),
                      prefixIcon: Icon(Iconsax.lock_1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      labelText:  LocaleKeys.confirm_password.tr(),
                      prefixIcon: Icon(Iconsax.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  MainButton(
                    isLoading: state is ChangePasswordLoading,
                    onTap: () {
                      cubit.changePassword(
                        currentPasswordController.text.trim(),
                        newPasswordController.text.trim(),
                        confirmPasswordController.text.trim(),
                      );
                    },
                    text:  LocaleKeys.change_password.tr(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
