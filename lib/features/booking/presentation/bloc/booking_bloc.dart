import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking_entities.dart';
import '../../domain/usecases/booking_usecases.dart';

// ─── EVENTS ──────────────────────────────────────────────────────────────────

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

// Step 1 - المواقع
class PickupLocationSelected extends BookingEvent {
  final LocationEntity location;
  const PickupLocationSelected(this.location);
  @override
  List<Object> get props => [location];
}

class DropoffLocationSelected extends BookingEvent {
  final LocationEntity location;
  const DropoffLocationSelected(this.location);
  @override
  List<Object> get props => [location];
}

// Step 2 - الأثاث والطوابق
class FurnitureItemUpdated extends BookingEvent {
  final FurnitureCategory category;
  final int quantity;
  const FurnitureItemUpdated({required this.category, required this.quantity});
  @override
  List<Object> get props => [category, quantity];
}

class PickupFloorUpdated extends BookingEvent {
  final FloorInfoEntity floor;
  const PickupFloorUpdated(this.floor);
  @override
  List<Object> get props => [floor];
}

class DropoffFloorUpdated extends BookingEvent {
  final FloorInfoEntity floor;
  const DropoffFloorUpdated(this.floor);
  @override
  List<Object> get props => [floor];
}

// Step 3 - الصور والموعد
class PhotoAdded extends BookingEvent {
  final String photoPath;
  const PhotoAdded(this.photoPath);
  @override
  List<Object> get props => [photoPath];
}

class PhotoRemoved extends BookingEvent {
  final int index;
  const PhotoRemoved(this.index);
  @override
  List<Object> get props => [index];
}

class ScheduleTypeChanged extends BookingEvent {
  final ScheduleType scheduleType;
  final DateTime? scheduledAt;
  const ScheduleTypeChanged({required this.scheduleType, this.scheduledAt});
  @override
  List<Object?> get props => [scheduleType, scheduledAt];
}

class PaymentMethodChanged extends BookingEvent {
  final String method;
  const PaymentMethodChanged(this.method);
  @override
  List<Object> get props => [method];
}

// Actions
class PriceEstimateRequested extends BookingEvent {
  const PriceEstimateRequested();
}

class OrderConfirmed extends BookingEvent {
  const OrderConfirmed();
}

class OrderCancelled extends BookingEvent {
  final String orderId;
  const OrderCancelled(this.orderId);
  @override
  List<Object> get props => [orderId];
}

class BookingReset extends BookingEvent {
  const BookingReset();
}

class OrderHistoryRequested extends BookingEvent {
  const OrderHistoryRequested();
}

// ─── STATES ──────────────────────────────────────────────────────────────────

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

// حالة تجميع البيانات عبر الخطوات
class BookingInProgress extends BookingState {
  final BookingRequestEntity request;
  final int currentStep; // 1, 2, 3

  const BookingInProgress({
    required this.request,
    this.currentStep = 1,
  });

