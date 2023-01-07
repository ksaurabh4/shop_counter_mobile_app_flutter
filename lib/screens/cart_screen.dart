import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/cart.dart' show Cart;
import 'package:shop_counter/providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  Row(
                    children: [
                      Chip(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        label: Text(
                            '\$${cartItems.totalAmount.toStringAsFixed(2)}'),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () {
                            Provider.of<Orders>(context, listen: false)
                                .addOrder(cartItems.items.values.toList(),
                                    cartItems.totalAmount);
                            cartItems.clear();
                          },
                          child: const Text('ORDER NOW'))
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                id: cartItems.items.values.toList()[i].id,
                title: cartItems.items.values.toList()[i].title,
                price: cartItems.items.values.toList()[i].price,
                quantity: cartItems.items.values.toList()[i].quantity,
                removeItem: (productId) => cartItems.removeItem(productId),
              ),
              itemCount: cartItems.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
