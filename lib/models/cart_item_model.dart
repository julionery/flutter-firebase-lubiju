import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lubiju/models/product_model.dart';

class CartItemModel {
  String cid;

  String category;
  String productId;

  int quantity;
  String size;
  String uidSize;
  String color;
  String uidColor;

  ProductModel productData;

  CartItemModel();

  CartItemModel.fromDocument(DocumentSnapshot document) {
    cid = document.documentID;
    category = document.data["category"];
    productId = document.data["productId"];
    quantity = document.data["quantity"];
    size = document.data["size"];
    color = document.data["color"];
    uidSize = document.data["uidSize"];
    uidColor = document.data["uidColor"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "productId": productId,
      "quantity": quantity,
      "size": size,
      "color": color,
      "uidSize": uidSize,
      "uidColor": uidColor,
      "product": productData?.toResumedMap()
    };
  }
}
