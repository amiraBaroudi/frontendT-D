import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/booking_entities.dart';
import '../bloc/booking_bloc.dart';

class BookingStep3Page extends StatefulWidget {
  const BookingStep3Page({super.key});

  @override
  State<BookingStep3Page> createState() => _BookingStep3PageState();
}

class _BookingStep3PageState extends State<BookingStep3Page> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _photos = [];

  ScheduleType _scheduleType = ScheduleType.immediate;
  DateTime?    _scheduledAt;
  String       _paymentMethod = 'cash';

  Future<void> _pickImage(ImageSource source) async {
    if (_photos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الحد الأقصى 5 صور')),
      );
      return;
    }
    final file = await _picker.pickImage(
      source:    source,
      imageQuality: 70,
    );
    if (file == null) return;
    setState(() => _photos.add(file.path));
    context.read<BookingBloc>().add(PhotoAdded(file.path));
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
    context.read<BookingBloc>().add(PhotoRemoved(index));
  }

  Future<void> _pickDateTime() async {
    final now  = DateTime.now();
    final date = await showDatePicker(
      context:     context,
      initialDate: now.add(const Duration(hours: 1)),
      firstDate:   now,
      lastDate:    now.add(const Duration(days: 30)),
      locale:      const Locale('ar'),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context:     context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
    );
    if (time == null) return;

    setState(() {
      _scheduledAt = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
    context.read<BookingBloc>().add(ScheduleTypeChanged(
      scheduleType: ScheduleType.scheduled,
      scheduledAt:  _scheduledAt,
    ));
  }

  void _onNext() {
    context.read<BookingBloc>().add(PaymentMethodChanged(_paymentMethod));
    context.read<BookingBloc>().add(const PriceEstimateRequested());
    context.push(AppRoutes.priceEstimate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الصور والموعد'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ─── صور الأثاث ─────────────────────────────────
                  _SectionTitle(
                    title:    'صور الأثاث',
                    subtitle: 'موصى به — يحمي أثاثك ويوثّق حالته',
                    icon:     Icons.camera_alt_outlined,
                    color:    AppColors.secondary,
                    isOptional: true,
                  ),
                  const SizedBox(height: AppDimens.md),

                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // زر إضافة صورة
                        GestureDetector(
                          onTap: () => _showImageSourceDialog(),
                          child: Container(
                            width:  90,
                            height: 90,
                            margin: const EdgeInsets.only(left: AppDimens.sm),
                            decoration: BoxDecoration(
                              color:        AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                              border:       Border.all(
                                color: AppColors.primary,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate,
                                    color: AppColors.primary, size: 28),
                                SizedBox(height: 4),
                                Text('أضف صورة',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primary,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        // الصور المضافة
                        ..._photos.asMap().entries.map((e) {
                          return Stack(
                            children: [
                              Container(
                                width:  90,
                                height: 90,
                                margin: const EdgeInsets.only(right: AppDimens.sm),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                                  image: DecorationImage(
                                    image: FileImage(File(e.value)),
                                    fit:   BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top:   4,
                                left:  4,
                                child: GestureDetector(
                                  onTap: () => _removePhoto(e.key),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color:  AppColors.error,
                                      shape:  BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.xl),

                  // ─── موعد النقل ──────────────────────────────────
                  _SectionTitle(
                    title: 'موعد النقل',
                    icon:  Icons.schedule,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppDimens.md),

                  Container(
                    decoration: BoxDecoration(
                      color:        AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                      border:       Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _ScheduleOption(
                          title:      'نقل فوري',
                          subtitle:   'سيتم إرسال سائق في أقرب وقت',
                          icon:       Icons.flash_on_rounded,
                          color:      AppColors.warning,
                          isSelected: _scheduleType == ScheduleType.immediate,
                          onTap: () {
                            setState(() {
                              _scheduleType = ScheduleType.immediate;
                              _scheduledAt  = null;
                            });
                            context.read<BookingBloc>().add(
                              const ScheduleTypeChanged(
                                scheduleType: ScheduleType.immediate,
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _ScheduleOption(
                          title:      'تحديد موعد',
                          subtitle:   _scheduledAt != null
                              ? '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year} — ${_scheduledAt!.hour}:${_scheduledAt!.minute.toString().padLeft(2, '0')}'
                              : 'اختر التاريخ والوقت المناسب',
                          icon:       Icons.calendar_today,
                          color:      AppColors.primary,
                          isSelected: _scheduleType == ScheduleType.scheduled,
                          onTap: () async {
                            setState(() => _scheduleType = ScheduleType.scheduled);
                            await _pickDateTime();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.xl),

                  // ─── طريقة الدفع ─────────────────────────────────
                  _SectionTitle(
                    title: 'طريقة الدفع',
                    icon:  Icons.payment,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: AppDimens.md),

                  Container(
                    decoration: BoxDecoration(
                      color:        AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                      border:       Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _PaymentOption(
                          title:      'دفع نقدي',
                          subtitle:   'ادفع للسائق عند التسليم',
                          icon:       Icons.money,
                          value:      'cash',
                          groupValue: _paymentMethod,
                          onChanged:  (v) => setState(() => _paymentMethod = v!),
                        ),
                        const Divider(height: 1),
                        _PaymentOption(
                          title:      'دفع إلكتروني',
                          subtitle:   'بطاقة ائتمانية أو محفظة رقمية',
                          icon:       Icons.credit_card,
                          value:      'electronic',
                          groupValue: _paymentMethod,
                          onChanged:  (v) => setState(() => _paymentMethod = v!),
                        ),
                      ],
                    ),
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
              label:     'عرض السعر التقديري',
              onPressed: _onNext,
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title:   const Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title:   const Text('من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final bool isOptional;

  const _SectionTitle({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppDimens.iconMd),
        const SizedBox(width: AppDimens.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: AppTextStyles.h3),
                if (isOptional) ...[
                  const SizedBox(width: AppDimens.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical:   2,
                    ),
                    decoration: BoxDecoration(
                      color:        AppColors.secondarySurface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'اختياري',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (subtitle != null)
              Text(subtitle!, style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _ScheduleOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScheduleOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:   onTap,
      leading: Container(
        width:  40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isSelected ? color : AppColors.textSecondary),
      ),
      title: Text(
        title,
        style: AppTextStyles.h3.copyWith(
          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: color)
          : const Icon(Icons.circle_outlined, color: AppColors.border),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return ListTile(
      onTap: () => onChanged(value),
      leading: Container(
        width:  40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primarySurface
              : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.h3.copyWith(
          color: isSelected
              ? AppColors.textPrimary
              : AppColors.textSecondary,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: Radio<String>(
        value:        value,
        groupValue:   groupValue,
        onChanged:    onChanged,
        activeColor:  AppColors.primary,
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
          final step       = i + 1;
          final isActive   = step == currentStep;
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