import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'pages/products_overview_page.dart';
import 'utils/app_data.dart';
import 'models/cart.dart';

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
        ChangeNotifierProvider(create: (_) => ProductList()),
        ChangeNotifierProvider(create: (_) => Cart())
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.purple,
            secondaryHeaderColor: Colors.deepOrange,
            colorScheme: ColorScheme.fromSwatch(
              accentColor: Colors.deepOrange,
            ),
            fontFamily: 'Lato'),
        debugShowCheckedModeBanner: false,
        home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetail(),
          AppRoutes.CART: (ctx) => const CartPage()
          },
      ),
    );
  }
}
