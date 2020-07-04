import 'package:flutter/material.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/signup_page.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passController = TextEditingController();
  final _passFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle style = TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 155.0,
                                  child: Image.asset(
                                    "images/logo.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 45.0),
                                TextFormField(
                                  controller: _emailController,
                                  style: style,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0))),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (text) {
                                    if (text.isEmpty || !text.contains("@"))
                                      return "E-mail inválido!";
                                    return null;
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus(_passFocus);
                                  },
                                ),
                                SizedBox(height: 25.0),
                                TextFormField(
                                  focusNode: _passFocus,
                                  controller: _passController,
                                  style: style,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: "Senha",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0))),
                                  obscureText: true,
                                  validator: (text) {
                                    if (text.isEmpty || text.length < 6)
                                      return "Senha inválida!";
                                    return null;
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                      onPressed: () {
                                        if (_emailController.text.isEmpty) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Insira seu e-mail para recuperação!"),
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 2),
                                          ));
                                        } else {
                                          model.recoverPass(
                                              _emailController.text);
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Confira seu e-mail!"),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            duration: Duration(seconds: 3),
                                          ));
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        "Esqueci minha senha",
                                        textAlign: TextAlign.right,
                                      )),
                                ),
                                SizedBox(
                                  height: 35.0,
                                ),
                                Material(
                                  color: Theme.of(context).primaryColor,
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        model.signIn(
                                            email: _emailController.text,
                                            pass: _passController.text,
                                            onSuccess: _onSuccess,
                                            onFail: _onFail);
                                      }
                                    },
                                    child: Text("ENTRAR",
                                        textAlign: TextAlign.center,
                                        style: style.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 28.0,
                            color: Theme.of(context).primaryColor,
                          )),
                      FlatButton(
                        child: Text(
                          "CRIAR CONTA",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                        },
                      )
                    ],
                  ),
                )),
              ],
            );
          },
        ));
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
