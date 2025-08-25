import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/features/home/logic/category_cubit/category_cubit.dart';
import 'package:ecommerce_app/features/home/logic/category_cubit/category_state.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType || prev != curr,
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is CategoryError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<CategoryCubit>().getCategory(),
          );
        }

        if (state is CategoryLoaded) {
          final categories = state.category;

          if (categories.isEmpty) {
            return _EmptyView(
              text: tr(LocaleKeys.noCategories),
              onRefresh: () => context.read<CategoryCubit>().getCategory(),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async => context.read<CategoryCubit>().getCategory(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 600
                        ? 3
                        : 2;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: GridView.builder(
                    key: ValueKey(categories.length),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final bg = category.bgColor;
                      final darker = Color.lerp(bg, Colors.black, 0.08)!;

                      return _CategoryCard(
                        name: category.name,
                        count: category.productsCount,
                        bgGradient: [bg, darker],
                        textColor: category.textColor,
                        onTap: () {
                          // TODO: navigate to category details
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        }

        return _EmptyView(
          text: tr(LocaleKeys.noCategories),
          onRefresh: () => context.read<CategoryCubit>().getCategory(),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final int count;
  final List<Color> bgGradient;
  final Color textColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.count,
    required this.bgGradient,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: textColor.withOpacity(0.2),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: textColor.withOpacity(0.9)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Text(
                  '$count ${tr(LocaleKeys.products)}',
                  style: t.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: t.titleMedium),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(tr('retry')),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String text;
  final VoidCallback onRefresh;

  const _EmptyView({required this.text, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(text, style: t.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(tr('refresh')),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
