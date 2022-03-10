import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartList extends StatelessWidget {
  const CartList(
      {required this.title,
      required this.price,
      required this.quantity,
      required this.id,
      required this.productId,
      Key? key})
      : super(key: key);
  final String title;
  final String productId;
  final double price;
  final int quantity;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // title: const Text('Are you sure?'),
            content: const Text('Do you want to delete the Item?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes')),
            ],
          ),
        );
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          size: 50,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: ListTile(
            //     leading: Text(id),
            title: Text(title),
            subtitle: Text('Toatl Price : ${price * quantity}'),
            trailing: Text(quantity.toString() + ' x'),
          ),
        ),
      ),
    );
  }
}
