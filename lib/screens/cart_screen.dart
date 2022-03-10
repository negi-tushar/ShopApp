import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/orders.dart' as ord;
import 'package:shop_app/widgets/cartlist.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static String id = 'cartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cart.cartTotal <= 0.0
          ? const Center(
              child: Text(
                'Your cart is Empty',
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                Card(
                  color: Colors.amber.shade100,
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Chip(
                        label: Text('\$${cart.cartTotal}'),
                        backgroundColor: Colors.red.shade200,
                      ),
                      OrderButton(cart: cart),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: cart.items.length,
                    itemBuilder: (conetxt, index) => CartList(
                      productId: cart.items.keys.toList()[index],
                      id: cart.items.values.toList()[index].id,
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity,
                      title: cart.items.values.toList()[index].title,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

var _isLoading = false;

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        Navigator.pushNamedAndRemoveUntil(
            context, ord.Orders.id, (route) => true);

        await Provider.of<Orders>(context, listen: false).addOrders(
            widget.cart.items.values.toList(), widget.cart.cartTotal);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
      child: _isLoading
          ? const CircularProgressIndicator(
              strokeWidth: 1.0,
              color: Colors.white,
            )
          : const Text('Order Now'),
    );
  }
}
