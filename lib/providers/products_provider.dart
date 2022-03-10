import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import './products.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p5',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 5999,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 1999,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 4999,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String? authToken;
  String? userId;

  Products(this.authToken, this.userId, this._items);

  var _showFavaouritesOnly = false;

  List<Product> get items {
    // if (_showFavaouritesOnly) {
    //   return _items.where((proditem) => proditem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get showFavourites {
    return _items.where((proditem) => proditem.isFavourite).toList();
  }

  Future<void> fetchproducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    Uri url = Uri.parse(
        'https://shopapp-bc812-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      // ignore: unnecessary_null_comparison
      if (fetchedData == null) {
        return;
      }
      Uri url2 = Uri.parse(
          'https://shopapp-bc812-default-rtdb.firebaseio.com/$userId.json?auth=$authToken');
      final favouriteResponse = await http.get(url2);
      final favData = json.decode(favouriteResponse.body);
      fetchedData.forEach((prodId, data) {
        loadedProducts.add(Product(
          id: prodId,
          title: data['title'],
          description: data['description'],
          imageUrl: data['imageUrl'],
          price: data['price'],
          isFavourite: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    Uri url = Uri.parse(
        'https://shopapp-bc812-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'userId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      //  print(error);
      rethrow;
    }

    // print(json.decode(response.body)['name']);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var findIndex = _items.indexWhere((prod) => prod.id == id);
    if (findIndex >= 0) {
      Uri url = Uri.parse(
          'https://shopapp-bc812-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl
          }));
      _items[findIndex] = newProduct;
      notifyListeners();
    } else {
      print('.....');
    }
  }

  Future<void> deleteProduct(String id) async {
    Uri url = Uri.parse(
        'https://shopapp-bc812-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final existingProductindex =
        _items.indexWhere((element) => element.id == id);
    Product? existingData = _items[existingProductindex];
    _items.removeAt(existingProductindex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductindex, existingData);
      notifyListeners();
      throw HttpException('This cant be deleted');
    }
    existingData = null;
  }
}
