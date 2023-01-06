import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String id;
  final double price;
  final int quantity;
  final Function removeItem;
  const CartItem(
      {super.key,
      required this.title,
      required this.id,
      required this.price,
      required this.quantity,
      required this.removeItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(child: Text('\$$price')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${price * quantity}'),
          trailing: Text('${quantity}x'),
        ),
      ),
    );
  }
}
