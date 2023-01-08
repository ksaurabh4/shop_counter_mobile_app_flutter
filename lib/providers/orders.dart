import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_counter/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_counter/providers/product.dart';

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
  List<OrderItem> _items = [];
  final String? authToken;
  final String? userId;

  Orders(this.authToken, this.userId, this._items);
  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      Uri url = Uri.https(
          'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/orders/$userId.json', {
        'auth': authToken,
      });
      final res = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final data = json.decode(res.body) as Map<String, dynamic>?;
      if (data == null) {
        return;
      }
      data.forEach((orderId, order) {
        loadedOrders.add(OrderItem(
            id: orderId,
            amount: order['amount'],
            products: (order['products'] as List<dynamic>)
                .map((pr) => CartItem(
                    id: pr['id'],
                    title: pr['title'],
                    price: pr['price'],
                    quantity: pr['quantity']))
                .toList(),
            dateTime: DateTime.parse(order['dateTime'])));
      });
      _items = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    try {
      final timestamp = DateTime.now();
      Uri url = Uri.https(
          'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/orders/$userId.json',
          {'auth': authToken});
      final res = await http.post(url,
          body: json.encode({
            'amount': totalAmount,
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
            'dateTime': timestamp.toIso8601String(),
          }));
      _items.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: totalAmount,
              products: cartProducts,
              dateTime: DateTime.now()));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
