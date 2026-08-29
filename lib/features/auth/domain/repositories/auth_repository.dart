import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp(String phone);

  Future<Either<Failure, AuthTokens>> verifyOtpAndLogin({
    required String phone,
    required String otp,
  });

  Future<Either<Failure, AuthTokens>> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  });

  Future<Either<Failure, AuthTokens>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<bool> isLoggedIn();
}
