import 'dart:async';

import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (prevItem) => CartItem(
              id: prevItem.id,
              title: prevItem.title,
              price: prevItem.price,
              quantity: prevItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
