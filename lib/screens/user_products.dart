import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_items.dart';

class UserProducts extends StatelessWidget {
  const UserProducts({Key? key}) : super(key: key);

  static String id = 'UserProducts';
  Future<void> onRefreshedData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchproducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('build called');

    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProducts.id);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: onRefreshedData(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => onRefreshedData(context),
                child: Column(
                  children: [
                    Consumer<Products>(
                      builder: (context, productsData, _) => Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productsData.items.length,
                            itemBuilder: (_, i) => Column(
                                  children: [
                                    UserProductItems(
                                      id: productsData.items[i].id,
                                      imageUrl: productsData.items[i].imageUrl,
                                      title: productsData.items[i].title,
                                    ),
                                    const Divider(),
                                  ],
                                )),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
