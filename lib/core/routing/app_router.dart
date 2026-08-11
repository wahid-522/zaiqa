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
import '../../presentation/features/restaurant_owner/screens/restaurant_menu_management_screen.dart';
import '../../presentation/features/restaurant_owner/screens/restaurant_onboarding_screen.dart';
import '../../presentation/features/review/screens/leave_review_screen.dart';
import '../../presentation/features/review/screens/view_review_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: RouteNames.splashPath,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuth = authState.isAuthenticated;
      final user = authState.user;
      final isSplash = state.matchedLocation == RouteNames.splashPath;
      final isLoggingIn = state.matchedLocation == RouteNames.loginPath ||
          state.matchedLocation == RouteNames.signupPath;

      if (isSplash) {
        return null;
      }

      if (!isAuth && !isLoggingIn) {
        return RouteNames.loginPath;
      }

      if (isAuth) {
        final isRestaurantOwner = user?.isRestaurantOwner ?? false;
        final hasRestaurant = user?.restaurantId != null && user!.restaurantId!.isNotEmpty;
        final isOwnerRoute = state.matchedLocation.startsWith('/restaurant-owner');

        // Role-based redirect upon login/signup
        if (isLoggingIn) {
          if (isRestaurantOwner) {
            return hasRestaurant
                ? RouteNames.restaurantMenuManagementPath
                : RouteNames.restaurantOnboardingPath;
          } else {
            return RouteNames.homePath;
          }
        }

        // Security Guard 1: Customer trying to access Restaurant Owner route -> redirect to Customer Home
        if (!isRestaurantOwner && isOwnerRoute) {
          return RouteNames.homePath;
        }

        // Security Guard 2: Restaurant Owner trying to access Customer route -> redirect to Menu Management
        if (isRestaurantOwner && !isOwnerRoute) {
          return hasRestaurant
              ? RouteNames.restaurantMenuManagementPath
              : RouteNames.restaurantOnboardingPath;
        }
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
        path: RouteNames.restaurantOnboardingPath,
        name: RouteNames.restaurantOnboarding,
        builder: (context, state) => const RestaurantOnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.restaurantMenuManagementPath,
        name: RouteNames.restaurantMenuManagement,
        builder: (context, state) => const RestaurantMenuManagementScreen(),
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
        path: RouteNames.leaveReviewPath,
        name: RouteNames.leaveReview,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return LeaveReviewScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: RouteNames.viewReviewPath,
        name: RouteNames.viewReview,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return ViewReviewScreen(orderId: orderId);
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
