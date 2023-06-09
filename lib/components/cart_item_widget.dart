import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget(this.cartItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.productId);
      },
      confirmDismiss: (_) {
        return showDialog<bool>(
            context: context,
            builder: (_) { 
            return AlertDialog(
                  title: const Text("Tem certeza"),
                  content: const Text("Deseja realmente excluir o pedido?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); //Exclui o pedido
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
            }              
          );
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text(
                  'R\$${cartItem.price}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total R\$${cartItem.price * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
