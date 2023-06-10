import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import '../models/cart.dart';
import '../utils/app_data.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  
  @override
  Widget build(BuildContext context) {
  final product = Provider.of<Product>(context);
  final cart = Provider.of<Cart>(context);
  Auth auth = Provider.of(context);

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
                  
                  product.toggleFavorite(auth.token!,auth.uid!);
                },
                icon: Icon(product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border),
              ),
            ),
          trailing: IconButton(
            onPressed: (){
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar(); //Esconde snackBar anterior
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Desfazer operação"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'DESFAZER', 
                    onPressed: (){
                      cart.removeSingleItem(product.id!);
                    }
                  ),
                ),
                
              );
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