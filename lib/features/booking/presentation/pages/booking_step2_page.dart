
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/booking_entities.dart';
import '../bloc/booking_bloc.dart';

class BookingStep2Page extends StatefulWidget {
  const BookingStep2Page({super.key});

  @override
  State<BookingStep2Page> createState() => _BookingStep2PageState();
}

class _BookingStep2PageState extends State<BookingStep2Page> {
  // كميات الأثاث
  final Map<FurnitureCategory, int> _quantities = {
    for (final cat in FurnitureCategory.values) cat: 0,
  };

  // معلومات الطوابق
  int _pickupFloor   = 0;
  bool _pickupLift   = false;
  int _dropoffFloor  = 0;
  bool _dropoffLift  = false;

  bool get _hasItems => _quantities.values.any((q) => q > 0);

  void _updateQuantity(FurnitureCategory cat, int qty) {
    setState(() => _quantities[cat] = qty);
    context.read<BookingBloc>().add(
          FurnitureItemUpdated(category: cat, quantity: qty),
        );
  }

  void _onNext() {
    context.read<BookingBloc>().add(
          PickupFloorUpdated(
            FloorInfoEntity(floorNumber: _pickupFloor, hasElevator: _pickupLift),
          ),
        );
    context.read<BookingBloc>().add(
          DropoffFloorUpdated(
            FloorInfoEntity(floorNumber: _dropoffFloor, hasElevator: _dropoffLift),
          ),
        );
    context.push(AppRoutes.bookingStep3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تفاصيل الأثاث'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // قسم الأثاث
                  Text('ما الأثاث الذي تريد نقله؟', style: AppTextStyles.h2),
                  const SizedBox(height: AppDimens.xs),
                  Text(
                    'حدد الكمية لكل نوع',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppDimens.md),

                  // بطاقات الأثاث
                  GridView.builder(
                    shrinkWrap:  true,
                    physics:     const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:   2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: AppDimens.sm,
                      mainAxisSpacing:  AppDimens.sm,
                    ),
                    itemCount:   FurnitureCategory.values.length,
                    itemBuilder: (_, i) {
                      final cat = FurnitureCategory.values[i];
                      return _FurnitureCard(
                        category: cat,
                        quantity: _quantities[cat]!,
                        onChanged: (qty) => _updateQuantity(cat, qty),
                      );
                    },
                  ),

                  const SizedBox(height: AppDimens.xl),

                  // قسم الطوابق
                  Text('تفاصيل الطوابق', style: AppTextStyles.h2),
                  const SizedBox(height: AppDimens.md),

                  _FloorCard(
                    title:       'طابق الاستلام',
                    color:       AppColors.secondary,
                    icon:        Icons.upload_rounded,
                    floor:       _pickupFloor,
                    hasElevator: _pickupLift,
                    onFloorChanged:    (f) => setState(() => _pickupFloor = f),
                    onElevatorChanged: (e) => setState(() => _pickupLift  = e),
                  ),
                  const SizedBox(height: AppDimens.md),
                  _FloorCard(
                    title:       'طابق التسليم',
                    color:       AppColors.error,
                    icon:        Icons.download_rounded,
                    floor:       _dropoffFloor,
                    hasElevator: _dropoffLift,
                    onFloorChanged:    (f) => setState(() => _dropoffFloor = f),
                    onElevatorChanged: (e) => setState(() => _dropoffLift  = e),
                  ),

                  const SizedBox(height: AppDimens.xxl),
                ],
              ),
            ),
          ),

          // زر التالي
          Padding(
            padding: const EdgeInsets.all(AppDimens.pagePadding),
            child: AppButton(
              label:     'التالي — الصور والموعد',
              onPressed: _hasItems ? _onNext : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Furniture Card Widget ────────────────────────────────────────────────────
class _FurnitureCard extends StatelessWidget {
  final FurnitureCategory category;
  final int quantity;
  final ValueChanged<int> onChanged;

  const _FurnitureCard({
    required this.category,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = quantity > 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:        isSelected ? AppColors.primarySurface : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border:       Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.sm,
        vertical:   AppDimens.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: AppDimens.xs),
              Expanded(
                child: Text(
                  category.arabicName,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // عداد الكمية
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterBtn(
                icon:    Icons.remove,
                onTap:   quantity > 0 ? () => onChanged(quantity - 1) : null,
                enabled: quantity > 0,
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              _CounterBtn(
                icon:    Icons.add,
                onTap:   () => onChanged(quantity + 1),
                enabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _CounterBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  28,
        height: 28,
        decoration: BoxDecoration(
          color:        enabled ? AppColors.primary : AppColors.border,
          shape:        BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}

// ─── Floor Card Widget ────────────────────────────────────────────────────────
class _FloorCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final int floor;
  final bool hasElevator;
  final ValueChanged<int> onFloorChanged;
  final ValueChanged<bool> onElevatorChanged;

  const _FloorCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.floor,
    required this.hasElevator,
    required this.onFloorChanged,
    required this.onElevatorChanged,
  });

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
          Row(
            children: [
              Icon(icon, color: color, size: AppDimens.iconMd),
              const SizedBox(width: AppDimens.sm),
              Text(title, style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: AppDimens.md),

          // اختيار الطابق
          Row(
            children: [
              Text('الطابق:', style: AppTextStyles.bodyMedium),
              const Spacer(),
              _CounterBtn(
                icon:    Icons.remove,
                onTap:   floor > 0 ? () => onFloorChanged(floor - 1) : null,
                enabled: floor > 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
                child: Text(
                  floor == 0 ? 'أرضي' : '$floor',
                  style: AppTextStyles.h3.copyWith(color: color),
                ),
              ),
              _CounterBtn(
                icon:    Icons.add,
                onTap:   () => onFloorChanged(floor + 1),
                enabled: true,
              ),
            ],
          ),

          const SizedBox(height: AppDimens.sm),
          const Divider(),
          const SizedBox(height: AppDimens.sm),

          // وجود مصعد
          Row(
            children: [
              Text('يوجد مصعد؟', style: AppTextStyles.bodyMedium),
              const Spacer(),
              Switch.adaptive(
                value:         hasElevator,
                onChanged:     onElevatorChanged,
                activeColor:   color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePadding,
        vertical:   AppDimens.sm,
      ),
      color: AppColors.white,
      child: Row(
        children: List.generate(3, (i) {
          final step      = i + 1;
          final isActive  = step == currentStep;
          final isComplete = step < currentStep;
          return Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isComplete
                      ? AppColors.secondary
                      : isActive
                          ? AppColors.primary
                          : AppColors.border,
                  child: isComplete
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '$step',
                          style: TextStyle(
                            fontSize:   12,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                ),
                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      color:  isComplete
                          ? AppColors.secondary
                          : AppColors.border,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}