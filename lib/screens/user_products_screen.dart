import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/products.dart';
import 'package:shop_counter/screens/edit_product_screen.dart';
import 'package:shop_counter/widgets/app_drawer.dart';
import 'package:shop_counter/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = '/user-products';
  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (_, i) => Column(
                children: [
                  UserProductItem(
                      productId: products.items[i].id,
                      imageUrl: products.items[i].imageUrl,
                      title: products.items[i].title),
                  const Divider(),
                ],
              ),
              itemCount: products.items.length,
            )),
      ),
    );
  }
}
