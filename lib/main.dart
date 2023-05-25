import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/order.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/order_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';
import 'utils/app_data.dart';
import 'models/cart.dart';
import 'models/auth.dart';
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
        ChangeNotifierProvider(create: (_) => Auth()),
        //Compartilhando token do auth provider para o productList
        ChangeNotifierProxyProvider<Auth,ProductList>(
          create: (context) => ProductList('', []),
          update: (context, auth, previous) { //previous é o valor antigo do product list
            return ProductList(auth.token ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProxyProvider<Auth,OrderList>(
          create: (_) => OrderList('',[]),
          update: (context, auth, previous) {
            return OrderList(auth.token ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(create: (_) => Cart(),
        
        )
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
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => const AuthOrHomePage (),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetail(),
          AppRoutes.PRODUCTS: (ctx) => const ProductsPage(),
          AppRoutes.CART: (ctx) => const CartPage(),
          AppRoutes.ORDERS: (ctx) =>  OrdersPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => const ProductFormPage(),
          },
      ),
    );
  }
}
