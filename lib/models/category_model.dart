import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;

  String title;
  String icon;

  CategoryModel.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    icon = snapshot.data["icon"];
  }

  Map<String, dynamic> toResumedMap() {
    return {"title": title};
  }
}
