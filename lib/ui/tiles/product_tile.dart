import 'package:flutter/material.dart';
import 'package:lubiju/models/product_model.dart';
import 'package:lubiju/ui/pages/product_page.dart';
import 'package:lubiju/ui/widgets/network_image.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;

  ProductTile(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProductPage(product)));
        },
        child: Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(bottom: 20.0),
          height: 230,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: PNetworkImage(
                    product.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("R\$${product.price.toString()}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30.0,
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(product.description,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.grey, height: 1.5))
                    ],
                  ),
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 10.0)
                      ]),
                ),
              )
            ],
          ),
        ));
  }
}
