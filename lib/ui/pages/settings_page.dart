import 'package:flutter/material.dart';
import 'package:lubiju/models/user_model.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLogged = UserModel.of(context).isLoggedIn();
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "INFORMAÇÕES",
              ),
            ),
            isLogged
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      child: Text(
                        "SAIR",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        UserModel.of(context).signOut();
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }
}
