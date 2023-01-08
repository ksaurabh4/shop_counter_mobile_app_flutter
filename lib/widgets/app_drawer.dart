import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/helpers/custom_route.dart';
import 'package:shop_counter/providers/auth.dart';
import 'package:shop_counter/screens/order_screen.dart';
import 'package:shop_counter/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hi, User'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              // Navigator.of(context).pushReplacement(CustomRoute(
              //     builder: (ctx) => const OrderScreen(), settings: null));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.insert_emoticon),
            title: const Text('Your Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
