import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constraints.dart';

class ProductList with ChangeNotifier {
  final String  _token;
  final String _userId;

  
  List<Product> _items = [];


  //Cria um clone da lista de itens sem dar acesso a referência
  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      items.where((element) => element.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }
  ProductList(this._token,this._items,this._userId);

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse("${Constraints.PRODUCTS}.json?auth=$_token"));
    if(response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    final favResponse = await http.get(Uri.parse("${Constraints.USER_FAVORITE}/$_userId.json?auth=$_token"));
      
    Map<String,dynamic> favData = favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);
    print(jsonDecode(favResponse.body));


    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          price: productData["price"], 
          imageUrl: productData["imageUrl"],
          isFavorite: isFavorite
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

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
    await http.patch(Uri.parse("${Constraints.PRODUCTS}/${product.id}.json?auth=$_token"),
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl
        }));
      _items[index] = product;
      notifyListeners();
    }

  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(Uri.parse("${Constraints.PRODUCTS}.json?auth=$_token"),
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
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

  Future<void> removeProduct(Product product) async{
    int index = _items.indexWhere((p) => p.id == product.id);


    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();

     final response = await http.delete(Uri.parse("${Constraints.PRODUCTS}/${product.id}.json?auth=$_token"));

     if(response.statusCode >= 400){
      _items.insert(index,product);
      notifyListeners();
      throw HttpException(
        msg: "Não foi possível excluir o produto", 
        statusCode: response.statusCode
      );
     }
    }
  }

 


}
