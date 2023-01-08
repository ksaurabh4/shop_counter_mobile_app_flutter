import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_counter/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items
        .where(
          (item) => item.isFavorite,
        )
        .toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> fetchAndSetProducts() async {
    Uri url = Uri.https(
        'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json',
        {'auth': authToken, 'orderBy': '"creatorId"', 'equalTo': '"$userId"'});
    try {
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>?;
      if (data == null) {
        return;
      }
      Uri favUrl = Uri.https(
          'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/userFavorites/$userId.json',
          {'auth': authToken});
      final favDataRes = await http.get(favUrl);
      final favData = json.decode(favDataRes.body) as Map<String, dynamic>?;

      List<Product> loadedProducts = [];
      data.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favData == null ? false : favData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addProduct(product) async {
    print(product);
    Uri url = Uri.https(
        'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json', {
      'auth': authToken,
    });
    try {
      final res = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
            'creatorId': userId,
          }));
      print(json.decode(res.body));
      final Product newItem = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> editProduct(String id, Product product) async {
    try {
      final pIndex = _items.indexWhere((el) => el.id == id);
      if (pIndex > -1) {
        Uri url = Uri.https(
            'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
            '/products/$id.json',
            {'auth': authToken});
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageUrl': product.imageUrl,
            }));
        _items[pIndex] = product;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeProduct(String id) async {
    int? exitingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[exitingProductIndex];
    _items.removeAt(exitingProductIndex);
    notifyListeners();
    try {
      Uri url = Uri.https(
          'shop-counter-4dc81-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/products/$id.json',
          {'auth': authToken});
      final res = await http.delete(url);
      if (res.statusCode >= 400) {
        throw const HttpException('Could not delete this product');
      }
      exitingProductIndex = null;
      existingProduct = null;
    } catch (e) {
      _items.insert(exitingProductIndex as int, existingProduct as Product);
      notifyListeners();
    }
  }
}
