import 'package:flutter/material.dart';
import 'package:shop_counter/widgets/products_grid.dart';

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
            )
          ],
        ),
        body: ProductsGrid(_showFavs));
  }
}
