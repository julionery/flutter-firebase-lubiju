import 'package:flutter/material.dart';
import 'package:lubiju/models/cart_model.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/home_page.dart';
import 'package:scoped_model/scoped_model.dart';

Color color2 = Color(0xff721725);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorMap = {
      50: Color.fromRGBO(114, 23, 37, .1),
      100: Color.fromRGBO(114, 23, 37, .2),
      200: Color.fromRGBO(114, 23, 37, .3),
      300: Color.fromRGBO(114, 23, 37, .4),
      400: Color.fromRGBO(114, 23, 37, .5),
      500: Color.fromRGBO(114, 23, 37, .6),
      600: Color.fromRGBO(114, 23, 37, .7),
      700: Color.fromRGBO(114, 23, 37, .8),
      800: Color.fromRGBO(114, 23, 37, .9),
      900: Color.fromRGBO(114, 23, 37, 1),
    };
    MaterialColor customColor = MaterialColor(0xFF721725, colorMap);

    return ScopedModel<UserModel>(
        model: UserModel(),
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
                title: 'Lú Biju',
                theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: customColor,
                ),
                debugShowCheckedModeBanner: false,
                home: HomePage()),
          );
        }));
  }
}
