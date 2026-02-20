import 'package:ecommerce_app/features/auth/ui/widget/login_customs/social_login_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/another_loging_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/forget_pass_button_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/logo_and_animition_section.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/no_account_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/welcom_text_widget.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/custom_input_field_of_label_field.dart';
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/custom_main_button_field.dart';

// ═══════════════════════════════════════════════════════════
//  Demo Accounts Data
// ═══════════════════════════════════════════════════════════
class _DemoAccount {
  final String role;
  final String email;
  final String password;
  final IconData icon;
  final Color color;
  final String description;

  const _DemoAccount({
    required this.role,
    required this.email,
    required this.password,
    required this.icon,
    required this.color,
    required this.description,
  });
}

const _demoAccounts = [
  _DemoAccount(
    role: 'Admin',
    email: 'tahahamada2901@gmail.com',
    password: '123456',
    icon: Icons.admin_panel_settings_rounded,
    color: Colors.blueGrey, // لون هادي ينفع دارك ولايت
    description: 'لوحة التحكم',
  ),
];

// ═══════════════════════════════════════════════════════════
//  Main Login Page
// ═══════════════════════════════════════════════════════════
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _isObscure.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ─── Auto-fill from demo card ───────────────────────────
  void _fillCredentials(_DemoAccount account) {
    HapticFeedback.lightImpact();
    emailController.text = account.email;
    passwordController.text = account.password;
    // Small visual feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(account.icon, color: account.color, size: 18),
            SizedBox(width: 8.w),
            Text(
              'تم تعبئة بيانات ${account.role} تلقائياً ✓',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E1E2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: account.color.withOpacity(0.5)),
        ),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
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

                    // ── Email Field ──────────────────────
                    CustomInputField(
                      label: 'البريد الإلكتروني',
                      controller: emailController,
                      prefixIcon: Icons.email_outlined,
                      hintText: 'أدخل بريدك الإلكتروني',
                    ),
                    verticalSpace(20),

                    // ── Password Field ───────────────────
                    ValueListenableBuilder<bool>(
                      valueListenable: _isObscure,
                      builder: (context, isObscure, _) {
                        return CustomInputField(
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
                            onPressed: () => _isObscure.value = !isObscure,
                          ),
                        );
                      },
                    ),

                    verticalSpace(16),
                    const ForgetPasswordButton(),
                    verticalSpace(32),

                    // ── Login Button ─────────────────────
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

                    // ══════════════════════════════════════
                    //  🆕 Demo Accounts Section
                    // ══════════════════════════════════════
                    _DemoAccountsSection(onTap: _fillCredentials),

                    verticalSpace(24),
                    const NoAccountWidget(),
                    verticalSpace(24),
                  ],
                ),
              ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Demo Accounts Section Widget
// ═══════════════════════════════════════════════════════════
class _DemoAccountsSection extends StatelessWidget {
  final void Function(_DemoAccount) onTap;

  const _DemoAccountsSection({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ───────────────────────────────
        Row(
          children: [
            Container(
              width: 3.w,
              height: 18.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'حساب تجريبي',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(6),
        Text(
          'اضغط على أي حساب لتعبئة البيانات تلقائياً',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11.sp,
            color: Colors.grey.shade500,
          ),
        ),
        verticalSpace(12),

        // ── Demo Cards ───────────────────────────────────
        Center(
          child: SizedBox(
            width: 260.w,
            child: _DemoAccountCard(
              account: _demoAccounts.first,
              onTap: () => onTap(_demoAccounts.first),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Single Demo Account Card
// ═══════════════════════════════════════════════════════════
class _DemoAccountCard extends StatefulWidget {
  final _DemoAccount account;
  final VoidCallback onTap;

  const _DemoAccountCard({required this.account, required this.onTap});

  @override
  State<_DemoAccountCard> createState() => _DemoAccountCardState();
}

class _DemoAccountCardState extends State<_DemoAccountCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acc = widget.account;

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: acc.color.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + Role
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: acc.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(acc.icon, color: acc.color, size: 16.sp),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    acc.role,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: acc.color,
                    ),
                  ),
                ],
              ),
              verticalSpace(8),

              // Description
              Text(
                acc.description,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.sp,
                  color: Colors.grey.shade400,
                ),
              ),
              verticalSpace(8),

              // Email
              _InfoRow(
                icon: Icons.email_outlined,
                text: acc.email,
                color: acc.color,
              ),
              verticalSpace(4),

              // Password
              _InfoRow(
                icon: Icons.key_rounded,
                text: acc.password,
                color: acc.color,
              ),

              verticalSpace(8),

              // Tap hint
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 11.sp,
                    color: acc.color.withOpacity(0.6),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'اضغط للتعبئة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 9.sp,
                      color: acc.color.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Small info row ─────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 10.sp, color: color.withOpacity(0.7)),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 9.5.sp,
              color: Theme.of(context).textTheme.bodySmall?.color,

              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
