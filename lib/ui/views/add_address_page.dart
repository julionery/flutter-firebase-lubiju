import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lubiju/helpers/address_helper.dart';
import 'package:lubiju/models/user_model.dart';
import 'package:lubiju/ui/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class AddAddressPage extends StatefulWidget {
  final DocumentSnapshot snapshot;

  AddAddressPage(this.snapshot);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _nameController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00) 0 0000-0000');
  final _addressController = TextEditingController();
  final _cepController = MaskedTextController(mask: '00.000-000');
  final _complementController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _cepFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _complementFocus = FocusNode();
  final _districtFocus = FocusNode();
  final _cityFocus = FocusNode();

  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownStateValue = 'Goiás (GO)';
  bool _default = true;

  @override
  void initState() {
    super.initState();
    if (widget.snapshot != null) {
      var _data = widget.snapshot.data;

      _nameController.text = _data["name"];
      _phoneController.text = _data["phone"];
      _cityController.text = _data["city"];
      _addressController.text = _data["address"];
      _cepController.text = _data["cep"];
      _complementController.text = _data["complement"];
      _districtController.text = _data["district"];
      _default = _data["default"];

      if (_data["state"] != null) dropdownStateValue = _data["state"];
    }
  }

  void _defaultChanged(bool value) {
    setState(() {
      _default = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.snapshot == null
                ? "Adicionar Novo Endereço"
                : "Editar Endereço de Envio"),
            centerTitle: true,
            elevation: 0,
            actions: <Widget>[
              widget.snapshot != null
                  ? Container(
                      padding: EdgeInsets.only(right: 8.0),
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              _showDialogDelete(uid);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text("")
            ],
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
              ScopedModel<AddressHelper>(
                  model: AddressHelper(),
                  child: ScopedModelDescendant<AddressHelper>(
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
                              focusNode: _nameFocus,
                              controller: _nameController,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(_phoneFocus);
                              },
                              decoration: InputDecoration(
                                  hasFloatingPlaceholder: true,
                                  labelText: "Nome para Contato*",
                                  icon: Icon(Icons.person)),
                              validator: (text) {
                                if (text.trim().isEmpty)
                                  return "Nome inválido!";
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              focusNode: _phoneFocus,
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(_cepFocus);
                              },
                              controller: _phoneController,
                              decoration: InputDecoration(
                                  hasFloatingPlaceholder: true,
                                  labelText: "Telefone*",
                                  icon: Icon(Icons.phone)),
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text.trim().isEmpty)
                                  return "Telefone inválido!";
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              focusNode: _cepFocus,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(_addressFocus);
                              },
                              controller: _cepController,
                              decoration: InputDecoration(
                                  hasFloatingPlaceholder: true,
                                  labelText: "CEP",
                                  icon: Icon(Icons.my_location)),
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              focusNode: _addressFocus,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(_complementFocus);
                              },
                              controller: _addressController,
                              decoration: InputDecoration(
                                  hasFloatingPlaceholder: true,
                                  labelText:
                                      "Endereço físico, caixa postal, etc.*",
                                  icon: Icon(Icons.location_on)),
                              validator: (text) {
                                if (text.trim().isEmpty)
                                  return "Endereço inválido!";
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              focusNode: _complementFocus,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(_districtFocus);
                              },
                              controller: _complementController,
                              decoration: InputDecoration(
                                  hasFloatingPlaceholder: true,
                                  labelText: "Apto, conjunto, unidade, etc.",
                                  icon: Icon(Icons.comment)),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              focusNode: _districtFocus,
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(_cityFocus);
                              },
                              controller: _districtController,
                              decoration: InputDecoration(
                                  hasFloatingPlaceholder: true,
                                  labelText: "Bairro*",
                                  icon: Icon(Icons.location_on)),
                              validator: (text) {
                                if (text.trim().isEmpty)
                                  return "Bairro inválido!";
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              focusNode: _cityFocus,
                              controller: _cityController,
                              decoration: InputDecoration(
                                  hasFloatingPlaceholder: true,
                                  labelText: "Cidade*",
                                  icon: Icon(Icons.location_city)),
                              validator: (text) {
                                if (text.trim().isEmpty)
                                  return "Cidade inválida!";
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.public,
                                    color: Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 16.0),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dropdownStateValue,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownStateValue = newValue;
                                        });
                                      },
                                      items: <String>[
                                        'Acre (AC)',
                                        'Alagoas (AL)',
                                        'Amapá (AP)',
                                        'Amazonas (AM)',
                                        'Bahia (BA)',
                                        'Ceará (CE)',
                                        'Distrito Federal (DF)',
                                        'Espírito Santo (ES)',
                                        'Goiás (GO)',
                                        'Maranhão (MA)',
                                        'Mato Grosso (MT)',
                                        'Mato Grosso do Sul (MS)',
                                        'Minas Gerais (MG)',
                                        'Pará (PA)',
                                        'Paraíba (PB)',
                                        'Paraná (PR)',
                                        'Pernambuco (PE)',
                                        'Piauí (PI)',
                                        'Rio de Janeiro (RJ)',
                                        'Rio Grande do Norte (RN)',
                                        'Rio Grande do Sul (RS)',
                                        'Rondônia (RO)',
                                        'Roraima (RR)',
                                        'Santa Catarina (SC)',
                                        'São Paulo (SP)',
                                        'Sergipe (SE)',
                                        'Tocantins (TO)'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                    child: Image(
                                        image: AssetImage(
                                            'images/icons/brazil_flag.png')))
                              ],
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "Definir como endereço padrão de envio?"),
                                ),
                                Switch(
                                    value: _default,
                                    onChanged: _defaultChanged),
                              ],
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            SizedBox(
                              height: 44.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0)),
                                child: Text(
                                  "SALVAR",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    Map<String, dynamic> _data = {
                                      "name": _nameController.text.trim(),
                                      "phone": _phoneController.text,
                                      "cep": _cepController.text,
                                      "address": _addressController.text,
                                      "district": _districtController.text,
                                      "complement": _complementController.text,
                                      "city": _cityController.text,
                                      "state": dropdownStateValue,
                                      "country": "Brasil",
                                      "default": _default,
                                    };

                                    if (widget.snapshot == null) {
                                      model.save(
                                          data: _data,
                                          idUser: uid,
                                          onSuccess: _onSuccess,
                                          onFail: _onFail);
                                    } else {
                                      model.update(
                                          data: _data,
                                          idUser: uid,
                                          idAddress: widget.snapshot.documentID,
                                          onSuccess: _onSuccess,
                                          onFail: _onFail);
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ));
                  })),
            ],
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Endereços"),
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

  void _showDialogDelete(String uid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente deletar este endereço?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                Navigator.of(context).pop();
                AddressHelper().delete(
                    idUser: uid,
                    idAddress: widget.snapshot.documentID,
                    onSuccess: _onSuccess,
                    onFail: _onFail);
              },
            ),
          ],
        );
      },
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
