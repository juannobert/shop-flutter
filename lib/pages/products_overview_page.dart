import 'package:flutter/material.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';


class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({super.key});

  final List<Product> loadedProducts = DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha loja"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        //Um grid com tamanho limitado no eixo cruzado
        //eixo ------------------------------------->
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // quantidade de itens
          childAspectRatio: 3/2, // Relação entre largura e altura
          crossAxisSpacing: 10, // Espaçamento no eixo cruzado
          mainAxisSpacing: 10, //Espaçamento no eixo principal
        ), 
        itemBuilder: (ctx,index) => ProductItem(loadedProducts[index])
      ),
    );
  }
}