import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/models/category_model.dart';
import 'package:lubiju/ui/tiles/category_tile.dart';

class CategoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Categorias"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 120,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("products").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
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
                            "Nenhuma categoria encontrada!",
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
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          CategoryModel data = CategoryModel.fromDocument(
                              snapshot.data.documents[index]);
                          return CategoryTile(data);
                        });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
