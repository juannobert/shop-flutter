import 'package:flutter/material.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'pages/products_overview_page.dart';
import 'utils/app_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.deepOrange,
        ),
        fontFamily: 'Lato'
      ),
      debugShowCheckedModeBanner: false,
      home: ProductsOverviewPage(),
      routes: {
        AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetail()
      },
    );
  }
}
