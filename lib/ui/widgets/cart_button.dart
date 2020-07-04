import 'package:flutter/material.dart';
import 'package:lubiju/ui/pages/cart_page.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CartPage()));
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
