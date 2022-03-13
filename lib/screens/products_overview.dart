import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/prodects_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}
bool _isInit = true;
bool _isLoading = false;

class ProductsOverViewScreen extends StatefulWidget {
  const ProductsOverViewScreen({Key? key}) : super(key: key);

  static String id = 'ProductsOverViewScreen';

  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

bool _showFavourites = false;
int value = 2;

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchproducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print('Products overview');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laalsa'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedvalue) {
              setState(() {
                if (selectedvalue == FilterOptions.Favourites) {
                  _showFavourites = true;
                } else {
                  _showFavourites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Favourites'),
                value: FilterOptions.Favourites,
              ),
              const PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              )
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.id);
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              Consumer<Cart>(
                builder: (context, cartData, _) => Positioned(
                  left: 27,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    //constraints: BoxConstraints(minHeight: 16, minWidth: 16),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: (value > 20)
                        ? const Text(
                            '20+',
                            style: TextStyle(fontSize: 12),
                          )
                        : Text(cartData.itemCount.toString(),
                            style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Products_Grid(showFavs: _showFavourites),
    );
  }
}
