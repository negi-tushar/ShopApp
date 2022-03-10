import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  late final String id, title, description, imageUrl;
  late double price;
  late bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavourite = false});

  Future<void> toggleFavouriteStatus(String? authToken, String? userId) async {
    final oldValue = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    Uri url = Uri.parse(
        'https://shopapp-bc812-default-rtdb.firebaseio.com/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldValue;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldValue;
      notifyListeners();
    }
  }
}
