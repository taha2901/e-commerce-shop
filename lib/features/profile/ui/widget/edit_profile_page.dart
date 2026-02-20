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

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  String get _initials {
    final name = widget.user.username.trim();
    if (name.isEmpty) return '?';
    return name.split(' ').map((e) => e[0].toUpperCase()).take(2).join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: BlocProvider.of<UserCubit>(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Avatar Preview ──
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.65),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Fields ──
              LabelWithTextField(
                label: 'Username',
                controller: usernameController,
                prefixIcon: Iconsax.profile_2user,
                hintText: 'Enter your name',
              ),
              const SizedBox(height: 16),
              LabelWithTextField(
                label: 'Email',
                controller: emailController,
                prefixIcon: Iconsax.direct,
                hintText: 'Enter your email',
              ),

              const SizedBox(height: 36),

              // ── Save Button ──
              BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.white),
                            SizedBox(width: 8),
                            Text('تم تحديث البيانات بنجاح'),
                          ],
                        ),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is UserError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: theme.colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is UserUpdating;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<UserCubit>().updateUser(
                                    UserData(
                                      id: widget.user.id,
                                      username: usernameController.text,
                                      role: widget.user.role,
                                      email: emailController.text,
                                      createdAt: widget.user.createdAt,
                                    ),
                                  );
                            },
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(
                        isLoading ? 'جاري الحفظ...' : 'حفظ التغييرات',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}