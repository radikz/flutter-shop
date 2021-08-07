import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemProvider> _items = {};

  Map<String, CartItemProvider> get getItems {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingItem) => CartItemProvider(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity + 1));
    } else { //tambah jika key tidak ada
      _items.putIfAbsent(
          id,
          () => CartItemProvider(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    //kalo produk kosong return nothing
    if (!_items.containsKey(productId)) {
      return;
    }
    //kalo produk lebih dari satu, kuantiti - 1
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItemProvider(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    }
    else { //kalo kuantiti 1 maka hapus produk
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

class CartItemProvider {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItemProvider({this.id, this.title, this.quantity, this.price});
}
