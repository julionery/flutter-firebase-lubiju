import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _passConfirmFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible;
  bool _passwordConfirmVisible;

  @override
  void initState() {
    _passwordVisible = false;
    _passwordConfirmVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: DiagonalPathClipperOne(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 50,
              ),
            ),
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
              if (model.isLoading)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 38, bottom: 24.0),
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hasFloatingPlaceholder: true,
                            filled: true,
                            labelText: "Nome",
                            icon: Icon(Icons.person)),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                        validator: (text) {
                          if (text.isEmpty) return "Nome inválido!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_passFocus);
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hasFloatingPlaceholder: true,
                            filled: true,
                            labelText: "E-mail",
                            icon: Icon(Icons.email)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text.isEmpty ||
                              !text.contains("@") ||
                              !text.contains(".")) return "E-mail inválido!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _passController,
                        focusNode: _passFocus,
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_passConfirmFocus);
                        },
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          hasFloatingPlaceholder: true,
                          filled: true,
                          labelText: "Senha",
                          icon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                _passwordVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _passwordVisible = false;
                              });
                            },
                            child: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (text) {
                          if (text.isEmpty || text.length < 6)
                            return "Senha inválida!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        obscureText: !_passwordConfirmVisible,
                        controller: _passConfirmController,
                        focusNode: _passConfirmFocus,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          hasFloatingPlaceholder: true,
                          filled: true,
                          labelText: "Confirme a Senha",
                          icon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordConfirmVisible =
                                    !_passwordConfirmVisible;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                _passwordConfirmVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _passwordConfirmVisible = false;
                              });
                            },
                            child: Icon(_passwordConfirmVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        onEditingComplete: () {
                          _formKey.currentState.validate();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        validator: (text) {
                          if (text.isEmpty || text.length < 6)
                            return "Senha inválida!";
                          if (text != _passController.text)
                            return "Confirmação de Senha Diferente da Senha!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 44.0,
                        child: RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "ENVIAR",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Map<String, dynamic> userData = {
                                "name": _nameController.text.trim(),
                                "email": _emailController.text.trim(),
                              };

                              model.signUp(
                                  userData: userData,
                                  pass: _passController.text,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail);
                            }
                          },
                        ),
                      )
                    ],
                  ));
            }),
          ],
        ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar o usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
