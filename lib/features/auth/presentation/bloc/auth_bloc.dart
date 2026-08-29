import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';

// ─── EVENTS ────────────────────────────────────────────────────────────────
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String phone;
  final String password;
  const LoginRequested({required this.phone, required this.password});
  @override
  List<Object> get props => [phone, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String password;
  final String? email;
  const RegisterRequested({
    required this.name,
    required this.phone,
    required this.password,
    this.email,
  });
  @override
  List<Object?> get props => [name, phone, password, email];
}

class SendOtpRequested extends AuthEvent {
  final String phone;
  const SendOtpRequested(this.phone);
  @override
  List<Object> get props => [phone];
}

class VerifyOtpRequested extends AuthEvent {
  final String phone;
  final String otp;
  const VerifyOtpRequested({required this.phone, required this.otp});
  @override
  List<Object> get props => [phone, otp];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthStatusRequested extends AuthEvent {
  const CheckAuthStatusRequested();
}

// ─── STATES ────────────────────────────────────────────────────────────────
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState { const AuthInitial(); }
class AuthLoading extends AuthState { const AuthLoading(); }

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState { const AuthUnauthenticated(); }

class AuthOtpSent extends AuthState {
  final String phone;
  const AuthOtpSent(this.phone);
  @override
  List<Object> get props => [phone];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

class AuthLoggedOut extends AuthState { const AuthLoggedOut(); }

// ─── BLOC ──────────────────────────────────────────────────────────────────
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._sendOtpUseCase,
    this._verifyOtpUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(const AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<SendOtpRequested>(_onSendOtp);
    on<VerifyOtpRequested>(_onVerifyOtp);
    on<LogoutRequested>(_onLogout);
    on<CheckAuthStatusRequested>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(phone: e.phone, password: e.password);
    result.fold(
      (f) => emit(AuthError(f.message)),
      (t) => emit(AuthAuthenticated(t.user)),
    );
  }

  Future<void> _onRegister(RegisterRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      name: e.name, phone: e.phone, password: e.password, email: e.email,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (t) => emit(AuthAuthenticated(t.user)),
    );
  }

  Future<void> _onSendOtp(SendOtpRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _sendOtpUseCase(e.phone);
    result.fold(
      (f) => emit(AuthError(f.message)),
      (_) => emit(AuthOtpSent(e.phone)),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _verifyOtpUseCase(phone: e.phone, otp: e.otp);
    result.fold(
      (f) => emit(AuthError(f.message)),
      (t) => emit(AuthAuthenticated(t.user)),
    );
  }

  Future<void> _onLogout(LogoutRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await _logoutUseCase();
    emit(const AuthLoggedOut());
  }

  Future<void> _onCheckAuth(CheckAuthStatusRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _getCurrentUserUseCase();
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
