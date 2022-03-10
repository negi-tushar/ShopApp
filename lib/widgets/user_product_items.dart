import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_products.dart';

class UserProductItems extends StatelessWidget {
  const UserProductItems(
      {required this.id, required this.imageUrl, required this.title, Key? key})
      : super(key: key);
  final String id;

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProducts.id, arguments: id);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure to Delete the product'),
                      actions: [
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () async {
                            try {
                              Navigator.pop(context);
                              await Provider.of<Products>(context,
                                      listen: false)
                                  .deleteProduct(id);
                            } catch (error) {
                              scaffold.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Item cannot be Deleted!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No')),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
