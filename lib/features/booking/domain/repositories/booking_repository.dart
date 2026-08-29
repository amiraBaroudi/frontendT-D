import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entities.dart';

abstract class BookingRepository {
  Future<Either<Failure, PriceEstimateEntity>> getPriceEstimate({
    required BookingRequestEntity request,
  });

  Future<Either<Failure, OrderEntity>> createOrder({
    required BookingRequestEntity request,
  });

  Future<Either<Failure, List<OrderEntity>>> getOrderHistory();

  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);

  Future<Either<Failure, void>> cancelOrder(String orderId);

  Future<Either<Failure, List<String>>> uploadOrderPhotos({
    required String orderId,
    required List<String> localPaths,
  });
}