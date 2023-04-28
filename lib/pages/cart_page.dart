import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import '../components/cart_item_widget.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartList = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  //Texto como uma label
                  Chip(
                    label:  Text(
                      'R\$${cart.totalAmount}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  //Faz com que o Text e o Chip se juntem na ponta
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "COMPRAR",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (ctx,index) => CartItemWidget(cartList[index])
            ),
          )
        ],
      ),
    );
  }
}
