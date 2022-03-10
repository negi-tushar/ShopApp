import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.orders}) : super(key: key);
  final OrderItems orders;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

bool _expanded = false;

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = true;
        });
      },
      child: AnimatedContainer(
        //  color: Colors.blue,
        height:
            _expanded ? min(widget.orders.products.length * 20 + 110, 200) : 80,
        duration: const Duration(milliseconds: 300),
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text('\$ ${widget.orders.ammount.toString()}'),
                subtitle: Text(widget.orders.datetime.toString()),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                // color: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                height: _expanded
                    ? min(widget.orders.products.length * 20 + 20, 150)
                    : 0,
                child: ListView(
                  shrinkWrap: true,
                  children: widget.orders.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(prod.title),
                              Text('${prod.quantity}  x  \$ ${prod.price}'),
                            ],
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
