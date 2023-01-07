import 'package:flutter/material.dart';
import 'package:shop_counter/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  final List<OrderItem> _items = [];
  List<OrderItem> get items {
    return [..._items];
  }

  void addOrder(List<CartItem> cartProducts, double totalAmount) {
    _items.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: totalAmount,
            products: cartProducts,
            dateTime: DateTime.now()));
  }
}
