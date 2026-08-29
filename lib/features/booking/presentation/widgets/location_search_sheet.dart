import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/booking_entities.dart';
import '../bloc/booking_bloc.dart';

// بيانات مدن سورية للبحث المحلي (بدون API خارجي)
const _syrianCities = [
  {'name': 'دمشق — المزة',           'lat': 33.4969, 'lng': 36.2336},
  {'name': 'دمشق — المالكي',          'lat': 33.5069, 'lng': 36.2751},
  {'name': 'دمشق — أبو رمانة',        'lat': 33.5130, 'lng': 36.2820},
  {'name': 'دمشق — الشعلان',          'lat': 33.5101, 'lng': 36.2917},
  {'name': 'دمشق — ساحة الأمويين',    'lat': 33.5138, 'lng': 36.2765},
  {'name': 'دمشق — المهاجرين',        'lat': 33.5258, 'lng': 36.2890},
  {'name': 'دمشق — ركن الدين',        'lat': 33.5389, 'lng': 36.2986},
  {'name': 'دمشق — القصاع',           'lat': 33.5027, 'lng': 36.2984},
  {'name': 'دمشق — باب توما',         'lat': 33.5112, 'lng': 36.3148},
  {'name': 'دمشق — الميدان',          'lat': 33.4948, 'lng': 36.2979},
  {'name': 'دمشق — كفرسوسة',         'lat': 33.4798, 'lng': 36.2630},
  {'name': 'دمشق — قدسيا',            'lat': 33.5527, 'lng': 36.2225},
  {'name': 'ريف دمشق — جرمانا',       'lat': 33.4748, 'lng': 36.3520},
  {'name': 'ريف دمشق — دوما',         'lat': 33.5715, 'lng': 36.3982},
  {'name': 'حلب — العزيزية',          'lat': 36.2021, 'lng': 37.1343},
  {'name': 'حمص — الوعر',             'lat': 34.7324, 'lng': 36.6912},
  {'name': 'اللاذقية — الزراعة',      'lat': 35.5317, 'lng': 35.7916},
  {'name': 'طرطوس — المركز',          'lat': 34.8949, 'lng': 35.8866},
];

class LocationSearchSheet extends StatefulWidget {
  final bool isPickup;
  final void Function(LocationEntity location) onLocationSelected;

  const LocationSearchSheet({
    super.key,
    required this.isPickup,
    required this.onLocationSelected,
  });

  @override
  State<LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<LocationSearchSheet> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = _syrianCities;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _results = q.isEmpty
          ? _syrianCities
          : _syrianCities
              .where((c) => (c['name'] as String).contains(q))
              .toList();
    });
  }

  void _selectLocation(Map<String, dynamic> city) {
    final location = LocationEntity(
      latitude:  city['lat'] as double,
      longitude: city['lng'] as double,
      address:   city['name'] as String,
    );

    if (widget.isPickup) {
      context.read<BookingBloc>().add(PickupLocationSelected(location));
    } else {
      context.read<BookingBloc>().add(DropoffLocationSelected(location));
    }

    widget.onLocationSelected(location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize:     0.5,
      maxChildSize:     0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimens.radiusXl),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: AppDimens.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppDimens.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isPickup
                          ? 'ابحث عن موقع الاستلام'
                          : 'ابحث عن موقع التسليم',
                      style: AppTextStyles.h2,
                    ),
                    const SizedBox(height: AppDimens.md),
                    TextField(
                      controller:    _searchController,
                      onChanged:     _onSearch,
                      autofocus:     true,
                      decoration: InputDecoration(
                        hintText: 'اكتب اسم الحي أو المنطقة',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearch('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // نتائج البحث
              Expanded(
                child: _results.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد نتائج',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller:  scrollController,
                        padding:     const EdgeInsets.symmetric(
                          vertical: AppDimens.sm,
                        ),
                        itemCount:   _results.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 56),
                        itemBuilder: (_, i) {
                          final city = _results[i];
                          return ListTile(
                            leading: Container(
                              width:  36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: widget.isPickup
                                    ? AppColors.secondarySurface
                                    : AppColors.errorSurface,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.isPickup
                                    ? Icons.my_location
                                    : Icons.location_on,
                                size:  18,
                                color: widget.isPickup
                                    ? AppColors.secondary
                                    : AppColors.error,
                              ),
                            ),
                            title: Text(
                              city['name'] as String,
                              style: AppTextStyles.bodyMedium,
                            ),
                            onTap: () => _selectLocation(city),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}