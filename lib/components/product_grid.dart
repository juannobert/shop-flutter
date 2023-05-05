import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(this.showFavoriteOnly, {super.key});

  final bool showFavoriteOnly;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,

        //Um grid com tamanho limitado no eixo cruzado
        //eixo ------------------------------------->
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // quantidade de itens
          childAspectRatio: 3 / 2, // Relação entre largura e altura
          crossAxisSpacing: 10, // Espaçamento no eixo cruzado
          mainAxisSpacing: 10, //Espaçamento no eixo principal
        ),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
              // é usado para passar valores que já temos
              value: loadedProducts[index],
              child: const ProductGridItem());
        });
  }
}
