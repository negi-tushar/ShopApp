import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_products.dart';
import 'package:shop_app/screens/orders.dart' as ord;
import 'package:shop_app/screens/product_detail.dart';
import 'package:shop_app/screens/products_overview.dart';
import 'package:shop_app/screens/user_products.dart';
import 'package:shop_app/widgets/splashscree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', '', []),
            update: (context, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders('', '', []),
            update: (context, auth, previousOrders) =>
                Orders(auth.token!, auth.userId, previousOrders!.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? const ProductsOverViewScreen()
                : FutureBuilder(
                    future: auth.autoAuthenticate(),
                    builder: (context, authresultSnapshot) =>
                        authresultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              ProductsOverViewScreen.id: (context) =>
                  const ProductsOverViewScreen(),
              ProductDetail.routeName: (context) => const ProductDetail(),
              CartScreen.id: (context) => const CartScreen(),
              ord.Orders.id: (context) => const ord.Orders(),
              UserProducts.id: (context) => const UserProducts(),
              EditProducts.id: (context) => const EditProducts(),
              AuthScreen.id: (context) => const AuthScreen(),
            },
          ),
        ));
  }
}
