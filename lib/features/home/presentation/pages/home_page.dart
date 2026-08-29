import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const _HomeBottomNav(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _HomeAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _RequestMoveCard(),
                  const SizedBox(height: AppDimens.lg),
                  _RecentOrdersSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      floating: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePadding,
            vertical: AppDimens.sm,
          ),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final user = state is AuthAuthenticated ? state.user : null;
              return Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً، ${user?.name.split(' ').first ?? 'بك'} 👋',
                        style: AppTextStyles.h2,
                      ),
                      Text(
                        'إلى أين تنقل أثاثك اليوم؟',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Notification bell
                  IconButton(
                    onPressed: () {},
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          size: 28,
                          color: AppColors.textPrimary,
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimens.xs),
                  // Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primarySurface,
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : 'ع',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
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

class _RequestMoveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookingStep1),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.requestMove,
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppDimens.xs),
                  Text(
                    'احجز بسرعة وتتبع لحظة بلحظة',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: AppDimens.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.md,
                      vertical: AppDimens.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusCircle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ابدأ الآن',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppDimens.xs),
                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.primary,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.md),
            const Icon(
              Icons.local_shipping_rounded,
              color: Colors.white,
              size: 72,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentOrdersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: connect to OrderBloc
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.recentOrders, style: AppTextStyles.h2),
            TextButton(
              onPressed: () => context.push(AppRoutes.orderHistory),
              child: Text(
                'عرض الكل',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.sm),

        // Placeholder — will be replaced with BlocBuilder
        const _EmptyOrdersPlaceholder(),
      ],
    );
  }
}

class _EmptyOrdersPlaceholder extends StatelessWidget {
  const _EmptyOrdersPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppDimens.md),
            Text(
              AppStrings.noOrdersYet,
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimens.xs),
            Text(
              AppStrings.startFirstOrder,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBottomNav extends StatefulWidget {
  const _HomeBottomNav();

  @override
  State<_HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<_HomeBottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) {
        setState(() => _currentIndex = i);
        switch (i) {
          case 0:
            context.go(AppRoutes.home);
          case 1:
            context.push(AppRoutes.orderHistory);
          case 2:
            context.push(AppRoutes.profile);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long_rounded),
          label: 'طلباتي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person_rounded),
          label: AppStrings.myProfile,
        ),
      ],
    );
  }
}
