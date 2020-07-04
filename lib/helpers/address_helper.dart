import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class AddressHelper extends Model {
  bool isLoading = false;

  static AddressHelper of(BuildContext context) =>
      ScopedModel.of<AddressHelper>(context);

  Future delete(
      {@required String idUser,
      @required String idAddress,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    Firestore.instance
        .collection("users")
        .document(idUser)
        .collection("adresses")
        .document(idAddress)
        .delete()
        .then((msg) {
      onSuccess();
      isLoading = false;
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future save(
      {@required Map<String, dynamic> data,
      @required String idUser,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    if (data["default"]) await _resetDefault(idUser: idUser);

    Firestore.instance
        .collection("users")
        .document(idUser)
        .collection("adresses")
        .add(data)
        .then((msg) {
      onSuccess();
      isLoading = false;
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future update(
      {@required Map<String, dynamic> data,
      @required String idUser,
      @required String idAddress,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    if (data["default"]) await _resetDefault(idUser: idUser);

    Firestore.instance
        .collection("users")
        .document(idUser)
        .collection("adresses")
        .document(idAddress)
        .setData(data)
        .then((msg) {
      onSuccess();
      isLoading = false;
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future _resetDefault({
    @required String idUser,
  }) async {
    await Firestore.instance
        .collection("users")
        .document(idUser)
        .collection("adresses")
        .getDocuments()
        .then((values) {
      values.documents.forEach((item) {
        item.data['default'] = false;
        Firestore.instance
            .collection("users")
            .document(idUser)
            .collection("adresses")
            .document(item.documentID)
            .setData(item.data);
      });
    });
  }

  String buildAddressLine1(DocumentSnapshot snapshot) {
    String text = "";

    text = snapshot.data["address"] + ", " + snapshot.data["district"];

    if (snapshot.data["complement"] != null &&
        snapshot.data["complement"] != "")
      text += "\n" + snapshot.data["complement"];

    return text;
  }

  String buildAddressLine2(DocumentSnapshot snapshot) {
    String text = "";

    text = snapshot.data["city"];

    if (snapshot.data["state"] != null && snapshot.data["state"] != "")
      text += "," + snapshot.data["state"];

    text += ", " + snapshot.data["country"];

    if (snapshot.data["cep"] != null && snapshot.data["cep"] != "")
      text = snapshot.data["cep"] + " - " + text;

    return text;
  }
}
