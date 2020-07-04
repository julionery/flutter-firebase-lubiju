import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubiju/ui/views/add_address_page.dart';

class AddressTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  final Function function;

  const AddressTile(this.snapshot, this.function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      onLongPress: () {
        _settingModalBottomSheet(context, snapshot);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      snapshot.data["name"] != null
                          ? Text(
                              "${snapshot.data["name"]}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      snapshot.data["default"]
                          ? Text(
                              "PADRÃO",
                              style: TextStyle(color: Colors.deepOrange),
                            )
                          : Text("")
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    snapshot.data["phone"],
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    _buildAddressText(snapshot),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    _buildCountryText(snapshot),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context, doc) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.edit),
                    title: new Text('Editar'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddAddressPage(doc)));
                    }),
              ],
            ),
          );
        });
  }

  String _buildAddressText(DocumentSnapshot snapshot) {
    String text = "";

    text = snapshot.data["address"] + ", " + snapshot.data["district"];

    if (snapshot.data["complement"] != null &&
        snapshot.data["complement"] != "")
      text += "\n" + snapshot.data["complement"];

    return text;
  }

  String _buildCountryText(DocumentSnapshot snapshot) {
    String text = "";

    text = snapshot.data["city"];

    if (snapshot.data["state"] != null && snapshot.data["state"] != "")
      text += ", " + snapshot.data["state"];

    text += ", " + snapshot.data["country"];

    if (snapshot.data["cep"] != null && snapshot.data["cep"] != "")
      text = snapshot.data["cep"] + " - " + text;

    return text;
  }
}
