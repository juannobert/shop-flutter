import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final List<Product> _items = [];
  final _url =
      "https://shop-flutter-6159e-default-rtdb.firebaseio.com/products.json";

  //Cria um clone da lista de itens sem dar acesso a referência
  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      items.where((element) => element.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse(_url));
    if(response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      print(productData);
      _items.add(
        Product(
          id: productId,
          title: productData["title"] as String,
          description: productData["description"] as String,
          price: productData["price"] as double, 
          imageUrl: productData["imageUrl"] as String,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addProductFromData(Map<String, Object> formData) {
    bool hasId = formData['id'] != null;

    final product = Product(
        id: hasId ? formData['id'] as String : Random().nextDouble().toString(),
        title: formData['title'] as String,
        description: formData['description'] as String,
        imageUrl: formData['imgUrl'] as String,
        price: formData['price'] as double);

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(Uri.parse(_url),
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'isFavorite': product.isFavorite,
          'imageUrl': product.imageUrl
        }));
    String id =
        jsonDecode(response.body)['name']; //pegado id gerado pelo firebase
    _items.add(Product(
        id: id,
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price));
    notifyListeners();
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
