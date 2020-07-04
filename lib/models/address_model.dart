import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class AddressModel extends Model {
  String id;

  String name;
  String phone;
  String cep;
  String address;
  String district;
  String complement;
  String city;
  String state;
  String country;
  bool isDefault;

  AddressModel.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    name = snapshot.data["name"];
    phone = snapshot.data["phone"];
    cep = snapshot.data["cep"];
    address = snapshot.data["address"];
    district = snapshot.data["district"];
    complement = snapshot.data["complement"];
    city = snapshot.data["city"];
    state = snapshot.data["state"];
    country = snapshot.data["country"];
    isDefault = snapshot.data["default"];
  }

  AddressModel.fromJson(Map<dynamic, dynamic> data) {
    id = data["id"];
    name = data["name"];
    phone = data["phone"];
    cep = data["cep"];
    address = data["address"];
    district = data["district"];
    complement = data["complement"];
    city = data["city"];
    state = data["state"];
    country = data["country"];
    isDefault = data["default"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "cep": cep,
      "address": address,
      "district": district,
      "complement": complement,
      "city": city,
      "state": state,
      "country": country,
      "default": isDefault,
    };
  }
}
