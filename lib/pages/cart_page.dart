import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
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
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  //Faz com que o Text e o Chip se juntem na ponta
                  const Spacer(),
                  cartButton(cart: cart)
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

class cartButton extends StatefulWidget {
  const cartButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<cartButton> createState() => _cartButtonState();
}

class _cartButtonState extends State<cartButton> {

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.itemsCount == 0 ? null : () async {
        setState(() => isLoading = true);
        await Provider.of<OrderList>(context,listen: false).addOrder(widget.cart);
        widget.cart.clear();
        setState(() => isLoading = false);
      },
      child: isLoading ? const CircularProgressIndicator() : Text(
        "COMPRAR",
        style: TextStyle(
          color: Theme.of(context).primaryColor
        ),
      ),
    );
  }
}
