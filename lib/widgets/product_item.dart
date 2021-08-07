import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final authToken = Provider.of<AuthProvider>(context, listen: false).token;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(children: [
        GridTile(
          child: GestureDetector(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
          ),
          footer: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            trailing: GestureDetector(
              child: Icon(
                Icons.shopping_cart,
                color: Colors.red,
              ),
              onTap: () {
                cart.addItem(product.id, product.price, product.title);
                // Scaffold.of(context).showSnackBar(snackbar)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added item to cart!!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Consumer<Product>(
            builder: (context, product, child) => Material(
              child: IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  product.toggleFavoriteStatus(authToken).then((msg) {
                    if (msg.isNotEmpty)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                        ),
                      );
                  });

                  // product.toggleFavoriteStatus();
                },
              ),
            ),
          ),
        )
      ]),
    );
  }
}
