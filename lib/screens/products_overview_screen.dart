import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/cart.dart';
import 'package:shop_counter/screens/cart_screen.dart';
import 'package:shop_counter/widgets/products_grid.dart';
import '../widgets/custom_badge.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavs = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shop Counter'),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showFavs = true;
                  } else {
                    _showFavs = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text('Only Favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('All'),
                )
              ],
            ),
            Consumer<Cart>(
                builder: (_, cart, ch) => CustomBadge(
                    value: cart.itemCount.toString(),
                    color: Colors.red,
                    child: ch!),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    icon: const Icon(Icons.shopping_cart)))
          ],
        ),
        body: ProductsGrid(_showFavs));
  }
}
