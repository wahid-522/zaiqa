import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/repositories/order_repository.dart';
import '../../../shared_providers.dart';

class ProfileState {
  final UserProfile? user;
  final List<Order> orderHistory;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.user,
    this.orderHistory = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserProfile? user,
    List<Order>? orderHistory,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      orderHistory: orderHistory ?? this.orderHistory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ProfileViewModel extends StateNotifier<ProfileState> {
  final AuthRepository _authRepository;
  final OrderRepository _orderRepository;

  ProfileViewModel(this._authRepository, this._orderRepository)
      : super(const ProfileState()) {
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final userRes = await _authRepository.getCurrentUser();
    final ordersRes = await _orderRepository.getOrderHistory();

    userRes.when(
      success: (user) {
        ordersRes.when(
          success: (orders) {
            state = state.copyWith(user: user, orderHistory: orders, isLoading: false);
          },
          failure: (_) {
            state = state.copyWith(user: user, isLoading: false);
          },
        );
      },
      failure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  return ProfileViewModel(
    ref.watch(authRepositoryProvider),
    ref.watch(orderRepositoryProvider),
  );
});
