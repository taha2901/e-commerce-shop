import 'package:ecommerce_app/features/auth/ui/widget/login_customs/social_login_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/another_loging_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/forget_pass_button_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/logo_and_animition_section.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/no_account_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/welcom_text_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/custom_input_field_of_label_field.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/custom_main_button_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(40),
                const LogoAndAnimationSection(),
                verticalSpace(32),
                const WelcomeTextWidget(),
                verticalSpace(40),
                // Email Field
                CustomInputField(
                  label: 'البريد الإلكتروني',
                  controller: emailController,
                  prefixIcon: Icons.email_outlined,
                  hintText: 'أدخل بريدك الإلكتروني',
                ),
                verticalSpace(20),
                // Password Field
                CustomInputField(
                  label: 'كلمة المرور',
                  controller: passwordController,
                  prefixIcon: Icons.lock_outline,
                  hintText: 'أدخل كلمة المرور',
                  obscureText: isObscure,
                  suffix: IconButton(
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: theme.iconTheme.color,
                    ),
                    onPressed: () {
                      setState(() => isObscure = !isObscure);
                    },
                  ),
                ),
                verticalSpace(16),
                const ForgetPasswordButton(),
                verticalSpace(32),
                // Login Button
                BlocConsumer<AuthCubit, AuthState>(
                  listenWhen: (prev, curr) =>
                      curr is AuthSuccess || curr is AuthError,
                  listener: _loginListener,
                  buildWhen: (prev, curr) =>
                      curr is AuthLoading ||
                      curr is AuthError ||
                      curr is AuthSuccess,
                  builder: (context, state) {
                    return CustomMainButton(
                      text: 'تسجيل الدخول',
                      isLoading: state is AuthLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await cubit.loginWithEmailAndPassword(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                    );
                  },
                ),
                verticalSpace(32),
                const AnotherLogingWidget(),
                verticalSpace(23),
                SocialLoginRow(),
                verticalSpace(32),
                const NoAccountWidget(),
                verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginListener(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      final role = state.userData.role;
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, Routers.adminDashboardRoute);
      } else if (role == 'vendor') {
        Navigator.pushReplacementNamed(context, Routers.adminVendorRoute);
      } else {
        Navigator.pushReplacementNamed(context, Routers.homeRoute);
      }
    } else if (state is AuthError) {
      _showErrorSnackBar(context, state.message);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
