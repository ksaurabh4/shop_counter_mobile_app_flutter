import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void _setFav(newStatus) {
    isFavorite = newStatus;
    notifyListeners();
  }

  Future<void> toggleFavorite(authToken, userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      Uri url = Uri.https(
          'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/userFavorites/$userId/$id.json',
          {'auth': authToken});
      final res = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (res.statusCode >= 400) {
        _setFav(oldStatus);
      }
    } catch (e) {
      _setFav(oldStatus);
    }
  }
}
