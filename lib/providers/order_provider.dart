import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

// import 'package:shopapp/widgets/cart_item.dart';

class OrderItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final DateTime dateTime;

  OrderItemProvider({this.id, this.amount, this.products, this.dateTime});
}

class OrderProvider with ChangeNotifier {
  final String authToken;

  OrderProvider(this.authToken, this._orders);

  List<OrderItemProvider> _orders = [];

  List<OrderItemProvider> get getOrder {
    return [..._orders];
  }

  Future<void> getSetOrder() async {
    var url = Uri.parse(
        'https://flutter-update-6d1e4-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItemProvider> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, data) {
      loadedOrders.add(OrderItemProvider(
          id: orderId,
          dateTime: DateTime.parse(data['dateTime']),
          amount: data['amount'],
          products: (data['products'] as List<dynamic>)
              .map((item) => CartItemProvider(
                    id: item['id'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity'],
                  ))
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
    print(jsonDecode(response.body));
  }

  Future<void> addOrder(
      List<CartItemProvider> cartProducts, double total) async {
    var url = Uri.parse(
        'https://flutter-update-6d1e4-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'quantity': prod.quantity,
                    'price': prod.price,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItemProvider(
          id: jsonDecode(response.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
    } catch (error) {}
    notifyListeners();
  }
}
