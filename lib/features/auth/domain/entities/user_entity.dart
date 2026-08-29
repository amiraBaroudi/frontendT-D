import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, phone, email, avatarUrl, createdAt];
}

class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, user];
}
