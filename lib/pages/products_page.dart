import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';
import '../components/app_drawer.dart';
import '../components/product_item.dart';
import '../utils/app_data.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }
  @override
  Widget build(BuildContext context) {
    ProductList productList = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar produtos"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()=> _refreshProducts(context),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: productList.itemsCount,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                      ProductItem(productList.items[i]),
                      const Divider()
                    ],
                  );
                })),
      ),
      drawer: const AppDrawer(),
    );
  }
}
