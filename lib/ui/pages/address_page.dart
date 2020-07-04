import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/login_page.dart';
import 'package:lubiju/ui/tiles/address_tile.dart';
import 'package:lubiju/ui/views/add_address_page.dart';

class AddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Endereços"),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: UserModel.of(context).isLoggedIn()
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddAddressPage(null)));
              },
              backgroundColor: Theme.of(context).primaryColor,
            )
          : Container(),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: DiagonalPathClipperOne(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 50,
            ),
          ),
          UserModel.of(context).isLoggedIn()
              ? FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance
                      .collection("users")
                      .document(UserModel.of(context).firebaseUser.uid)
                      .collection("adresses")
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
                                Icons.view_list,
                                size: 80.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                "Nenhum endereço encontrado!",
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
                              .map((doc) => AddressTile(doc, () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddAddressPage(doc)));
                                  }))
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
