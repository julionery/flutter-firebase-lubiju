import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/tiles/address_tile.dart';
import 'package:lubiju/ui/views/add_address_page.dart';

class AddressModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Endereços"),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddAddressPage(null)));
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: DiagonalPathClipperOne(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 50,
            ),
          ),
          FutureBuilder<QuerySnapshot>(
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
                              Navigator.pop(context, doc);
                            }))
                        .toList()
                        .reversed
                        .toList(),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
