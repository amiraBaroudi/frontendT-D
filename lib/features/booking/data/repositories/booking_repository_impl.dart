import 'package:dartz/dartz.dart';
import 'package:naql_customer/core/errors/exceptions.dart';
import 'package:naql_customer/core/errors/failures.dart';
import 'package:naql_customer/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:naql_customer/features/booking/domain/entities/booking_entities.dart';
import 'package:naql_customer/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  const BookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PriceEstimateEntity>> getPriceEstimate({
    required BookingRequestEntity request,
  }) async {
    try {
      final result = await _remoteDataSource.getPriceEstimate(request: request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on TimeoutException {
      return const Left(TimeoutFailure());
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required BookingRequestEntity request,
  }) async {
    try {
      final result = await _remoteDataSource.createOrder(request: request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on TimeoutException {
      return const Left(TimeoutFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory() async {
    try {
      final result = await _remoteDataSource.getOrderHistory();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final result = await _remoteDataSource.getOrderById(orderId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      await _remoteDataSource.cancelOrder(orderId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadOrderPhotos({
    required String orderId,
    required List<String> localPaths,
  }) async {
    try {
      final urls = await _remoteDataSource.uploadOrderPhotos(
        orderId: orderId,
        localPaths: localPaths,
      );
      return Right(urls);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}