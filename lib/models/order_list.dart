import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/constraints.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

   Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse("${Constraints.ORDERS}.json"));
    if(response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      _items.add(
       Order(
        id: orderId, 
        total: orderData['total'], 
        date: DateTime.parse(orderData['date']),
        products: (orderData['products'] as List<dynamic>).map((item){
          return CartItem(
            id: item['id'], 
            title: item['title'],
            productId: item['productId'],
            price: item['price'], 
            quantity: item['quantity'], 
          );
        }).toList(), 
      )
      );
    });
    notifyListeners();
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
    _items.insert(
      0,
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
