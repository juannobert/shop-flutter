import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_data.dart';
import '../components/app_drawer.dart';

enum Filter { favorite, all }

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
  final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha loja"),
        actions: [
          PopupMenuButton<Filter>(
            onSelected: (Filter filter) {
              setState(() {
                if (filter == Filter.all) {
                  _showFavoriteOnly = false;
                } else if (filter == Filter.favorite) {
                  _showFavoriteOnly = true;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) {
              return [
                const PopupMenuItem(
                  value: Filter.favorite,
                  child: Text("Somente favoritos"),
                ),
                const PopupMenuItem(
                  value: Filter.all,
                  child: Text("Todos os  produtos"),
                ),
              ];
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.CART
              );
            },
            icon:  Badge(
              label: Text(cart.itemsCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
      drawer: const AppDrawer(),
    );
  }
}
