import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String category;
  String id;

  String title;
  String description;

  double price;

  List images;
  List sizes;
  String color;
  bool hasSize;
  bool hasColor;

  ProductModel.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"];
    images = snapshot.data["images"];
    sizes = snapshot.data["sizes"];
    color = snapshot.data["color"];
    hasSize = snapshot.data["hasSize"];
    hasColor = snapshot.data["hasColor"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
      "hasSize": hasSize,
      "hasColor": hasColor,
      "images": images
    };
  }
}
