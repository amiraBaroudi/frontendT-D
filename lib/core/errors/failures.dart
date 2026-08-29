import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'لا يوجد اتصال بالإنترنت'});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'انتهت مهلة الاتصال، حاول مجدداً'});
}

// Server failures
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'انتهت صلاحية الجلسة، سجّل دخولك مجدداً'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'العنصر المطلوب غير موجود'});
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'خطأ في قراءة البيانات المحلية'});
}

// Auth failures
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({super.message = 'رقم الهاتف أو كلمة المرور غير صحيحة'});
}

class PhoneAlreadyExistsFailure extends Failure {
  const PhoneAlreadyExistsFailure({super.message = 'رقم الهاتف مسجّل مسبقاً'});
}

class InvalidOtpFailure extends Failure {
  const InvalidOtpFailure({super.message = 'رمز التحقق غير صحيح أو منتهي'});
}

// Location failures
class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure({super.message = 'يرجى السماح بالوصول للموقع'});
}

class LocationServiceDisabledFailure extends Failure {
  const LocationServiceDisabledFailure({super.message = 'يرجى تفعيل خدمة الموقع'});
}

// Generic
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'حدث خطأ غير متوقع'});
}
