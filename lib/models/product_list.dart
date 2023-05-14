import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  


  //Cria um clone da lista de itens sem dar acesso a referência
  List<Product> get items => [..._items];

  List<Product> get favoriteItems => items.where((element) => element.isFavorite).toList();

   int get itemsCount {
    return _items.length;
  }

  void addProductFromData(Map<String,Object> formData ){

    bool hasId = formData['id'] != null;

    final product = Product(
      id: hasId ? formData['id'] as String : Random().nextDouble().toString(),
      title: formData['title'] as String, 
      description: formData['description'] as String, 
      imageUrl: formData['imgUrl'] as String, 
      price: formData['price'] as double
    );

    if(hasId){
      updateProduct(product);
      
    }else{
      addProduct(product);
    }
  }

  void updateProduct(Product product){
    print("pId $product.id");
    int index = _items.indexWhere((p) => p.id == product.id);
    
    print("index: $index");
    if(index >= 0){
      _items[index] = product;
      notifyListeners();
    }

  }
  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeProduct(Product product){
    int index = _items.indexWhere((p) => p.id == product.id);
    if(index >= 0 ){
      _items.removeAt(index);
      notifyListeners();
    }
  }
}