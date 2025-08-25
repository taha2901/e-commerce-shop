import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_cubit.dart';
import 'package:ecommerce_app/features/profile/ui/widget/edit_profile_page.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyButtons extends StatelessWidget {
  const ModifyButtons({
    super.key,
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          LocaleKeys.edit_profile.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, // متوافق مع Light/Dark
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<UserCubit>(),
                child: EditProfilePage(user: user),
              ),
            ),
          );
        },
      ),
    );
  }
}
