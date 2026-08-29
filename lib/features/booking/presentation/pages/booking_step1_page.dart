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
import '../widgets/location_search_sheet.dart';

class BookingStep1Page extends StatefulWidget {
  const BookingStep1Page({super.key});

  @override
  State<BookingStep1Page> createState() => _BookingStep1PageState();
}

class _BookingStep1PageState extends State<BookingStep1Page> {
  BookingRequestEntity _requestFromState(BookingState state) {
    if (state is BookingInProgress) {
      return state.request;
    }

    return const BookingRequestEntity(
      pickup: LocationEntity(latitude: 0, longitude: 0, address: ''),
      dropoff: LocationEntity(latitude: 0, longitude: 0, address: ''),
      pickupFloor: FloorInfoEntity(floorNumber: 0, hasElevator: false),
      dropoffFloor: FloorInfoEntity(floorNumber: 0, hasElevator: false),
      items: [],
      scheduleType: ScheduleType.immediate,
    );
  }

  void _openLocationSheet({required bool isPickup}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationSearchSheet(
        isPickup: isPickup,
        onLocationSelected: (_) {},
      ),
    );
  }

  void _onNext(BookingRequestEntity request) {
    if (!request.isStep1Complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار موقع الاستلام والتسليم')),
      );
      return;
    }

    context.push(AppRoutes.bookingStep2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('حجز النقل'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final request = _requestFromState(state);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimens.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختر موقع الاستلام والتسليم',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: AppDimens.md),
                      _LocationCard(
                        title: 'موقع الاستلام',
                        icon: Icons.location_on_outlined,
                        color: AppColors.secondary,
                        address: request.pickup.address.isEmpty
                            ? 'اختر موقع الاستلام'
                            : request.pickup.address,
                        onTap: () => _openLocationSheet(isPickup: true),
                      ),
                      const SizedBox(height: AppDimens.md),
                      _LocationCard(
                        title: 'موقع التسليم',
                        icon: Icons.location_on_rounded,
                        color: AppColors.error,
                        address: request.dropoff.address.isEmpty
                            ? 'اختر موقع التسليم'
                            : request.dropoff.address,
                        onTap: () => _openLocationSheet(isPickup: false),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimens.pagePadding),
                child: AppButton(
                  label: 'التالي — تفاصيل الأثاث',
                  onPressed: request.isStep1Complete ? () => _onNext(request) : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String address;
  final VoidCallback onTap;

  const _LocationCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AppDimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.labelMedium),
                    const SizedBox(height: AppDimens.xs),
                    Text(
                      address,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
