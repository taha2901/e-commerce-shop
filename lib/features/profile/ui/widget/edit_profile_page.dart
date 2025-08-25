import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/label_with_text_field.dart';
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_cubit.dart';
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class EditProfilePage extends StatefulWidget {
  final UserData user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: BlocProvider.of<UserCubit>(context),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            title: const Text('Edit Profile'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.5),
              child: Container(
                color: theme.dividerColor, // يدعم Light/Dark theme
                height: 1.5,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(children: [
              verticalSpace(20),
              verticalSpace(20),
              LabelWithTextField(
                label: 'Username',
                controller: usernameController,
                prefixIcon: Iconsax.profile_2user,
                hintText: 'Enter your name',
              ),
              verticalSpace(10),
              LabelWithTextField(
                label: 'Email',
                controller: emailController,
                prefixIcon: Iconsax.direct,
                hintText: 'Enter your email',
              ),
              verticalSpace(30),
              BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('تم تحديث البيانات بنجاح')));
                    Navigator.pop(context);
                  } else if (state is UserError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  final isLoading = state is UserUpdating;
                  return ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            final updatedUser = UserData(
                              id: widget.user.id,
                              username: usernameController.text,
                              role: widget.user.role,
                              email: emailController.text,
                              createdAt: widget.user.createdAt,
                            );
                            context.read<UserCubit>().updateUser(updatedUser);
                          },
                    icon: const Icon(Icons.save),
                    label: Text(isLoading ? 'جاري الحفظ...' : 'حفظ التغييرات'),
                  );
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
