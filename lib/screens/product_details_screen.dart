import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static String routeName = '/product-details';
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(title: Text(loadedProduct.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            Text('\$${loadedProduct.price}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
            ),
            Container(
              height: 800,
            )
          ]))
        ],
        // child: Column(
        //   children: [
        //     SizedBox(
        //       height: 300,
        //       width: double.infinity,
        //       child: ,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
