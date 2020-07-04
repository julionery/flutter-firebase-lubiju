import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubiju/models/cart_item_model.dart';
import 'package:lubiju/models/cart_model.dart';
import 'package:lubiju/models/product_model.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/cart_page.dart';
import 'package:lubiju/ui/widgets/network_image.dart';

import 'login_page.dart';

class ProductPage extends StatefulWidget {
  final ProductModel product;

  ProductPage(this.product);

  @override
  _ProductPageState createState() => _ProductPageState(product);
}

class _ProductPageState extends State<ProductPage> {
  final ProductModel product;

  String uidSize;
  String size;
  String uidColor;
  String color;
  int qtd = 0;
  bool hasColor = false;
  bool hasSize = false;
  bool selectedColor = false;
  bool selectedSize = false;

  _ProductPageState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: 400,
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Carousel(
                    images: product.images.map((url) {
                      return PNetworkImage(
                        url,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotBgColor: Colors.transparent,
                    dotColor: primaryColor,
                    autoplay: true,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 370.0, 16.0, 16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.title,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                      maxLines: 3,
                    ),
                    Text(
                      "R\$ ${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      product.description != null ? product.description : "",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    product.hasSize
                        ? SizedBox(
                            height: 12.0,
                          )
                        : Container(),
                    product.hasSize
                        ? Text(
                            "Tamanho(s):",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          )
                        : Container(),
                    product.hasSize
                        ? SizedBox(
                            height: 4.0,
                          )
                        : Container(),
                    SizedBox(
                      height: 40.0,
                      child: FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection("products")
                              .document(product.category)
                              .collection("items")
                              .document(product.id)
                              .collection("sizes")
                              .orderBy("order")
                              .getDocuments(),
                          builder: (context, snapshot) {
                            selectedSize = product.hasSize;

                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());
                            else {
                              if (snapshot.data.documents.length == 0) {
                                hasSize = false;
                                selectedSize = true;
                                selectedColor = true;
                                return Container();
                              } else {
                                hasSize = true;
                                selectedSize = false;
                                return GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 0.5,
                                    ),
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            uidColor = null;
                                            color = null;
                                            qtd = 0;
                                            selectedSize = true;

                                            uidSize = snapshot.data
                                                .documents[index].documentID;
                                            size = snapshot.data
                                                .documents[index].data["title"];
                                            if (snapshot.data.documents[index]
                                                .data["hasColor"]) {
                                              hasColor = true;
                                              selectedColor = false;
                                            } else {
                                              hasColor = false;
                                              selectedColor = true;
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              border: Border.all(
                                                  color: snapshot
                                                              .data
                                                              .documents[index]
                                                              .documentID ==
                                                          uidSize
                                                      ? primaryColor
                                                      : Colors.grey[500],
                                                  width: 3.0)),
                                          width: 50.0,
                                          alignment: Alignment.center,
                                          child: Text(snapshot.data
                                              .documents[index].data["title"]),
                                        ),
                                      );
                                    });
                              }
                            }
                          }),
                    ),
                    product.hasColor
                        ? SizedBox(
                            height: 12.0,
                          )
                        : Container(),
                    product.hasColor && uidSize != null
                        ? Text(
                            "Cor(es):",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          )
                        : Container(),
                    product.hasColor
                        ? SizedBox(
                            height: 4.0,
                          )
                        : Container(),
                    uidSize != null && product.hasColor
                        ? FutureBuilder<QuerySnapshot>(
                            future: Firestore.instance
                                .collection("products")
                                .document(product.category)
                                .collection("items")
                                .document(product.id)
                                .collection("sizes")
                                .document(uidSize)
                                .collection("colors")
                                .getDocuments(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                    child: CircularProgressIndicator());
                              else {
                                if (snapshot.data.documents.length == 0) {
                                  return Container();
                                } else {
                                  return SizedBox(
                                    height: 40.0,
                                    child: GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4.0),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          mainAxisSpacing: 8.0,
                                          childAspectRatio: 0.5,
                                        ),
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                uidColor = snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID;
                                                color = snapshot
                                                    .data
                                                    .documents[index]
                                                    .data["color"];
                                                qtd = snapshot
                                                    .data
                                                    .documents[index]
                                                    .data["quantity"];
                                                selectedColor = true;
                                                selectedSize = true;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                    border: Border.all(
                                                        color: snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID ==
                                                                uidColor
                                                            ? primaryColor
                                                            : Colors.grey[500],
                                                        width: 3.0)),
                                                width: 50.0,
                                                alignment: Alignment.center,
                                                child: Container(
                                                  color: Color(int.parse(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data["color"]
                                                              .substring(1, 7),
                                                          radix: 16) +
                                                      0xFF000000),
                                                )
                                                //Text(snapshot.data.documents[index].data["color"]),
                                                ),
                                          );
                                        }),
                                  );
                                }
                              }
                            })
                        : Container(),
                    _buildQuantityText(),
                    product.hasSize || product.hasColor
                        ? SizedBox(
                            height: 16.0,
                          )
                        : Container(),
                    Center(
                      child: SizedBox(
                        height: 44.0,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                UserModel.of(context).isLoggedIn()
                                    ? "Adicionar ao Carrinho"
                                    : "Entre para Comprar",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            color: primaryColor,
                            textColor: Colors.white,
                            onPressed: selectedSize && selectedColor
                                ? () {
                                    if (UserModel.of(context).isLoggedIn()) {
                                      CartItemModel cartProduct =
                                          CartItemModel();
                                      cartProduct.uidSize = uidSize;
                                      cartProduct.size = size;
                                      cartProduct.quantity = 1;
                                      cartProduct.productId = product.id;
                                      cartProduct.category = product.category;
                                      cartProduct.productData = product;

                                      if (uidColor != "") {
                                        cartProduct.uidColor = uidColor;
                                        cartProduct.color = color;
                                      }

                                      CartModel.of(context)
                                          .addCartItem(cartProduct);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartPage()));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    }
                                  }
                                : null),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    MaterialButton(
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      ),
                      color: Colors.white,
                      textColor: Colors.black,
                      minWidth: 0,
                      height: 40,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityText() {
    if (qtd != 0 && qtd != null) {
      if (qtd == 1)
        return _buildQtd("Só temos mais uma unidade disponível.");
      else if (qtd < 11)
        return _buildQtd("Apenas $qtd unidades restantes.");
      else
        return _buildQtd("$qtd unidades restantes.");
    } else {
      return Container();
    }
  }

  Widget _buildQtd(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value),
    );
  }
}
