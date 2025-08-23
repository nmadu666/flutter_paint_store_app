import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat('#,##0', 'vi_VN');
String formatPrice(double price) {
  return '${_currencyFormatter.format(price)}đ';
}
