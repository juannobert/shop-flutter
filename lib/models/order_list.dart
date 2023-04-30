import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  void addOrder(Cart cart) {
    _items.add(
      Order(
          id: Random().nextDouble().toString(),
          products: cart.items.values.toList(),
          total: cart.totalAmount,
          date: DateTime.now()),
    );
    notifyListeners();
  }
}
