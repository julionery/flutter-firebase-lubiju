import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final String title;

  HomeTab(this.title);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 196,
          ),
        ),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(title),
                centerTitle: true,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("home")
                    .orderBy("date", descending: true)
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    );
                  else
                    return SliverStaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      staggeredTiles: snapshot.data.documents.map((doc) {
                        return StaggeredTile.count(
                            doc.data["x"], doc.data["y"]);
                      }).toList(),
                      children: snapshot.data.documents.map((doc) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: doc.data["image"],
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    );
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
