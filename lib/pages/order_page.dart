import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/order_widget.dart';
import 'package:shop/models/order_list.dart';
import '../components/app_drawer.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderList orderList = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus pedidos"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context).loadProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                    itemCount: orderList.items.length,
                    itemBuilder: (_, i) => OrderWidget(orderList.items[i])));
          }
        },
      ),
      /*
      body: ListView.builder(
        itemCount: orderList.items.length,
        itemBuilder: (_,i) => isLoading ? const Center(child: CircularProgressIndicator(),) : OrderWidget(orderList.items[i])
        ),
        */
    );
  }
}
