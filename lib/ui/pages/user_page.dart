import 'package:flutter/material.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/login_page.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();
  final _birthdateController = TextEditingController();

  DateTime _birthdate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _birthdate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != _birthdate)
      setState(() {
        _birthdate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    var _data = UserModel.of(context).userData;
    _nameController.text = _data["name"];
    _emailController.text = _data["email"];
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
          centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Nome Completo", icon: Icon(Icons.person)),
                  validator: (text) {
                    if (text.isEmpty) return "Nome inválido!";
                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  enabled: false,
                  style: TextStyle(color: Colors.grey),
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "E-mail", icon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      "ATUALIZAR",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          "name": _nameController.text,
                        };
                        UserModel.of(context).updateUser(userData);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              ],
            )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.view_list,
                size: 80.0,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "Faça o login para acompanhar!",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              )
            ],
          ),
        ),
      );
    }
  }
}
