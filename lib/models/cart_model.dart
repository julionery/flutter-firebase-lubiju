import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubiju/models/address_model.dart';
import 'package:lubiju/models/cart_item_model.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartItemModel> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;
  bool withdrawInStore = false;

  AddressModel addressModel;

  String addressId;
  String addressName;
  String addressPhone;
  String addressCep;
  String addressInfo;
  String addressDistrict;
  String addressComplement;
  String addressCity;
  String addressState;
  String addressCountry;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartItemModel cartProduct) async {
    var item = products
        .where((x) =>
            x.productId == cartProduct.productId &&
            x.category == cartProduct.category &&
            x.uidSize == cartProduct.uidSize &&
            x.uidColor == cartProduct.uidColor)
        ?.toList();

    if (addressModel == null || products.length == 0) {
      var documents = await Firestore.instance
          .collection("users")
          .document(user.firebaseUser.uid)
          .collection("adresses")
          .getDocuments();

      if (documents.documents.length != 0) {
        var document =
            documents.documents.where((x) => x.data['default']).toList();
        if (document != null && document.length != 0)
          addressModel = AddressModel.fromDocument(
              documents.documents.firstWhere((x) => x.data['default']));
        else
          addressModel = AddressModel.fromDocument(documents.documents[0]);

        withdrawInStore = false;
      } else {
        addressModel = null;
        withdrawInStore = true;
      }

      Map<String, dynamic> _documentAdd;

      if (addressModel != null) {
        _documentAdd = addressModel.toResumedMap();
        _documentAdd["withdrawInStore"] = withdrawInStore;
      } else {
        _documentAdd = {"withdrawInStore": withdrawInStore};
        _documentAdd["id"] = null;
        _documentAdd["name"] = null;
        _documentAdd["phone"] = null;
        _documentAdd["cep"] = null;
        _documentAdd["address"] = null;
        _documentAdd["district"] = null;
        _documentAdd["complement"] = null;
        _documentAdd["city"] = null;
        _documentAdd["state"] = null;
        _documentAdd["country"] = null;

        addressId = null;
        addressName = null;
        addressPhone = null;
        addressCep = null;
        addressInfo = null;
        addressDistrict = null;
        addressComplement = null;
        addressCity = null;
        addressState = null;
        addressCountry = null;
      }

      Firestore.instance
          .collection("users")
          .document(user.firebaseUser.uid)
          .collection("cart")
          .document("cart")
          .setData(_documentAdd);
    }

    if (item.length == 0 ||
        (item[0].uidColor == null && item[0].uidSize != cartProduct.uidSize)) {
      products.add(cartProduct);
      Firestore.instance
          .collection("users")
          .document(user.firebaseUser.uid)
          .collection("cart")
          .document("cart")
          .collection("itens")
          .add(cartProduct.toMap())
          .then((doc) {
        cartProduct.cid = doc.documentID;
      });
    } else {
      this.incProduct(item[0]);
    }

    notifyListeners();
  }

  void removeCartItem(CartItemModel cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document("cart")
        .collection("itens")
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartItemModel cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document("cart")
        .collection("itens")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartItemModel cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document("cart")
        .collection("itens")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartItemModel c in products) {
      if (c.productData != null) price += c.quantity * c.productData.price;
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 0;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    DateTime _dateNow = DateTime.now();

    DocumentReference refOrder =
        await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "addressId": addressId,
      "addressName": addressName,
      "addressPhone": addressPhone,
      "addressCep": addressCep,
      "addressInfo": addressInfo,
      "addressDistrict": addressDistrict,
      "addressComplement": addressComplement,
      "addressCity": addressCity,
      "addressState": addressState,
      "addressCountry": addressCountry,
      "withdrawInStore": withdrawInStore,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "dateOrder": _dateNow,
      "totalPrice": (productsPrice + shipPrice - discount) < 0
          ? 0
          : (productsPrice + shipPrice - discount),
      "status": 1,
    });

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(refOrder.documentID)
        .setData({"orderId": refOrder.documentID, "dateOrder": _dateNow});

    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document("cart")
        .collection("itens")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document("cart")
        .collection("itens")
        .getDocuments();

    products =
        query.documents.map((doc) => CartItemModel.fromDocument(doc)).toList();

    DocumentSnapshot cart = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document("cart")
        .get();

    if (cart.data != null) {
      addressId = cart.data["id"];
      addressName = cart.data["name"];
      addressPhone = cart.data["phone"];
      addressCep = cart.data["cep"];
      addressInfo = cart.data["address"];
      addressDistrict = cart.data["district"];
      addressComplement = cart.data["complement"];
      addressCity = cart.data["city"];
      addressState = cart.data["state"];
      addressCountry = cart.data["country"];
      withdrawInStore = cart.data["withdrawInStore"];
    }

    notifyListeners();
  }
}
