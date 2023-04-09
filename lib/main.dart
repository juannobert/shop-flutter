import 'package:flutter/material.dart';
import 'pages/products_overview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductsOverviewPage(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.deepOrange,
        ),
        fontFamily: 'Lato'
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
