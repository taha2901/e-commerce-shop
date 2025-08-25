import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
//
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
//
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_cubit.dart';
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_states.dart';
import 'package:ecommerce_app/features/profile/ui/widget/identify_user_widget.dart';
import 'package:ecommerce_app/features/profile/ui/widget/modify_button.dart';
import 'package:ecommerce_app/features/profile/ui/widget/photo_of_user.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return BlocProvider(
      create: (context) => UserCubit()..getUserData(),
      child: Scaffold(
        backgroundColor: t.colorScheme.surface, // يشتغل مع الداكن والفاتح
        appBar: AppBar(
          title: Text(
            LocaleKeys.profile.tr(),
            style: t.textTheme.titleMedium,
          ),
          centerTitle: true,
          backgroundColor: t.colorScheme.surface,
          elevation: 0,
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const PhotoOfUser(),
                    verticalSpace(16),
                    IdentifyUserWidget(user: user),
                    verticalSpace(24),
                    ModifyButtons(user: user),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
