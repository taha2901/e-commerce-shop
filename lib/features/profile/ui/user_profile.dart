import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_cubit.dart';
import 'package:ecommerce_app/features/profile/logic/user_cubit/user_states.dart';
import 'package:ecommerce_app/features/profile/ui/widget/identify_user_widget.dart';
import 'package:ecommerce_app/features/profile/ui/widget/modify_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return BlocProvider(
      create: (context) => UserCubit()..getUserData(),
      child: Scaffold(
        backgroundColor: t.colorScheme.surface,
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state is UserError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 48, color: t.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(state.message,
                        style: t.textTheme.titleMedium,
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            if (state is UserLoaded) {
              final user = state.user;
              final initials = user.username.isNotEmpty
                  ? user.username
                      .trim()
                      .split(' ')
                      .map((e) => e[0].toUpperCase())
                      .take(2)
                      .join()
                  : '?';

              return CustomScrollView(
                slivers: [
                  // ── SliverAppBar مع Avatar ──
                  SliverAppBar(
                    expandedHeight: 240,
                    pinned: true,
                    backgroundColor: t.colorScheme.primary,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              t.colorScheme.primary,
                              t.colorScheme.primary.withOpacity(0.75),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 32),
                              // ── Avatar ──
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                    width: 2.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                user.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      LocaleKeys.profile.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),

                  // ── Body Content ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(8),

                          // ── Section Label ──
                          Text(
                            'Account Info',
                            style: t.textTheme.labelLarge?.copyWith(
                              color: t.hintColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                          verticalSpace(10),

                          IdentifyUserWidget(user: user),
                          verticalSpace(28),

                          // ── Stats Row ──
                          _StatsRow(theme: t),
                          verticalSpace(28),

                          // ── Actions ──
                          Text(
                            'Actions',
                            style: t.textTheme.labelLarge?.copyWith(
                              color: t.hintColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                          verticalSpace(10),
                          ModifyButtons(user: user),
                          verticalSpace(20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Stats Row (Orders / Wishlist / Reviews) ──
class _StatsRow extends StatelessWidget {
  final ThemeData theme;
  const _StatsRow({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          _StatItem(
            icon: Icons.shopping_bag_rounded,
            label: 'Orders',
            value: '12',
            color: theme.colorScheme.primary,
            theme: theme,
          ),
          _Divider(),
          _StatItem(
            icon: Icons.favorite_rounded,
            label: 'Wishlist',
            value: '5',
            color: Colors.red,
            theme: theme,
          ),
          _Divider(),
          _StatItem(
            icon: Icons.star_rounded,
            label: 'Reviews',
            value: '8',
            color: Colors.amber,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: Theme.of(context).dividerColor.withOpacity(0.4),
    );
  }
}