  BookingInProgress copyWith({
    BookingRequestEntity? request,
    int? currentStep,
  }) {
    return BookingInProgress(
      request:     request     ?? this.request,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object> get props => [request, currentStep];
}

class BookingPriceLoading extends BookingState {
  final BookingRequestEntity request;
  const BookingPriceLoading(this.request);
  @override
  List<Object> get props => [request];
}

class BookingPriceLoaded extends BookingState {
  final BookingRequestEntity request;
  final PriceEstimateEntity estimate;

  const BookingPriceLoaded({
    required this.request,
    required this.estimate,
  });

  @override
  List<Object> get props => [request, estimate];
}

class BookingSubmitting extends BookingState {
  const BookingSubmitting();
}

class BookingSuccess extends BookingState {
  final OrderEntity order;
  const BookingSuccess(this.order);
  @override
  List<Object> get props => [order];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object> get props => [message];
}

class OrderHistoryLoading extends BookingState {
  const OrderHistoryLoading();
}

class OrderHistoryLoaded extends BookingState {
  final List<OrderEntity> orders;
  const OrderHistoryLoaded(this.orders);
  @override
  List<Object> get props => [orders];
}

class OrderCancelSuccess extends BookingState {
  const OrderCancelSuccess();
}

// ─── BLOC ────────────────────────────────────────────────────────────────────

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetPriceEstimateUseCase _getPriceEstimate;
  final CreateOrderUseCase _createOrder;
  final GetOrderHistoryUseCase _getOrderHistory;
  final CancelOrderUseCase _cancelOrder;

  // الـ request الذي يُبنى تدريجياً عبر الخطوات
  BookingRequestEntity _currentRequest = BookingRequestEntity(
    pickup:       const LocationEntity(latitude: 0, longitude: 0, address: ''),
    dropoff:      const LocationEntity(latitude: 0, longitude: 0, address: ''),
    pickupFloor:  const FloorInfoEntity(floorNumber: 0, hasElevator: false),
    dropoffFloor: const FloorInfoEntity(floorNumber: 0, hasElevator: false),
    items:        const [],
    scheduleType: ScheduleType.immediate,
  );

  BookingBloc({
    required GetPriceEstimateUseCase getPriceEstimate,
    required CreateOrderUseCase createOrder,
    required GetOrderHistoryUseCase getOrderHistory,
    required CancelOrderUseCase cancelOrder,
  })  : _getPriceEstimate = getPriceEstimate,
        _createOrder = createOrder,
        _getOrderHistory = getOrderHistory,
        _cancelOrder = cancelOrder,
        super(const BookingInitial()) {
    on<PickupLocationSelected>(_onPickupSelected);
    on<DropoffLocationSelected>(_onDropoffSelected);
    on<FurnitureItemUpdated>(_onFurnitureUpdated);
    on<PickupFloorUpdated>(_onPickupFloorUpdated);
    on<DropoffFloorUpdated>(_onDropoffFloorUpdated);
    on<PhotoAdded>(_onPhotoAdded);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<ScheduleTypeChanged>(_onScheduleChanged);
    on<PaymentMethodChanged>(_onPaymentChanged);
    on<PriceEstimateRequested>(_onPriceEstimate);
    on<OrderConfirmed>(_onOrderConfirmed);
    on<OrderCancelled>(_onOrderCancelled);
    on<BookingReset>(_onReset);
    on<OrderHistoryRequested>(_onOrderHistory);
  }

  // Step 1 handlers
  void _onPickupSelected(PickupLocationSelected e, Emitter<BookingState> emit) {
    _currentRequest = _currentRequest.copyWith(pickup: e.location);
    emit(BookingInProgress(request: _currentRequest, currentStep: 1));
  }

  void _onDropoffSelected(DropoffLocationSelected e, Emitter<BookingState> emit) {
    _currentRequest = _currentRequest.copyWith(dropoff: e.location);
    emit(BookingInProgress(request: _currentRequest, currentStep: 1));
  }

  // Step 2 handlers
  void _onFurnitureUpdated(FurnitureItemUpdated e, Emitter<BookingState> emit) {
    final items = List<FurnitureItemEntity>.from(_currentRequest.items);
    final idx = items.indexWhere((i) => i.category == e.category);

    if (e.quantity == 0) {
      // إزالة العنصر إذا الكمية صفر
      if (idx != -1) items.removeAt(idx);
    } else if (idx != -1) {
      // تحديث الكمية
      items[idx] = items[idx].copyWith(quantity: e.quantity);
    } else {
      // إضافة عنصر جديد
      items.add(FurnitureItemEntity(category: e.category, quantity: e.quantity));
    }

    _currentRequest = _currentRequest.copyWith(items: items);
    emit(BookingInProgress(request: _currentRequest, currentStep: 2));
  }

  void _onPickupFloorUpdated(PickupFloorUpdated e, Emitter<BookingState> emit) {
    _currentRequest = _currentRequest.copyWith(pickupFloor: e.floor);
    emit(BookingInProgress(request: _currentRequest, currentStep: 2));
  }

  void _onDropoffFloorUpdated(DropoffFloorUpdated e, Emitter<BookingState> emit) {
    _currentRequest = _currentRequest.copyWith(dropoffFloor: e.floor);
    emit(BookingInProgress(request: _currentRequest, currentStep: 2));
  }

  // Step 3 handlers
  void _onPhotoAdded(PhotoAdded e, Emitter<BookingState> emit) {
    final photos = List<String>.from(_currentRequest.photoPaths)..add(e.photoPath);
    _currentRequest = _currentRequest.copyWith(photoPaths: photos);
    emit(BookingInProgress(request: _currentRequest, currentStep: 3));
  }

  void _onPhotoRemoved(PhotoRemoved e, Emitter<BookingState> emit) {
    final photos = List<String>.from(_currentRequest.photoPaths)..removeAt(e.index);
    _currentRequest = _currentRequest.copyWith(photoPaths: photos);
    emit(BookingInProgress(request: _currentRequest, currentStep: 3));
  }

  void _onScheduleChanged(ScheduleTypeChanged e, Emitter<BookingState> emit) {
    _currentRequest = _currentRequest.copyWith(
      scheduleType: e.scheduleType,
      scheduledAt:  e.scheduledAt,
    );
    emit(BookingInProgress(request: _currentRequest, currentStep: 3));
  }

  void _onPaymentChanged(PaymentMethodChanged e, Emitter<BookingState> emit) {
    _currentRequest = _currentRequest.copyWith(paymentMethod: e.method);
    emit(BookingInProgress(request: _currentRequest, currentStep: 3));
  }

  // Price estimate
  Future<void> _onPriceEstimate(
    PriceEstimateRequested e,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingPriceLoading(_currentRequest));
    final result = await _getPriceEstimate(request: _currentRequest);
    result.fold(
      (f) => emit(BookingError(f.message)),
      (estimate) => emit(BookingPriceLoaded(
        request: _currentRequest,
        estimate: estimate,
      )),
    );
  }

  // Create order
  Future<void> _onOrderConfirmed(
    OrderConfirmed e,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingSubmitting());
    final result = await _createOrder(request: _currentRequest);
    result.fold(
      (f) => emit(BookingError(f.message)),
      (order) => emit(BookingSuccess(order)),
    );
  }

  // Cancel order
  Future<void> _onOrderCancelled(
    OrderCancelled e,
    Emitter<BookingState> emit,
  ) async {
    final result = await _cancelOrder(e.orderId);
    result.fold(
      (f) => emit(BookingError(f.message)),
      (_) => emit(const OrderCancelSuccess()),
    );
  }

  // Reset booking
  void _onReset(BookingReset e, Emitter<BookingState> emit) {
    _currentRequest = BookingRequestEntity(
      pickup:       const LocationEntity(latitude: 0, longitude: 0, address: ''),
      dropoff:      const LocationEntity(latitude: 0, longitude: 0, address: ''),
      pickupFloor:  const FloorInfoEntity(floorNumber: 0, hasElevator: false),
      dropoffFloor: const FloorInfoEntity(floorNumber: 0, hasElevator: false),
      items:        const [],
      scheduleType: ScheduleType.immediate,
    );
    emit(const BookingInitial());
  }

  // Order history
  Future<void> _onOrderHistory(
    OrderHistoryRequested e,
    Emitter<BookingState> emit,
  ) async {
    emit(const OrderHistoryLoading());
    final result = await _getOrderHistory();
    result.fold(
      (f) => emit(BookingError(f.message)),
      (orders) => emit(OrderHistoryLoaded(orders)),
    );
  }
}