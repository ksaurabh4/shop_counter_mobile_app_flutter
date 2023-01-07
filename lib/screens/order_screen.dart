import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/orders.dart' show Orders;
import 'package:shop_counter/widgets/app_drawer.dart';
import 'package:shop_counter/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/orders';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(orders.items[i]),
        itemCount: orders.items.length,
      ),
    );
  }
}
