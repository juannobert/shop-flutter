import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import '../utils/app_data.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product,{super.key});

  @override
  Widget build(BuildContext context) {
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
            leading: IconButton(
              onPressed: (){},
              icon: const Icon(Icons.favorite),
            ),
          trailing: IconButton(
            onPressed: (){}, 
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