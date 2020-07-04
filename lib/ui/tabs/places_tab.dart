import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/ui/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nossas Lojas"),
        centerTitle: true,
        elevation: 0,
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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("places").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  return ListView(
                    children: snapshot.data.documents
                        .map((doc) => PlaceTile(doc))
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
