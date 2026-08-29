import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  const AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<Either<Failure, void>> sendOtp(String phone) async {
    try {
      await _remoteDataSource.sendOtp(phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on TimeoutException {
      return const Left(TimeoutFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> verifyOtpAndLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOtpAndLogin(phone: phone, otp: otp);
      await _saveTokens(result);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on TimeoutException {
      return const Left(TimeoutFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        name: name, phone: phone, password: password, email: email,
      );
      await _saveTokens(result);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on TimeoutException {
      return const Left(TimeoutFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(phone: phone, password: password);
      await _saveTokens(result);
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
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {}
    await _storageService.clearAll();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<bool> isLoggedIn() => _storageService.isLoggedIn();

  Future<void> _saveTokens(dynamic result) async {
    await _storageService.saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    await _storageService.saveUserId(result.user.id);
  }
}
