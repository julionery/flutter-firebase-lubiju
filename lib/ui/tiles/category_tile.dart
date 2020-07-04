import 'package:flutter/material.dart';
import 'package:lubiju/models/category_model.dart';
import 'package:lubiju/ui/pages/category_page.dart';
import 'package:lubiju/ui/widgets/network_image.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;

  CategoryTile(this.category);

  Container _buildFeaturedItem({String image, String title}) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 16.0),
      child: Material(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: PNetworkImage(
                  image,
                  fit: BoxFit.cover,
                )),
            Positioned(
              bottom: 20.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CategoryPage(category)));
      },
      child: _buildFeaturedItem(image: category.icon, title: category.title),
//        child: Container(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text(
//              category.title,
//              style: TextStyle(
//                  backgroundColor: Theme.of(context).primaryColor,
//                  color: Colors.white,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 18),
//            ),
//          ),
//          height: 190.0,
//          width: MediaQuery.of(context).size.width - 100.0,
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(10),
//              color: Colors.transparent,
//              image: DecorationImage(
//                  image: new NetworkImage(category.icon), fit: BoxFit.cover)),
//        ),
    );
  }
}
