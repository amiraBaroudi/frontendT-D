import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phone);
  Future<AuthTokensModel> verifyOtpAndLogin({
    required String phone,
    required String otp,
  });
  Future<AuthTokensModel> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  });
  Future<AuthTokensModel> login({
    required String phone,
    required String password,
  });
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkClient _networkClient;
  const AuthRemoteDataSourceImpl(this._networkClient);

  @override
  Future<void> sendOtp(String phone) async {
    try {
      await _networkClient.dio.post(
        ApiConstants.resendOtp,
        data: {'phone': phone},
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<AuthTokensModel> verifyOtpAndLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _networkClient.dio.post(
        ApiConstants.verifyOtp,
        data: {'phone': phone, 'otp': otp},
      );
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<AuthTokensModel> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      final response = await _networkClient.dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          if (email != null) 'email': email,
        },
      );
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<AuthTokensModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _networkClient.dio.post(
        ApiConstants.login,
        data: {'phone': phone, 'password': password},
      );
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _networkClient.dio.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _networkClient.dio.get(ApiConstants.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
