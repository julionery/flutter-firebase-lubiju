import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class ContactModel extends Model {
  bool isLoading = false;

  static ContactModel of(BuildContext context) =>
      ScopedModel.of<ContactModel>(context);

  void send(
      {@required Map<String, dynamic> data,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    Firestore.instance.collection("messages").add(data).then((msg) {
      onSuccess();
      isLoading = false;
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }
}
