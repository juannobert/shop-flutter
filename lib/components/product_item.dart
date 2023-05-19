import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import '../utils/app_data.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.purple,
                )),
            IconButton(
                onPressed: () {
                  showDialog<bool>(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Tem certeza"),
                          content:
                              const Text("Deseja realmente excluir o pedido?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); //Exclui o pedido
                                },
                                child: const Text("SIM")),
                            TextButton(
                                onPressed: () {
                                  //Retorna falso para a função que é um Future
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text("NÂO"))
                          ],
                        );
                      }).then((value) async {
                    if (value ?? false) {
                      try {
                        await Provider.of<ProductList>(
                          context,
                          listen: false,
                        ).removeProduct(product);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(error.toString()),
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    }
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ))
          ],
        ),
      ),
    );
  }
}
