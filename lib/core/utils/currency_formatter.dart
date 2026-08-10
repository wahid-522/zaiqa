import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '${AppConstants.currencySymbol} ${formatter.format(amount)}';
  }
}
