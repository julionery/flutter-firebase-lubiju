import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/login_page.dart';
import 'package:lubiju/ui/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 100,
            ),
          ),
          UserModel.of(context).isLoggedIn()
              ? FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance
                      .collection("users")
                      .document(UserModel.of(context).firebaseUser.uid)
                      .collection("orders")
                      .orderBy("dateOrder")
                      .getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      if (snapshot.data.documents.length == 0) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.grid_off,
                                size: 80.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                "Nenhum pedido encontrado!",
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
                          children: snapshot.data.documents
                              .map((doc) => OrderTile(doc.documentID))
                              .toList()
                              .reversed
                              .toList(),
                        );
                      }
                    }
                  },
                )
              : Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.view_list,
                        size: 80.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Faça o login para acompanhar!",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16.0,
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
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
