import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/features/splash/screens/splash_screen.dart';
import '../../presentation/features/address_picker/screens/address_picker_screen.dart';
import '../../presentation/features/address_picker/screens/saved_addresses_screen.dart';
import '../../presentation/features/favorites/screens/favorites_screen.dart';
import '../../presentation/features/order_history/screens/order_history_screen.dart';
import '../../presentation/features/auth/screens/login_screen.dart';
import '../../presentation/features/auth/screens/signup_screen.dart';
import '../../presentation/features/auth/viewmodels/auth_viewmodel.dart';
import '../../presentation/features/cart/screens/cart_screen.dart';
import '../../presentation/features/checkout/screens/checkout_screen.dart';
import '../../presentation/features/main_navigation/screens/main_navigation_screen.dart';
import '../../presentation/features/order_tracking/screens/order_tracking_screen.dart';
import '../../presentation/features/profile/screens/profile_screen.dart';
import '../../presentation/features/restaurant_detail/screens/restaurant_detail_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: RouteNames.splashPath,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuth = authState.isAuthenticated;
      final isSplash = state.matchedLocation == RouteNames.splashPath;
      final isLoggingIn = state.matchedLocation == RouteNames.loginPath ||
          state.matchedLocation == RouteNames.signupPath;

      if (isSplash) {
        return null;
      }
      if (!isAuth && !isLoggingIn) {
        return RouteNames.loginPath;
      }
      if (isAuth && isLoggingIn) {
        return RouteNames.homePath;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.homePath,
        name: RouteNames.home,
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signupPath,
        name: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.restaurantDetailPath,
        name: RouteNames.restaurantDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return RestaurantDetailScreen(restaurantId: id);
        },
      ),
      GoRoute(
        path: RouteNames.cartPath,
        name: RouteNames.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RouteNames.checkoutPath,
        name: RouteNames.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RouteNames.addressPickerPath,
        name: RouteNames.addressPicker,
        builder: (context, state) => const AddressPickerScreen(),
      ),
      GoRoute(
        path: RouteNames.savedAddressesPath,
        name: RouteNames.savedAddresses,
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      GoRoute(
        path: RouteNames.ordersPath,
        name: RouteNames.orders,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.favoritesPath,
        name: RouteNames.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RouteNames.orderTrackingPath,
        name: RouteNames.orderTracking,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return OrderTrackingScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: RouteNames.profilePath,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
