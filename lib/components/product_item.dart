import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import '../models/cart.dart';
import '../utils/app_data.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});


  @override
  Widget build(BuildContext context) {
  final product = Provider.of<Product>(context);
  final cart = Provider.of<Cart>(context);

  //listen = false: As notificações não farão que a interface seja renderizada
    return GridTile(
      footer: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product
            );
          },
          child: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black54,
            leading: Consumer<Product>( //Renderiza as notificações em apenas um trecho do código
              builder:(ctx,product,_) => IconButton(
                onPressed: (){
                  product.toggleFavorite();
                },
                icon: Icon(product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border),
              ),
            ),
          trailing: IconButton(
            onPressed: (){
              cart.addItem(product);
            }, 
            icon: const Icon(Icons.shopping_cart)
            ),
          ),
        ),
      ),
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}