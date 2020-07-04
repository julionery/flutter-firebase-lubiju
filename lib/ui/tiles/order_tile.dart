import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lubiju/ui/views/order_view_page.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection("orders")
              .document(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int status = snapshot.data["status"];
              return GestureDetector(
                onLongPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderViewPage(snapshot.data)));
                },
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderViewPage(snapshot.data)));
                },
                child: Card(
                  child: ExpansionTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Data da Compra: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "${DateFormat('dd-MM-yyyy – kk:mm').format(snapshot.data['dateOrder'].toDate())}",
                                  style: TextStyle(color: Colors.black87)),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Código: ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("${snapshot.data.documentID}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.black87)),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Status: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _buildStatus(
                                  snapshot.data['status'],
                                ),
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(),
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Descrição: "),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, right: 8.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                            Text(_buildProductsText(snapshot.data)),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "Status do Pedido:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _buildCircle("1", "Recebido", status, 1),
                                Container(
                                  height: 1.0,
                                  width: 25.0,
                                  color: Colors.grey[500],
                                ),
                                _buildCircle("2", "Preparação", status, 2),
                                Container(
                                  height: 1.0,
                                  width: 25.0,
                                  color: Colors.grey[500],
                                ),
                                _buildCircle("3", "Em Transporte", status, 3),
                                Container(
                                  height: 1.0,
                                  width: 25.0,
                                  color: Colors.grey[500],
                                ),
                                _buildCircle("4", "Entregue", status, 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  String _buildStatus(int status) {
    switch (status) {
      case 1:
        return "Aguardando Confirmação";
        break;
      case 2:
        return "Em Preparação";
        break;
      case 3:
        return "Em Transporte";
        break;
      case 4:
        return "Entregue";
        break;
      case 99:
        return "Cancelado";
        break;
      default:
        return "Finalizado";
        break;
    }
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "";
    for (LinkedHashMap p in snapshot.data["products"]) {
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
