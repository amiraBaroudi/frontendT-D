import 'package:get_it/get_it.dart';
import 'core/network/network_client.dart';
import 'core/router/app_router.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/location_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/booking/data/datasources/booking_remote_datasource.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/booking_usecases.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── Core Services ────────────────────────────────────────────────────────
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  sl.registerLazySingleton<LocationService>(
    () => LocationService(),
  );
  sl.registerLazySingleton<NetworkClient>(
    () => NetworkClient(sl<SecureStorageService>()),
  );
  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(sl<SecureStorageService>()),
  );

  // ─── Auth Feature ─────────────────────────────────────────────────────────

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<NetworkClient>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<SecureStorageService>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SendOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      sl<LoginUseCase>(),
      sl<RegisterUseCase>(),
      sl<SendOtpUseCase>(),
      sl<VerifyOtpUseCase>(),
      sl<LogoutUseCase>(),
      sl<GetCurrentUserUseCase>(),
    ),
  );

  // ─── Booking Feature ──────────────────────────────────────────────────────
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(sl<NetworkClient>()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl<BookingRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetPriceEstimateUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => CreateOrderUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => GetOrderHistoryUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => CancelOrderUseCase(sl<BookingRepository>()));
  sl.registerFactory(
    () => BookingBloc(
      getPriceEstimate: sl<GetPriceEstimateUseCase>(),
      createOrder: sl<CreateOrderUseCase>(),
      getOrderHistory: sl<GetOrderHistoryUseCase>(),
      cancelOrder: sl<CancelOrderUseCase>(),
    ),
  );
}
