import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<String> toggleFavoriteStatus(String authToken) async {
    isFavorite = !isFavorite;
    var url = Uri.parse(
        'https://flutter-update-6d1e4-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    try {
      await http.patch(
        url,
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );
      if(isFavorite) return 'Added to favorite';
      else return '';
    } catch (error) {
      return '$error';
    }
    finally{
      notifyListeners();
    }
  }
}
