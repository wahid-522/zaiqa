/// Centralized Route Name & Path constants for GoRouter.
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String splashPath = '/splash';

  static const String home = 'home';
  static const String homePath = '/';

  static const String restaurantDetail = 'restaurantDetail';
  static const String restaurantDetailPath = '/restaurant/:id';

  static const String cart = 'cart';
  static const String cartPath = '/cart';

  static const String checkout = 'checkout';
  static const String checkoutPath = '/checkout';

  static const String orderTracking = 'orderTracking';
  static const String orderTrackingPath = '/order-tracking/:orderId';

  static const String profile = 'profile';
  static const String profilePath = '/profile';

  static const String login = 'login';
  static const String loginPath = '/login';

  static const String signup = 'signup';
  static const String signupPath = '/signup';

  static const String accountTypeSelection = 'accountTypeSelection';
  static const String accountTypeSelectionPath = '/account-type-selection';

  static const String addressPicker = 'addressPicker';
  static const String addressPickerPath = '/address-picker';

  static const String savedAddresses = 'savedAddresses';
  static const String savedAddressesPath = '/saved-addresses';

  static const String orders = 'orders';
  static const String ordersPath = '/orders';

  static const String favorites = 'favorites';
  static const String favoritesPath = '/favorites';

  static const String leaveReview = 'leaveReview';
  static const String leaveReviewPath = '/leave-review/:orderId';

  static const String viewReview = 'viewReview';
  static const String viewReviewPath = '/view-review/:orderId';

  static const String restaurantMenuManagement = 'restaurantMenuManagement';
  static const String restaurantMenuManagementPath = '/restaurant-owner/menu';

  static const String restaurantOnboarding = 'restaurantOnboarding';
  static const String restaurantOnboardingPath = '/restaurant-owner/onboarding';
}
