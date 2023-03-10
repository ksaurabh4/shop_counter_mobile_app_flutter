import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  const UserProductItem(
      {super.key,
      required this.productId,
      required this.imageUrl,
      required this.title});

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    final scafford = const SnackBar(content: Text('Unable to Delete!'));
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: productId);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(productId);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(scafford);
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                )),
          ],
        ),
      ),
    );
  }
}
