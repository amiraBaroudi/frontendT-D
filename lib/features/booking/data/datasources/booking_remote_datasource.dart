import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../models/booking_models.dart';
import '../../domain/entities/booking_entities.dart';

abstract class BookingRemoteDataSource {
  Future<PriceEstimateModel> getPriceEstimate({
    required BookingRequestEntity request,
  });

  Future<OrderModel> createOrder({
    required BookingRequestEntity request,
  });

  Future<List<OrderModel>> getOrderHistory();

  Future<OrderModel> getOrderById(String orderId);

  Future<void> cancelOrder(String orderId);

  Future<List<String>> uploadOrderPhotos({
    required String orderId,
    required List<String> localPaths,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final NetworkClient _networkClient;
  const BookingRemoteDataSourceImpl(this._networkClient);

  // تحويل BookingRequestEntity إلى JSON يفهمه الـ API
  Map<String, dynamic> _requestToJson(BookingRequestEntity request) {
    return {
      'pickup': {
        'latitude':  request.pickup.latitude,
        'longitude': request.pickup.longitude,
        'address':   request.pickup.address,
      },
      'dropoff': {
        'latitude':  request.dropoff.latitude,
        'longitude': request.dropoff.longitude,
        'address':   request.dropoff.address,
      },
      'pickupFloor': {
        'floorNumber': request.pickupFloor.floorNumber,
        'hasElevator': request.pickupFloor.hasElevator,
      },
      'dropoffFloor': {
        'floorNumber': request.dropoffFloor.floorNumber,
        'hasElevator': request.dropoffFloor.hasElevator,
      },
      'items': request.items.map((item) => {
        'category': item.category.name,
        'quantity': item.quantity,
        if (item.notes != null) 'notes': item.notes,
      }).toList(),
      'scheduleType': request.scheduleType.name,
      if (request.scheduledAt != null)
        'scheduledAt': request.scheduledAt!.toIso8601String(),
      'paymentMethod': request.paymentMethod,
    };
  }

  @override
  Future<PriceEstimateModel> getPriceEstimate({
    required BookingRequestEntity request,
  }) async {
    try {
      final response = await _networkClient.dio.post(
        '${ApiConstants.orders}/estimate',
        data: _requestToJson(request),
      );
      return PriceEstimateModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<OrderModel> createOrder({
    required BookingRequestEntity request,
  }) async {
    try {
      final response = await _networkClient.dio.post(
        ApiConstants.orders,
        data: _requestToJson(request),
      );
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<List<OrderModel>> getOrderHistory() async {
    try {
      final response = await _networkClient.dio.get(
        ApiConstants.orderHistory,
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await _networkClient.dio.get(
        ApiConstants.orderById(orderId),
      );
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await _networkClient.dio.post(ApiConstants.orderCancel(orderId));
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<List<String>> uploadOrderPhotos({
    required String orderId,
    required List<String> localPaths,
  }) async {
    try {
      // نبني FormData لرفع ملفات متعددة
      final formData = FormData();
      for (final path in localPaths) {
        final fileName = path.split('/').last;
        formData.files.add(
          MapEntry(
            'photos',
            await MultipartFile.fromFile(path, filename: fileName),
          ),
        );
      }

      final response = await _networkClient.dio.post(
        ApiConstants.orderPhotos(orderId),
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final urls = response.data['urls'] as List<dynamic>;
      return urls.cast<String>();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}