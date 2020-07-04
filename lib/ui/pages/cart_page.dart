import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubiju/models/cart_model.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/modals/address_modal.dart';
import 'package:lubiju/ui/pages/login_page.dart';
import 'package:lubiju/ui/pages/order_page.dart';
import 'package:lubiju/ui/tiles/cart_tile.dart';
import 'package:lubiju/ui/widgets/cart_price.dart';
import 'package:lubiju/ui/widgets/discount_card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _defaultChanged(bool value) {
    setState(() {
      CartModel.of(context).withdrawInStore = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        elevation: 0,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;
                return Text(
                  p == 0 ? "" : "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 60,
            ),
          ),
          ScopedModelDescendant<CartModel>(builder: (context, child, model) {
            if (model.isLoading && UserModel.of(context).isLoggedIn()) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!UserModel.of(context).isLoggedIn()) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 80.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Faça o login para adicionar produtos!",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    )
                  ],
                ),
              );
            } else if (model.products == null || model.products.length == 0) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 80.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Nenhum produto no carrinho!",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return ListView(
                children: <Widget>[
                  Column(
                    children: model.products.map((product) {
                      return CartTile(product);
                    }).toList(),
                  ),
                  DiscountCard(),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "Endereço de Entrega:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700]),
                          ),
                          leading: Icon(Icons.location_on),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Text("Retirar produto na loja?",
                                    style: TextStyle(color: Colors.grey[700])),
                              ),
                              Switch(
                                  value: model.withdrawInStore,
                                  onChanged: _defaultChanged),
                            ],
                          ),
                        ),
                        model.withdrawInStore
                            ? Container()
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    Divider(),
                                    model.addressName != null &&
                                            model.addressInfo != null &&
                                            model.addressPhone != null
                                        ? ListTile(
                                            onTap: () async {
                                              final rec =
                                                  await Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddressModal()));
                                              if (rec != null) {
                                                _setAddress(model, rec);
                                              }
                                            },
                                            title: model.addressName != null &&
                                                    model.addressName.isNotEmpty
                                                ? Row(
                                                    children: <Widget>[
                                                      Text("Contato: "),
                                                      Text(
                                                        "${model.addressName}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 6.0,
                                                ),
                                                Text(
                                                  _buildAddressLine1(model),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  height: 4.0,
                                                ),
                                                Text(
                                                  _buildAddressLine2(model),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                            trailing: Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(16.0),
                                          )
                                        : ListTile(
                                            onTap: () async {
                                              final rec =
                                                  await Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddressModal()));
                                              if (rec != null) {
                                                _setAddress(model, rec);
                                              }
                                            },
                                            leading: Icon(
                                              Icons.location_off,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
                                                "Nenhum endereço vinculado...\nClique para selecionar.",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                            trailing: Icon(
                                              Icons.add,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(16.0),
                                          ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  CartPrice(() async {
                    if (!model.withdrawInStore &&
                        (model.addressId == null ||
                            model.addressName == null ||
                            model.addressPhone == null))
                      _showDialog();
                    else {
                      String orderId = await model.finishOrder();
                      if (orderId != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => OrderPage(orderId)));
                      }
                    }
                  }),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Ooops..."),
          content: new Text("Selecione um endereço para continuar."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _setAddress(CartModel model, DocumentSnapshot rec) {
    model.addressId = rec.documentID;
    model.addressName = rec["name"];
    model.addressPhone = rec["phone"];
    model.addressCep = rec["cep"];
    model.addressInfo = rec["address"];
    model.addressDistrict = rec["district"];
    model.addressComplement = rec["complement"];
    model.addressCity = rec["city"];
    model.addressState = rec["state"];
    model.addressCountry = rec["country"];
  }

  String _buildAddressLine1(CartModel model) {
    String text = "";

    text = "${model.addressInfo} , ${model.addressDistrict}";

    if (model.addressComplement != null && model.addressComplement != "")
      text += "\n" + model.addressComplement;

    return text;
  }

  String _buildAddressLine2(CartModel model) {
    String text = "";

    text = "${model.addressCity}";

    if (model.addressState != null && model.addressState != "")
      text += "," + model.addressState;

    text += ", ${model.addressCountry}";

    if (model.addressCep != null && model.addressCep != "")
      text = model.addressCep + " - " + text;

    return text;
  }
}
