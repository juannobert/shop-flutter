import 'package:shop/models/cart_item.dart';

class Order{
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.products,
    required this.total,
    required this.date
  });
}