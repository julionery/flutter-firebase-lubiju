import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lubiju/models/contact_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00) 0 0000-0000');
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Fale Conosco"),
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
            ScopedModel<ContactModel>(
                model: ContactModel(),
                child: ScopedModelDescendant<ContactModel>(
                    builder: (context, child, model) {
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
                              hasFloatingPlaceholder: true,
                              labelText: "Nome",
                              icon: Icon(Icons.person)),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              hasFloatingPlaceholder: true,
                              labelText: "E-mail",
                              icon: Icon(Icons.email)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                              hasFloatingPlaceholder: true,
                              labelText: "Telefone",
                              icon: Icon(Icons.phone)),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                              hasFloatingPlaceholder: true,
                              hintText: "Mensagem*"),
                          validator: (text) {
                            if (text.isEmpty) return "Informe a mensagem!";
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
                                Map<String, dynamic> _data = {
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                  "phone": _phoneController.text,
                                  "message": _messageController.text,
                                  "date": DateTime.now()
                                };

                                model.send(
                                    data: _data,
                                    onSuccess: _onSuccess,
                                    onFail: _onFail);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                })),
          ],
        ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Mensagem enviada com sucesso!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao enviar a mensagem!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
