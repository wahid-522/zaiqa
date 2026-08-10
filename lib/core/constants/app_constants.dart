/// App-wide constants for Zaiqa (ذائقہ).
class AppConstants {
  AppConstants._();

  static const String appName = 'Zaiqa';
  static const String appTagline = 'Urdu for Taste & Flavor';
  static const String currencySymbol = 'Rs.';
  static const double defaultDeliveryFee = 150.0;
  static const double taxRate = 0.05; // 5% GST

  // Standard Padding & Margins
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Standard Radius
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;

  // Cuisine Categories
  static const List<String> cuisineCategories = [
    'All',
    'Biryani & Rice',
    'Karahi & Handi',
    'BBQ & Kebabs',
    'Burgers & Fast Food',
    'Chinese & Asian',
    'Desserts & Sweets',
    'Beverages',
  ];
}
