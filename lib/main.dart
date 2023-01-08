import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/orders.dart';
import 'package:shop_counter/screens/auth_screen.dart';
import 'package:shop_counter/screens/cart_screen.dart';
import 'package:shop_counter/screens/order_screen.dart';
import 'package:shop_counter/screens/user_products_screen.dart';
import 'package:shop_counter/screens/edit_product_screen.dart';
import './providers/cart.dart';
import 'package:shop_counter/screens/product_details_screen.dart';
import 'package:shop_counter/screens/splash_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(null, null, []),
            update: (ctx, auth, prevProducts) => Products(auth.token,
                auth.userId, prevProducts == null ? [] : prevProducts.items)),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(null, null, []),
            update: (ctx, auth, prevOrders) => Orders(auth.token, auth.userId,
                prevOrders == null ? [] : prevOrders.items)),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                    primarySwatch: Colors.purple,
                    fontFamily: 'Lato',
                    colorScheme: const ColorScheme.light(
                        primary: Colors.purple, secondary: Colors.deepOrange),
                    pageTransitionsTheme: PageTransitionsTheme(builders: {
                      TargetPlatform.android: CustomPageTransitionBuilder(),
                      TargetPlatform.iOS: CustomPageTransitionBuilder(),
                    })),
                home: auth.isAuth
                    ? const ProductsOverviewScreen()
                    : FutureBuilder(
                        future: auth.autoLogin(),
                        builder: (ctx, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen()),
                routes: {
                  ProductsOverviewScreen.routeName: (ctx) =>
                      const ProductsOverviewScreen(),
                  ProductDetailsScreen.routeName: (ctx) =>
                      const ProductDetailsScreen(),
                  CartScreen.routeName: (ctx) => const CartScreen(),
                  OrderScreen.routeName: (ctx) => const OrderScreen(),
                  UserProductsScreen.routeName: (ctx) =>
                      const UserProductsScreen(),
                  EditProductScreen.routeName: (ctx) =>
                      const EditProductScreen(),
                  AuthScreen.routeName: (ctx) => const AuthScreen(),
                },
              )),
    );
  }
}
