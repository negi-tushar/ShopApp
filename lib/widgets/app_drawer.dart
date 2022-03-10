import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders.dart';

import 'package:shop_app/screens/products_overview.dart';
import 'package:shop_app/screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        child: Column(
          children: [
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home_max_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    ProductsOverViewScreen.id, (route) => false);
              },
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.shop_sharp),
                title: const Text('Orders'),
                onTap: () {
                  Navigator.of(context).restorablePushNamed(Orders.id);
                }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart_outlined),
              title: const Text('Products'),
              onTap: () {
                Navigator.of(context).restorablePushNamed(UserProducts.id);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
