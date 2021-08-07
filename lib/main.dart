import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth_provider.dart';

// import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/auth_screen.dart';

import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';

import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/order_screen.dart';

import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          update: (ctx, auth, previousProduct) => ProductProvider(auth.token,
              previousProduct == null ? [] : previousProduct.getItem),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        /*ChangeNotifierProvider.value(
          value: OrderProvider(),
        ),*/
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
            update: (ctx, auth, previousProduct) =>
                OrderProvider(auth.token, previousProduct == null ? [] : previousProduct.getOrder))
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            fontFamily: 'Lato',
            backgroundColor: Colors.grey[200]
          ),
          home: authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            // ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            // AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
