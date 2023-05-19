import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/order.dart';
import 'package:shop/utils/constraints.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async{
    DateTime date = DateTime.now();
    final response = await http.post(
      Uri.parse("${Constraints.ORDERS}.json",
      ),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date' : date.toIso8601String(),
          'products' :  cart.items.values.map((cartItems) => {
            'id' : cartItems.id,
            'productId' : cartItems.productId,
            'quantity' : cartItems.quantity,
            'price' : cartItems.price
          }).toList()
        }
      )
    );

    String id = jsonDecode(response.body)['name'];
    _items.add(
      Order(
          id: id,
          products: cart.items.values.toList(),
          total: cart.totalAmount,
          date: date
        ),
    );
    notifyListeners();
  }
}
