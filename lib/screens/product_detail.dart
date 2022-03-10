import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({
    Key? key,
    // required this.title,
    // required this.imageurl,
    // required this.description,
    // required this.price
  }) : super(key: key);
  // final String title, description, imageurl;
  // final double price;

  static const routeName = '/ProductDetail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // print('Products id is : ' + productId); // arguement id from named route
    final provider_data =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(provider_data.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Material(
              child: Hero(
                tag: provider_data.id,
                child: Image.network(
                  provider_data.imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                ),
              ),
            ),
            Text(provider_data.title),
            Text(provider_data.description),
            Text(provider_data.price.toString()),
            Row(
              children: const [
                ElevatedButton(
                  onPressed: null,
                  child: Text('Add to Cart'),
                ),
                SizedBox(
                  width: 50.0,
                ),
                ElevatedButton(
                  onPressed: null,
                  child: Text('Buy Now'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
