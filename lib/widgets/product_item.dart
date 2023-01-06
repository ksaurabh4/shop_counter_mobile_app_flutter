import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/cart.dart';
import 'package:shop_counter/providers/product.dart';
import 'package:shop_counter/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cartData = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              product.toggleFavorite();
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              cartData.addItem(product.id, product.price, product.title);
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
