import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount {
    return _items.length;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId]?.quantity == 1) {
      removeItem(productId);
    } else {
      _items.update(
          productId,
          (existingValue) => CartItem(
                id: existingValue.id,
                productId: existingValue.productId,
                price: existingValue.price,
                quantity: existingValue.quantity - 1,
                title: existingValue.title,
              ));
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingValue) => CartItem(
              id: existingValue.id,
              productId: existingValue.productId,
              price: existingValue.price,
              quantity: existingValue.quantity + 1,
              title: existingValue.title));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
                id: Random().nextDouble().toString(),
                productId: product.id,
                price: product.price,
                quantity: 1,
                title: product.title,
              ));
    }
    notifyListeners();
  }
}
