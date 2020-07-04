import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/models/category_model.dart';
import 'package:lubiju/models/product_model.dart';
import 'package:lubiju/ui/tiles/product_tile.dart';
import 'package:lubiju/ui/widgets/cart_button.dart';

class CategoryPage extends StatelessWidget {
  final CategoryModel snapshot;

  CategoryPage(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.title),
            centerTitle: true,
            elevation: 0,
          ),
          floatingActionButton: CartButton(),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: DiagonalPathClipperOne(),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    height: 50,
                  ),
                ),
                FutureBuilder<QuerySnapshot>(
                    future: Firestore.instance
                        .collection("products")
                        .document(snapshot.id)
                        .collection("items")
                        .getDocuments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else if (snapshot.data.documents.length == 0) {
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
                                "Nenhum produto encontrado!",
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
                        return ListView.builder(
                            padding: EdgeInsets.all(4.0),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              ProductModel data = ProductModel.fromDocument(
                                  snapshot.data.documents[index]);
                              data.category = this.snapshot.id;
                              return ProductTile(data);
                            });
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
