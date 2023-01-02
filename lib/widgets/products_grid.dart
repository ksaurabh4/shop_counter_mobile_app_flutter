import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/products.dart';
import 'package:shop_counter/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid(
    this.showFavs, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favItems : productsData.items;
    print(products[0].title);
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: const ProductItem(),
            ));
  }
}
