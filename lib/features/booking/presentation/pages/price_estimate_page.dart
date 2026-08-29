import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_states.dart';
import '../../domain/entities/booking_entities.dart';
import '../bloc/booking_bloc.dart';

class PriceEstimatePage extends StatelessWidget {
  const PriceEstimatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تقدير السعر'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            context.go(AppRoutes.findingDriver);
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:         Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookingPriceLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: AppDimens.md),
                  Text('جاري حساب السعر...'),
                ],
              ),
            );
          }

          if (state is BookingError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context
                  .read<BookingBloc>()
                  .add(const PriceEstimateRequested()),
            );
          }

          if (state is BookingPriceLoaded) {
            return _PriceContent(
              request:  state.request,
              estimate: state.estimate,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PriceContent extends StatelessWidget {
  final BookingRequestEntity request;
  final PriceEstimateEntity estimate;

  const _PriceContent({
    required this.request,
    required this.estimate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.pagePadding),
            child: Column(
              children: [
                // بطاقة السعر الإجمالي
                Container(
                  width:   double.infinity,
                  padding: const EdgeInsets.all(AppDimens.xl),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin:  Alignment.topLeft,
                      end:    Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusXl),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'السعر الإجمالي التقديري',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: AppDimens.sm),
                      Text(
                        '${estimate.totalPrice.toStringAsFixed(0)} ${estimate.currency}',
                        style: AppTextStyles.displayLarge.copyWith(
                          color:      Colors.white,
                          fontSize:   40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppDimens.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.md,
                          vertical:   AppDimens.xs,
                        ),
                        decoration: BoxDecoration(
                          color:        Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppDimens.radiusCircle),
                        ),
                        child: Text(
                          '⏱ وقت التسليم المتوقع: ${estimate.estimatedMinutes} دقيقة',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.lg),

                // تفاصيل التسعير
                _PriceBreakdown(estimate: estimate),

                const SizedBox(height: AppDimens.lg),

                // ملخص الطلب
                _OrderSummary(request: request),

                const SizedBox(height: AppDimens.md),

                // تنبيه السعر
                Container(
                  padding: const EdgeInsets.all(AppDimens.md),
                  decoration: BoxDecoration(
                    color:        AppColors.warningSurface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.warning, size: 18),
                      const SizedBox(width: AppDimens.sm),
                      Expanded(
                        child: Text(
                          'السعر تقديري وقد يختلف قليلاً بناءً على التفاصيل الفعلية عند التنفيذ',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // زر التأكيد
        Padding(
          padding: const EdgeInsets.all(AppDimens.pagePadding),
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              final isLoading = state is BookingSubmitting;
              return AppButton(
                label:     'تأكيد الحجز والبحث عن سائق',
                isLoading: isLoading,
                onPressed: () =>
                    context.read<BookingBloc>().add(const OrderConfirmed()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  final PriceEstimateEntity estimate;
  const _PriceBreakdown({required this.estimate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:     const EdgeInsets.all(AppDimens.md),
      decoration:  BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تفاصيل السعر', style: AppTextStyles.h3),
          const SizedBox(height: AppDimens.md),
          _PriceRow(
            label: 'السعر الأساسي',
            value: '${estimate.basePrice.toStringAsFixed(0)} ${estimate.currency}',
          ),
          _PriceRow(
            label: 'رسوم المسافة',
            value: '${estimate.distancePrice.toStringAsFixed(0)} ${estimate.currency}',
          ),
          _PriceRow(
            label: 'رسوم الطوابق',
            value: '${estimate.floorPrice.toStringAsFixed(0)} ${estimate.currency}',
          ),
          const Divider(),
          _PriceRow(
            label:  'الإجمالي',
            value:  '${estimate.totalPrice.toStringAsFixed(0)} ${estimate.currency}',
            isBold: true,
            color:  AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.labelLarge
                : AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.h3.copyWith(color: color ?? AppColors.textPrimary)
                : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final BookingRequestEntity request;
  const _OrderSummary({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:     const EdgeInsets.all(AppDimens.md),
      decoration:  BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ملخص الطلب', style: AppTextStyles.h3),
          const SizedBox(height: AppDimens.md),
          _SummaryRow(
            icon:  Icons.my_location,
            color: AppColors.secondary,
            label: 'من',
            value: request.pickup.address,
          ),
          const SizedBox(height: AppDimens.sm),
          _SummaryRow(
            icon:  Icons.location_on,
            color: AppColors.error,
            label: 'إلى',
            value: request.dropoff.address,
          ),
          const Divider(height: AppDimens.lg),
          Wrap(
            spacing:   AppDimens.sm,
            runSpacing: AppDimens.xs,
            children:  request.items.map((item) {
              return Chip(
                label: Text(
                  '${item.category.icon} ${item.category.arabicName} × ${item.quantity}',
                  style: AppTextStyles.bodySmall,
                ),
                backgroundColor: AppColors.primarySurface,
                side:            BorderSide.none,
                padding:         EdgeInsets.zero,
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimens.sm),
          Row(
            children: [
              Icon(
                request.paymentMethod == 'cash'
                    ? Icons.money
                    : Icons.credit_card,
                size:  16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                request.paymentMethod == 'cash'
                    ? 'دفع نقدي'
                    : 'دفع إلكتروني',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(width: AppDimens.md),
              Icon(
                request.scheduleType == ScheduleType.immediate
                    ? Icons.flash_on
                    : Icons.calendar_today,
                size:  16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                request.scheduleType == ScheduleType.immediate
                    ? 'نقل فوري'
                    : 'موعد محدد',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: AppDimens.sm),
        Text('$label: ', style: AppTextStyles.labelMedium.copyWith(color: color)),
        Expanded(
          child: Text(
            value,
            style:    AppTextStyles.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}