import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubiju/models/cart_item_model.dart';
import 'package:lubiju/models/cart_model.dart';
import 'package:lubiju/models/product_model.dart';
import 'package:lubiju/ui/widgets/network_image.dart';

class CartTile extends StatelessWidget {
  final CartItemModel cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    CartModel.of(context).updatePrices();

    Widget _buildContent() {
      return Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                width: 120.0,
                height: 120.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: PNetworkImage(
                    cartProduct.productData.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cartProduct.productData.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17.0),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        children: <Widget>[
                          cartProduct.size != null
                              ? Expanded(
                                  child: Text(
                                    "Tamanho: ${cartProduct.size}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                )
                              : Container(),
                          cartProduct.color != null
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("Cor: "),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 3.0)),
                                        height: 20,
                                        width: 20,
                                        child: Container(
                                          color: Color(int.parse(
                                                  cartProduct.color
                                                      .substring(1, 7),
                                                  radix: 16) +
                                              0xFF000000),
                                        ),
                                      )
                                    ],
                                  ))
                              : Text(""),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove,
                                color: Theme.of(context).primaryColor),
                            onPressed: cartProduct.quantity > 1
                                ? () {
                                    CartModel.of(context)
                                        .decProduct(cartProduct);
                                  }
                                : null,
                          ),
                          Text(cartProduct.quantity.toString()),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              CartModel.of(context).incProduct(cartProduct);
                            },
                          ),
                          FlatButton(
                            child: Text("Remover"),
                            textColor: Colors.grey[500],
                            onPressed: () {
                              CartModel.of(context).removeCartItem(cartProduct);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection("products")
                  .document(cartProduct.category)
                  .collection("items")
                  .document(cartProduct.productId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cartProduct.productData =
                      ProductModel.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70.0,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
