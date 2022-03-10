import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:shop_app/widgets/order_item.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  static String id = 'Orders';

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<ord.Orders>(context);
    print('build called');
    return Scaffold(
      appBar: AppBar(
        title: const Text('orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<ord.Orders>(context, listen: false).fetchOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            const Center(child: CircularProgressIndicator());
          }
          if (dataSnapshot.error != null) {
            return const Text('An error Ocurred!');
          } else {
            return Column(
              children: [
                Expanded(
                    child: Consumer<ord.Orders>(
                  builder: (context, orderData, _) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) => OrderItem(
                      orders: orderData.orders[index],
                    ),
                  ),
                )),
              ],
            );
          }
        },
      ),

      // _isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : ordersData.orders.isEmpty
      //         ? const Center(
      //             child: Text('You do not havve any orders'),
      //           )
      //         : Column(
      //             children: [
      //               Expanded(
      //                 child: ListView.builder(
      //                   shrinkWrap: true,
      //                   itemCount: ordersData.orders.length,
      //                   itemBuilder: (context, index) => OrderItem(
      //                     orders: ordersData.orders[index],
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
    );
  }
}
