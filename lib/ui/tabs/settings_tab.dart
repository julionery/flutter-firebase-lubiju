import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/address_page.dart';
import 'package:lubiju/ui/pages/contactus_page.dart';
import 'package:lubiju/ui/pages/login_page.dart';
import 'package:lubiju/ui/pages/user_page.dart';
import 'package:lubiju/ui/tabs/places_tab.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool isLoggin;

  @override
  Widget build(BuildContext context) {
    isLoggin = UserModel.of(context).isLoggedIn();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 136,
            ),
          ),
          buildHeader(width, height, context),
          buildHeaderData(height, width, context),
          buildListPanel(width, height, context),
        ],
      ),
    );
  }

  Widget buildHeader(double width, double height, BuildContext context) {
    return Positioned(
      child: Container(
        width: width,
        height: height * .30,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      if (isLoggin)
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserPage()));
                      else
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                    },
                    icon: Icon(
                      Icons.account_circle,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  isLoggin
                      ? IconButton(
                          onPressed: () {
                            UserModel.of(context).signOut();
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                            size: 30,
                            color: Colors.white,
                          ),
                        )
                      : Text(""),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeaderData(double height, double width, BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now);
    String userName = "Olá";
    if (isLoggin && UserModel.of(context).userData["name"] != null)
      userName += " " + UserModel.of(context).userData["name"].split(" ")[0];

    return Positioned(
        top: (height * .30) / 2 - 45,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                      color: Theme.of(context).primaryColor, width: 3),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage("images/logo.png"))),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  userName,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  ", bem vindo.",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                ),
              ],
            ),
            Text(
              "Hoje, " + formattedDate,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 13),
            ),
          ],
        ));
  }

  Widget buildListItem(
      {IconData icon, String title, String subtitle, Function function}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10),
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
          child: Icon(
            icon,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Container(
          height: 40,
          width: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
        onTap: function,
      ),
    );
  }

  Widget buildListPanel(double width, double height, BuildContext context) {
    return Positioned(
      width: width,
      height: height * .70 - 40,
      top: height * 0.28,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    buildListItem(
                        icon: Icons.location_on,
                        title: "Endereços",
                        subtitle: "Meus locais de entrega",
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddressPage()));
                        }),
                    Divider(
                      height: 1,
                    ),
                    buildListItem(
                        icon: Icons.store,
                        title: "Nossas Lojas",
                        subtitle: "Saiba mais",
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlacesTab()));
                        }),
                    Divider(
                      height: 1,
                    ),
                    buildListItem(
                        icon: Icons.chat,
                        title: "Fale conosco",
                        subtitle: "Mande-nos uma mensagem",
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactUsPage()));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
