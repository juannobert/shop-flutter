import 'dart:convert';
import '../utils/constraints.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier{
  final _baseUrl =
      "https://shop-flutter-6159e-default-rtdb.firebaseio.com";
  final String? id;
  
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false
  });

  void _toggleFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
    
  }
  Future<void> toggleFavorite(String token,String userId) async{
    _toggleFavorite();
     await http.put(Uri.parse("${Constraints.USER_FAVORITE}/$userId/${id!}.json?auth=$token"),
        body: jsonEncode(
         isFavorite
        ));
  }
}