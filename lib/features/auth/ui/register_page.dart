import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/ui/widget/register_customs/another_logger.dart';
import 'package:ecommerce_app/features/auth/ui/widget/register_customs/back_button_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/register_customs/having_account_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/register_customs/header_circle_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/register_customs/pass_strength_indicator.dart';
import 'package:ecommerce_app/features/auth/ui/widget/register_customs/social_register_row.dart';
import 'package:ecommerce_app/features/auth/ui/widget/register_customs/title_and_subtitle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routings/routers.dart';
import '../../../core/utils/app_colors.dart';
import '../../cart/ui/widget/main_button.dart';
import 'widget/login_customs/label_with_text_field.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool agreeToTerms = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
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
                verticalSpace(30),
                const BackButtonWidget(),
                verticalSpace(24),
                const HeaderCircleWidget(),
                verticalSpace(24),
                const TitleAndSubtitleWidget(),
                verticalSpace(32),
                LabelWithTextField(
                  label: 'اسم المستخدم',
                  controller: usernameController,
                  prefixIcon: Icons.person_outline,
                  hintText: 'أدخل اسم المستخدم',
                  // fillColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  // textColor: theme.textTheme.bodyLarge!.color!,
                ),
                verticalSpace(20),
                LabelWithTextField(
                  label: 'البريد الإلكتروني',
                  controller: emailController,
                  prefixIcon: Icons.email_outlined,
                  hintText: 'أدخل بريدك الإلكتروني',
                  // fillColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  // textColor: theme.textTheme.bodyLarge!.color!,
                ),
                verticalSpace(20),
                LabelWithTextField(
                  label: 'كلمة المرور',
                  controller: passwordController,
                  prefixIcon: Icons.lock_outline,
                  hintText: 'أدخل كلمة مرور قوية',
                  obsecureText: isObscure,
                  suffixIcon: IconButton(
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
                  // fillColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  // textColor: theme.textTheme.bodyLarge!.color!,
                ),
                verticalSpace(20),
                PasswordStrengthIndicator(passwordController: passwordController),
                verticalSpace(24),
                TermsCheckbox(
                  agreeToTerms: agreeToTerms,
                  onChanged: (value) => setState(() {
                    agreeToTerms = value;
                  }),
                ),
                verticalSpace(32),
                BlocConsumer<AuthCubit, AuthState>(
                  bloc: cubit,
                  listenWhen: (previous, current) =>
                      current is AuthError || current is AuthSuccess,
                  buildWhen: (previous, current) =>
                      current is AuthSuccess ||
                      current is AuthLoading ||
                      current is AuthError,
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      final role = state.userData.role;
                      if (role == 'admin') {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(Routers.adminDashboardRoute);
                      } else if (role == 'vendor') {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(Routers.adminVendorRoute);
                      } else {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(Routers.homeRoute);
                      }
                    } else if (state is AuthError) {
                      _showErrorSnackBar(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    final gradientColors = agreeToTerms
                        ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
                        : isDark
                            ? [Colors.grey[700]!, Colors.grey[600]!]
                            : [Colors.grey.shade300, Colors.grey.shade400];

                    return Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: agreeToTerms
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),
                      child: MainButton(
                        text: 'إنشاء الحساب',
                        isLoading: state is AuthLoading,
                        onTap: agreeToTerms
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  await cubit.registerWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text,
                                    usernameController.text,
                                  );
                                }
                              }
                            : null,
                      ),
                    );
                  },
                ),
                verticalSpace(24),
                const AnotherLogger(),
                verticalSpace(20),
                SocialRegisterRow(),
                verticalSpace(24),
                const HavingAccountWidget(),
                verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20.r),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
