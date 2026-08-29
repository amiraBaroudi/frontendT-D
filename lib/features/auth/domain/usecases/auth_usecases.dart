import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);
  Future<Either<Failure, AuthTokens>> call({
    required String phone,
    required String password,
  }) => _repository.login(phone: phone, password: password);
}

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);
  Future<Either<Failure, AuthTokens>> call({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) => _repository.register(name: name, phone: phone, password: password, email: email);
}

class SendOtpUseCase {
  final AuthRepository _repository;
  const SendOtpUseCase(this._repository);
  Future<Either<Failure, void>> call(String phone) => _repository.sendOtp(phone);
}

class VerifyOtpUseCase {
  final AuthRepository _repository;
  const VerifyOtpUseCase(this._repository);
  Future<Either<Failure, AuthTokens>> call({
    required String phone,
    required String otp,
  }) => _repository.verifyOtpAndLogin(phone: phone, otp: otp);
}

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);
  Future<Either<Failure, void>> call() => _repository.logout();
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  const GetCurrentUserUseCase(this._repository);
  Future<Either<Failure, UserEntity>> call() => _repository.getCurrentUser();
}
