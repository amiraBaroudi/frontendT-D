import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

// ─── Location Entity ──────────────────────────────────────────────────────────
class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String? buildingName;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.buildingName,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  @override
  List<Object?> get props => [latitude, longitude, address];
}

// ─── Floor Info Entity ────────────────────────────────────────────────────────
class FloorInfoEntity extends Equatable {
  final int floorNumber;   // 0 = أرضي
  final bool hasElevator;

  const FloorInfoEntity({
    required this.floorNumber,
    required this.hasElevator,
  });

  String get displayName =>
      floorNumber == 0 ? 'الطابق الأرضي' : 'الطابق $floorNumber';

  @override
  List<Object> get props => [floorNumber, hasElevator];
}

// ─── Furniture Category ───────────────────────────────────────────────────────
enum FurnitureCategory {
  bedroom,
  livingRoom,
  kitchen,
  dining,
  office,
  appliances,
  other,
}

extension FurnitureCategoryExtension on FurnitureCategory {
  String get arabicName {
    switch (this) {
      case FurnitureCategory.bedroom:    return 'غرفة نوم';
      case FurnitureCategory.livingRoom: return 'صالون';
      case FurnitureCategory.kitchen:    return 'مطبخ';
      case FurnitureCategory.dining:     return 'غرفة طعام';
      case FurnitureCategory.office:     return 'مكتب';
      case FurnitureCategory.appliances: return 'أجهزة كهربائية';
      case FurnitureCategory.other:      return 'أخرى';
    }
  }

  String get icon {
    switch (this) {
      case FurnitureCategory.bedroom:    return '🛏️';
      case FurnitureCategory.livingRoom: return '🛋️';
      case FurnitureCategory.kitchen:    return '🍳';
      case FurnitureCategory.dining:     return '🪑';
      case FurnitureCategory.office:     return '🖥️';
      case FurnitureCategory.appliances: return '📦';
      case FurnitureCategory.other:      return '📦';
    }
  }
}

// ─── Furniture Item Entity ────────────────────────────────────────────────────
class FurnitureItemEntity extends Equatable {
  final FurnitureCategory category;
  final int quantity;
  final String? notes;

  const FurnitureItemEntity({
    required this.category,
    required this.quantity,
    this.notes,
  });

  FurnitureItemEntity copyWith({int? quantity, String? notes}) {
    return FurnitureItemEntity(
      category: category,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [category, quantity, notes];
}

// ─── Schedule Type ────────────────────────────────────────────────────────────
enum ScheduleType { immediate, scheduled }

// ─── Price Estimate Entity ────────────────────────────────────────────────────
class PriceEstimateEntity extends Equatable {
  final double basePrice;
  final double distancePrice;
  final double floorPrice;
  final double totalPrice;
  final String currency;
  final int estimatedMinutes;
  final String vehicleType;

  const PriceEstimateEntity({
    required this.basePrice,
    required this.distancePrice,
    required this.floorPrice,
    required this.totalPrice,
    this.currency = 'ل.س',
    required this.estimatedMinutes,
    required this.vehicleType,
  });

  @override
  List<Object> get props => [totalPrice, estimatedMinutes];
}

// ─── Booking Request Entity ───────────────────────────────────────────────────
// هذا هو الكيان الرئيسي الذي يُجمع فيه كل بيانات الحجز
class BookingRequestEntity extends Equatable {
  final LocationEntity pickup;
  final LocationEntity dropoff;
  final FloorInfoEntity pickupFloor;
  final FloorInfoEntity dropoffFloor;
  final List<FurnitureItemEntity> items;
  final List<String> photoPaths;   // مسارات الصور المرفوعة
  final ScheduleType scheduleType;
  final DateTime? scheduledAt;     // null = فوري
  final String paymentMethod;      // 'cash' | 'electronic'

  const BookingRequestEntity({
    required this.pickup,
    required this.dropoff,
    required this.pickupFloor,
    required this.dropoffFloor,
    required this.items,
    this.photoPaths = const [],
    required this.scheduleType,
    this.scheduledAt,
    this.paymentMethod = 'cash',
  });

  // copyWith لتحديث جزء من البيانات بدون تغيير الباقي
  BookingRequestEntity copyWith({
    LocationEntity? pickup,
    LocationEntity? dropoff,
    FloorInfoEntity? pickupFloor,
    FloorInfoEntity? dropoffFloor,
    List<FurnitureItemEntity>? items,
    List<String>? photoPaths,
    ScheduleType? scheduleType,
    DateTime? scheduledAt,
    String? paymentMethod,
  }) {
    return BookingRequestEntity(
      pickup:        pickup        ?? this.pickup,
      dropoff:       dropoff       ?? this.dropoff,
      pickupFloor:   pickupFloor   ?? this.pickupFloor,
      dropoffFloor:  dropoffFloor  ?? this.dropoffFloor,
      items:         items         ?? this.items,
      photoPaths:    photoPaths    ?? this.photoPaths,
      scheduleType:  scheduleType  ?? this.scheduleType,
      scheduledAt:   scheduledAt   ?? this.scheduledAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  // هل البيانات الأساسية مكتملة؟
  bool get isStep1Complete =>
      pickup.address.isNotEmpty && dropoff.address.isNotEmpty;

  bool get isStep2Complete => items.isNotEmpty;

  @override
  List<Object?> get props => [
        pickup, dropoff, pickupFloor, dropoffFloor,
        items, photoPaths, scheduleType, scheduledAt, paymentMethod,
      ];
}

// ─── Order Entity (الطلب بعد تأكيده) ─────────────────────────────────────────
class OrderEntity extends Equatable {
  final String id;
  final String status;
  final LocationEntity pickup;
  final LocationEntity dropoff;
  final double totalPrice;
  final String paymentMethod;
  final DateTime createdAt;
  final String? driverName;
  final String? driverPhone;
  final double? driverRating;
  final String? vehiclePlate;

  const OrderEntity({
    required this.id,
    required this.status,
    required this.pickup,
    required this.dropoff,
    required this.totalPrice,
    required this.paymentMethod,
    required this.createdAt,
    this.driverName,
    this.driverPhone,
    this.driverRating,
    this.vehiclePlate,
  });

  @override
  List<Object?> get props => [id, status];
}