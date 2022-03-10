import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

// ignore: camel_case_types
class Products_Grid extends StatelessWidget {
  const Products_Grid({
    required this.showFavs,
    Key? key,
  }) : super(key: key);
  final bool showFavs;
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Products>(context);
    final products =
        showFavs ? providerData.showFavourites : providerData.items;
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const Products_item(
            // id: products[index].id,
            // imageUrl: products[index].imageUrl,
            // title: products[index].title,
            ),
      ),
      padding: const EdgeInsets.all(10.0),
    );
  }
}
