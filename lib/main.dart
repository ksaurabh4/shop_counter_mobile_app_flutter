import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Lato',
          colorScheme: const ColorScheme.light(
              primary: Colors.purple, secondary: Colors.deepOrange),
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
        },
      ),
    );
  }
}
