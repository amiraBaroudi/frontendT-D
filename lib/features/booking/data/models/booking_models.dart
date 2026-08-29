import '../../domain/entities/booking_entities.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    required super.address,
    super.buildingName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude:     (json['latitude']  as num).toDouble(),
      longitude:    (json['longitude'] as num).toDouble(),
      address:      json['address']    as String,
      buildingName: json['buildingName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude':     latitude,
        'longitude':    longitude,
        'address':      address,
        if (buildingName != null) 'buildingName': buildingName,
      };
}

class FloorInfoModel extends FloorInfoEntity {
  const FloorInfoModel({
    required super.floorNumber,
    required super.hasElevator,
  });

  Map<String, dynamic> toJson() => {
        'floorNumber': floorNumber,
        'hasElevator': hasElevator,
      };
}

class FurnitureItemModel extends FurnitureItemEntity {
  const FurnitureItemModel({
    required super.category,
    required super.quantity,
    super.notes,
  });

  Map<String, dynamic> toJson() => {
        'category': category.name,
        'quantity': quantity,
        if (notes != null) 'notes': notes,
      };
}

class PriceEstimateModel extends PriceEstimateEntity {
  const PriceEstimateModel({
    required super.basePrice,
    required super.distancePrice,
    required super.floorPrice,
    required super.totalPrice,
    required super.currency,
    required super.estimatedMinutes,
    required super.vehicleType,
  });

  factory PriceEstimateModel.fromJson(Map<String, dynamic> json) {
    return PriceEstimateModel(
      basePrice:        (json['basePrice']        as num).toDouble(),
      distancePrice:    (json['distancePrice']    as num).toDouble(),
      floorPrice:       (json['floorPrice']       as num).toDouble(),
      totalPrice:       (json['totalPrice']       as num).toDouble(),
      currency:         json['currency']          as String? ?? 'ل.س',
      estimatedMinutes: json['estimatedMinutes']  as int,
      vehicleType:      json['vehicleType']       as String,
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.status,
    required super.pickup,
    required super.dropoff,
    required super.totalPrice,
    required super.paymentMethod,
    required super.createdAt,
    super.driverName,
    super.driverPhone,
    super.driverRating,
    super.vehiclePlate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id:            json['id']            as String,
      status:        json['status']        as String,
      pickup:        LocationModel.fromJson(json['pickup']  as Map<String, dynamic>),
      dropoff:       LocationModel.fromJson(json['dropoff'] as Map<String, dynamic>),
      totalPrice:    (json['totalPrice']   as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      createdAt:     DateTime.parse(json['createdAt'] as String),
      driverName:    json['driverName']    as String?,
      driverPhone:   json['driverPhone']   as String?,
      driverRating:  json['driverRating'] != null
          ? (json['driverRating'] as num).toDouble()
          : null,
      vehiclePlate:  json['vehiclePlate']  as String?,
    );
  }
}