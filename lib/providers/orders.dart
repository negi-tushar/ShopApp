import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItems {
  final String id;
  final List<CartItem> products;
  final double ammount;
  final DateTime datetime;

  OrderItems({
    required this.id,
    required this.ammount,
    required this.products,
    required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];
  String? authToken;
  String? userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final Uri url = Uri.parse(
        'https://shopapp-bc812-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    final response = await http.get(url);
    final List<OrderItems> existingData = [];
    final loadedData = json.decode(response.body) as Map<String, dynamic>;
    if (loadedData == null) {
      return;
    }
    loadedData.forEach((orderId, orderData) {
      existingData.add(
        OrderItems(
            id: orderId,
            ammount: orderData['amount'],
            datetime: DateTime.parse(orderData['datetime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                      id: e['id'],
                      title: e['title'],
                      quantity: e['quantity'],
                      price: e['price']),
                )
                .toList()),
      );
    });
    _orders = existingData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(
    List<CartItem> cartItems,
    double total,
  ) async {
    final Uri url = Uri.parse(
        'https://shopapp-bc812-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timestamp.toIso8601String(),
          'products': cartItems
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItems(
            id: json.decode(response.body)['name'],
            ammount: total,
            products: cartItems,
            datetime: timestamp));

    notifyListeners();
  }
}
