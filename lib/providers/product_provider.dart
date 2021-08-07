import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import 'product.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 97000,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'blue Shirt',
      description: 'blue!',
      price: 50000,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),*/
  ];
  final String authToken;

  ProductProvider(this.authToken, this._items);

  // var _showFavoritesOnly = false;

  List<Product> get getItem {
    /*if(_showFavoritesOnly){
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }*/
    return [..._items];
  }

  List<Product> get favoriteItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    print('desc ${_items.firstWhere((prod) => prod.id == id).description}');
    return _items.firstWhere((prod) => prod.id == id);
  }

  /*void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }*/

  Future<void> getSetProduct() async {
    print('token: $authToken');
    final url = Uri.parse(
        'https://flutter-update-6d1e4-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractData = jsonDecode(response.body) as Map<String, dynamic>;
      /*Map<String, dynamic> tes = {
        'dasda': 90,
        'dddd': 'http',
      };*/
      if (extractData == null) return;
      final List<Product> loadedProduct = [];
      extractData.forEach((prodId, data) {
        loadedProduct.add(Product(
          id: prodId,
          title: data['title'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          isFavorite: data['isFavorite'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
      print(extractData);
    } catch (error) {
      throw (error);
    }
  }

  //add product from manage product
  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://flutter-update-6d1e4-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: jsonDecode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    //item pada index keberapa
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      var url = Uri.parse(
          'https://flutter-update-6d1e4-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse(
        'https://flutter-update-6d1e4-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final response = await http.delete(url);
    if (response.statusCode == 200) _items.removeWhere((prod) => prod.id == id);
    else {
      throw HttpException('message');
    }
    notifyListeners();
  }
}
