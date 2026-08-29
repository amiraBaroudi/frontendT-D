import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';

class _OnboardingItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _OnboardingItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

const _items = [
  _OnboardingItem(
    icon: Icons.local_shipping_rounded,
    iconBg: Color(0xFFEFF6FF),
    iconColor: AppColors.primary,
    title: 'نقل أثاثك بكل سهولة',
    subtitle:
        'احجز خدمة نقل الأثاث في خطوات بسيطة دون عناء البحث عن سيارة مناسبة',
  ),
  _OnboardingItem(
    icon: Icons.location_on_rounded,
    iconBg: Color(0xFFECFDF5),
    iconColor: AppColors.secondary,
    title: 'تتبع شاحنتك لحظة بلحظة',
    subtitle:
        'راقب موقع السائق على الخريطة في الوقت الفعلي وكن على علم بكل مرحلة',
  ),
  _OnboardingItem(
    icon: Icons.camera_alt_rounded,
    iconBg: Color(0xFFFFF7ED),
    iconColor: Color(0xFFF59E0B),
    title: 'توثيق كامل يحمي أثاثك',
    subtitle:
        'يتم تصوير أثاثك قبل وبعد النقل لضمان وصوله سليماً دون أي تلف',
  ),
  _OnboardingItem(
    icon: Icons.star_rounded,
    iconBg: Color(0xFFFEF2F2),
    iconColor: AppColors.error,
    title: 'سائقون موثوقون ومقيّمون',
    subtitle:
        'جميع سائقينا مدرّبون ومقيّمون من قِبَل العملاء لضمان أفضل تجربة',
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _items.length - 1;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'تخطى',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _OnboardingItemWidget(item: _items[i]),
              ),
            ),

            // Indicators + button
            Padding(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _items.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.lg),

                  // Button
                  AppButton(
                    label: isLast ? 'ابدأ الآن' : 'التالي',
                    onPressed: () {
                      if (isLast) {
                        _finish();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItemWidget extends StatelessWidget {
  final _OnboardingItem item;

  const _OnboardingItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: item.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 68, color: item.iconColor),
          ),
          const SizedBox(height: AppDimens.xl),
          Text(
            item.title,
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.md),
          Text(
            item.subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
