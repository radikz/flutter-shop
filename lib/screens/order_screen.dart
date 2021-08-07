import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/order_provider.dart';
import '../widgets/order_item.dart';

import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // not using this coz infinite loop build
    // final orders = Provider.of<OrderProvider>(context);
    print('build ${OrderScreen.routeName}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<OrderProvider>(context, listen: false).getSetOrder(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Text('An error occurred');
            } else {
              return Consumer<OrderProvider>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.getOrder.length,
                  itemBuilder: (ctx, i) => OrderItem(orders.getOrder[i]),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
