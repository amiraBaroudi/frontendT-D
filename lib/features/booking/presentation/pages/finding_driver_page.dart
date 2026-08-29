import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/booking_bloc.dart';

class FindingDriverPage extends StatefulWidget {
  const FindingDriverPage({super.key});

  @override
  State<FindingDriverPage> createState() => _FindingDriverPageState();
}

class _FindingDriverPageState extends State<FindingDriverPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  int _dotsCount = 1;
  Timer? _dotsTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync:    this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _dotsCount = _dotsCount == 3 ? 1 : _dotsCount + 1);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dotsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // لا يمكن الرجوع أثناء البحث عن سائق
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              context.go(AppRoutes.trackingPath(state.order.id));
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // أيقونة نابضة
                  ScaleTransition(
                    scale: _pulseAnim,
                    child: Container(
                      width:  140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:      AppColors.primary.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: AppColors.primary,
                        size:  70,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.xl),

                  Text(
                    'جاري البحث عن سائق${'.' * _dotsCount}',
                    style: AppTextStyles.h1,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppDimens.sm),

                  Text(
                    'نبحث عن أقرب سائق متاح في منطقتك',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppDimens.xxl),

                  // مراحل البحث
                  _SearchStep(
                    icon:   Icons.search,
                    label:  'البحث عن سائقين متاحين',
                    isDone: true,
                  ),
                  _SearchStep(
                    icon:   Icons.location_on,
                    label:  'تحديد أقرب سائق لموقعك',
                    isDone: false,
                    isActive: true,
                  ),
                  _SearchStep(
                    icon:   Icons.check_circle,
                    label:  'تأكيد قبول السائق',
                    isDone: false,
                  ),

                  const Spacer(),

                  // زر الإلغاء
                  AppButton.outlined(
                    label:     'إلغاء الطلب',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title:   const Text('إلغاء الطلب'),
                          content: const Text('هل أنت متأكد من إلغاء طلب النقل؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('لا، تابع'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<BookingBloc>().add(const BookingReset());
                                context.go(AppRoutes.home);
                              },
                              child: Text(
                                'نعم، إلغاء',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDone;
  final bool isActive;

  const _SearchStep({
    required this.icon,
    required this.label,
    required this.isDone,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Widget iconWidget;

    if (isDone) {
      color      = AppColors.secondary;
      iconWidget = const Icon(Icons.check_circle, color: AppColors.secondary, size: 22);
    } else if (isActive) {
      color      = AppColors.primary;
      iconWidget = SizedBox(
        width:  22,
        height: 22,
        child:  CircularProgressIndicator(
          strokeWidth: 2.5,
          color:       AppColors.primary,
        ),
      );
    } else {
      color      = AppColors.border;
      iconWidget = Icon(icon, color: AppColors.border, size: 22);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.sm),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: AppDimens.md),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDone || isActive
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}