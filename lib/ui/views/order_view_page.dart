import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:lubiju/ui/widgets/network_image.dart';

class OrderViewPage extends StatelessWidget {
  final DocumentSnapshot order;

  OrderViewPage(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Pedido"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 80,
            ),
          ),
          ListView(
            padding: EdgeInsets.only(top: 8.0),
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Resumo do Pedido",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Código: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text("${order.documentID}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Data da Compra: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                                "${DateFormat('dd-MM-yyyy – kk:mm').format(order.data['dateOrder'].toDate())}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Status: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(_buildStatus(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Subtotal"),
                            Text(
                                "R\$ ${order.data["productsPrice"].toStringAsFixed(2)}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Desconto"),
                            Text(
                                "R\$ ${order.data["discount"] != 0 ? "-${order.data["discount"].toStringAsFixed(2)}" : "${order.data["discount"].toStringAsFixed(2)}"}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Entrega"),
                            order.data["withdrawInStore"]
                                ? Text("À retirar na loja")
                                : order.data["shipPrice"] == 0
                                    ? Text("À combinar")
                                    : Text(
                                        "R\$ ${order.data["shipPrice"].toStringAsFixed(2)}"),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Total",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22.0,
                              ),
                            ),
                            Text(
                              "R\$ ${(order.data["productsPrice"] + (order.data["withdrawInStore"] ? 0 : order.data["shipPrice"]) - order.data["discount"]) <= 0 ? "0.00" : (order.data["productsPrice"] + (order.data["withdrawInStore"] ? 0 : order.data["shipPrice"]) - order.data["discount"]).toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 22.0),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Endereço de Entrega:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700]),
                          ),
                          order.data["withdrawInStore"]
                              ? Text(
                                  "Retirado na Loja.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.grey[700]),
                                )
                              : Container()
                        ],
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
                      leading: Icon(Icons.location_on),
                      subtitle: order.data["withdrawInStore"]
                          ? Container()
                          : order.data["addressName"] != null &&
                                  order.data["addressName"].isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("Contato: "),
                                        Text(
                                          "${order.data["addressName"]} " +
                                              (order.data["addressPhone"] !=
                                                      null
                                                  ? " - ${order.data["addressPhone"]}"
                                                  : ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(_buildAddressLine1()),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(_buildAddressLine2())
                                  ],
                                )
                              : Text(""),
                    ),
                  ],
                ),
              ),
              Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 14.0, bottom: 8.0),
                          child: Text(
                            "Produtos",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Column(
                          children: listMyWidgets(context),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> listMyWidgets(BuildContext context) {
    List<Widget> list = new List();
    for (LinkedHashMap p in order.data["products"]) {
      list.add(buildCard(p, context));
    }
    return list;
  }

  Widget buildCard(product, BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            product["product"]["images"] != null
                ? Container(
                    padding: EdgeInsets.all(8.0),
                    width: 120.0,
                    height: 120.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: PNetworkImage(
                        product["product"]["images"][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      product["product"]["title"],
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.0),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      children: <Widget>[
                        product["size"] != null
                            ? Expanded(
                                child: Text(
                                  "Tamanho: ${product["size"]}",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              )
                            : Container(),
                        product["color"] != null
                            ? Row(
                                children: <Widget>[
                                  Text("Cor: "),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 3.0)),
                                    height: 20,
                                    width: 20,
                                    child: Container(
                                      color: Color(int.parse(
                                              product["color"].substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                    ),
                                  )
                                ],
                              )
                            : Text(""),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Quantidade: ${product["quantity"]}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "R\$ ${product["product"]["price"].toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  String _buildStatus() {
    switch (order.data["status"]) {
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

  String _buildAddressLine1() {
    String text = "";

    text = order.data["addressInfo"] + ", " + order.data["addressDistrict"];

    if (order.data["addressComplement"] != null &&
        order.data["addressComplement"] != "")
      text += "\n" + order.data["addressComplement"];

    return text;
  }

  String _buildAddressLine2() {
    String text = "";

    text = order.data["addressCity"];

    if (order.data["addressState"] != null && order.data["addressState"] != "")
      text += "," + order.data["addressState"];

    text += ", " + order.data["addressCountry"];

    if (order.data["addressCep"] != null && order.data["addressCep"] != "")
      text = order.data["addressCep"] + " - " + text;

    return text;
  }
}
