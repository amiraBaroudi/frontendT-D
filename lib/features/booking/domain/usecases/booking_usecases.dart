import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/booking_repository.dart';

class GetPriceEstimateUseCase {
  final BookingRepository _repository;
  const GetPriceEstimateUseCase(this._repository);

  Future<Either<Failure, PriceEstimateEntity>> call({
    required BookingRequestEntity request,
  }) =>
      _repository.getPriceEstimate(request: request);
}

class CreateOrderUseCase {
  final BookingRepository _repository;
  const CreateOrderUseCase(this._repository);

  Future<Either<Failure, OrderEntity>> call({
    required BookingRequestEntity request,
  }) =>
      _repository.createOrder(request: request);
}

class GetOrderHistoryUseCase {
  final BookingRepository _repository;
  const GetOrderHistoryUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call() =>
      _repository.getOrderHistory();
}

class GetOrderByIdUseCase {
  final BookingRepository _repository;
  const GetOrderByIdUseCase(this._repository);

  Future<Either<Failure, OrderEntity>> call(String orderId) =>
      _repository.getOrderById(orderId);
}

class CancelOrderUseCase {
  final BookingRepository _repository;
  const CancelOrderUseCase(this._repository);

  Future<Either<Failure, void>> call(String orderId) =>
      _repository.cancelOrder(orderId);
}

class UploadOrderPhotosUseCase {
  final BookingRepository _repository;
  const UploadOrderPhotosUseCase(this._repository);

  Future<Either<Failure, List<String>>> call({
    required String orderId,
    required List<String> localPaths,
  }) =>
      _repository.uploadOrderPhotos(orderId: orderId, localPaths: localPaths);
}