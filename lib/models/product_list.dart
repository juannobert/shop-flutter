import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  


  //Cria um clone da lista de itens sem dar acesso a referência
  List<Product> get items => [..._items];

  List<Product> get favoriteItems => items.where((element) => element.isFavorite).toList();


  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}