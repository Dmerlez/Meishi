import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter_linkedin/linkedloginflutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meishi_v1/mixins/validation_mixins.dart';
import 'package:flutter/material.dart';
import 'package:meishi_v1/widgets/app_error_message.dart';
import 'package:meishi_v1/widgets/meishi_createuserfields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CreateUserProfileScreen extends StatefulWidget with ValidationMixins {
  static const String routename = "/createuserprofile_screen";

  _CreateUserProfileScreenState createState() =>
      _CreateUserProfileScreenState();
}

class _CreateUserProfileScreenState extends State<CreateUserProfileScreen>
    with ValidationMixins {
  File _imageFile;
  final ImagePicker _picker = ImagePicker();

  FocusNode _focusNode;
  bool _autoValidate = false;

  final _auth = FirebaseAuth.instance;
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _cargoController = TextEditingController();
  TextEditingController _empresaController = TextEditingController();
  TextEditingController _emailCorpController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _webEmpresaController = TextEditingController();
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var uuid = Uuid().v1().toString();

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController();
    _cargoController = TextEditingController();
    _empresaController = TextEditingController();
    _emailCorpController = TextEditingController();
    _telefonoController = TextEditingController();
    _webEmpresaController = TextEditingController();
    _usuarioController = TextEditingController();
    _usuarioController.text = "@";
    if (_auth.currentUser.email == null) {
      //LinkEmail();
    }
  }

  /*void LinkLogin() {
    LinkedInLogin.getProfile(
        destroySession: true,
        forceLogin: true,
        appBar: AppBar(
          title: Text('Meishi'),
        )).then((profile) {
      print('First name: ${profile.firstName}');
      print(
          'Avatar: ${profile.profilePicture.profilePictureDisplayImage.elements.first.identifiers.first.identifier}');
    }).catchError((error) {
      print(error.errorDescription);
    });
  }*/

  String email1 = "";

  /*void LinkEmail() {
    LinkedInLogin.getEmail().then((email) {
      String hola =
          '${email.elements.first.elementHandle.emailAddress}'.toString();
      email1 = hola;
    }).catchError((error) {
      print(error.errorDescription);
    });
  }*/

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff141b21),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _irAtras(),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15),
                            _primerTexto(),
                            SizedBox(height: 10),
                            _segundoTexto(),
                            SizedBox(
                              height: 35,
                            ),
                            imageProfile(),
                            SizedBox(height: 15),
                            Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textUsuario(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _usuarioField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textNombre(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _nombreField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textCargo(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _cargoField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textDireccion(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _direccionField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textEmpresa(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _empresaField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textEmailCorporativo(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _emailCorporativoField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textTelefono(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _telefonoField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textWebEmpresa(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _webEmpresaField(),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: _textPais(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          child: _listPais(),
                                        ),
                                        SizedBox(height: 40),
                                        _showErrorMessage(),
                                        _botonRegistrar(),
                                        SizedBox(
                                          height: 40,
                                        )
                                      ]),
                                ])),
                          ])
                    ]),
              )),
        ));
  }

  Widget imageProfile() {
    return Center(
        child: Stack(children: <Widget>[
      CircleAvatar(
        radius: 95,
        backgroundImage: _imageFile == null
            ? AssetImage("images/Meishi.PNG")
            : FileImage(File(_imageFile.path)),
      ),
      Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.photo_camera,
              color: Colors.teal,
              size: 35,
            ),
          ))
    ]));
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text("Elegir foto de perfil",
              style: TextStyle(
                fontSize: 20.0,
              )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("camara"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Galería"),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _errorMessage = "";

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return ErrorMessage(errorMessage: _errorMessage);
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _irAtras() {
    return FlatButton(
        textColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
          //Navigator.pushNamed(context, '/login_screen');
        },
        child:
            Icon(Icons.chevron_left_rounded, size: 30.0, color: Colors.white));
  }

  Widget _primerTexto() {
    return Text("Completa tu perfil",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget _segundoTexto() {
    return Text("Completa tu información para\ncomenzar a usar Meishi",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 19.0,
        ));
  }

  Widget _textUsuario() {
    return Text("Usuario",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _usuarioField() {
    return AppUserTextEmailField(
      inputText: "Ingresa tu nombre de usuario",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateUserName,
      controller: _usuarioController,
      onSaved: (value) {
        //userExists(value);
      },
    );
  }

  Widget _textDireccion() {
    return Text("Dirección",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _direccionField() {
    return AppUserTextEmailField(
      inputText: "Ingresa tu dirección",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateName,
      controller: _direccionController,
      onSaved: (value) {},
    );
  }

  Widget _textNombre() {
    return Text("Nombre",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _nombreField() {
    return AppUserTextEmailField(
      inputText: "Ingresa tu nombre",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateName,
      controller: _nombreController,
      onSaved: (value) {},
    );
  }

  Widget _textCargo() {
    return Text("Cargo o posición",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _cargoField() {
    return AppUserTextEmailField(
      inputText: "Ingresa tu posición de trabajo",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateName,
      controller: _cargoController,
      onSaved: (value) {},
    );
  }

  Widget _textEmpresa() {
    return Text("Empresa",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _empresaField() {
    return AppUserTextEmailField(
      inputText: "Nombre de la empresa en que trabajas",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateName,
      controller: _empresaController,
      onSaved: (value) {},
    );
  }

  Widget _textEmailCorporativo() {
    return Text("Email Corporativo",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _emailCorporativoField() {
    return AppUserTextEmailField(
      inputText: "Ingresa tu email de trabajo",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateEmail,
      controller: _emailCorpController,
      onSaved: (value) {},
    );
  }

  Widget _textTelefono() {
    return Text("Teléfono",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _telefonoField() {
    return AppUserTextEmailField(
      inputText: "Ingresa tu teléfono",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validatePhone,
      controller: _telefonoController,
      onSaved: (value) {},
    );
  }

  Widget _textWebEmpresa() {
    return Text("Web de empresa",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _webEmpresaField() {
    return AppUserTextEmailField(
      inputText: "Ingresa la pàgina web de tu trabajo",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateName,
      controller: _webEmpresaController,
      onSaved: (value) {},
    );
  }

  Widget _textPais() {
    return Text("Paìs",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  String pais = "Afghanistan";

  Widget _listPais() {
    return Container(
        height: 55.0,
        decoration: BoxDecoration(
            color: const Color(0xff1c2c34),
            border: Border.all(width: 0.0),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            )),
        child: CountryListPick(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Seleccionar un País"),
          ),
          pickerBuilder: (context, CountryCode code) {
            return Row(children: [
              SizedBox(width: 15),
              Image.asset(
                code.flagUri,
                package: 'country_list_pick',
                height: 30,
                width: 30,
              ),
              SizedBox(width: 10),
              Text(code.name,
                  style: TextStyle(
                    color: const Color(0xff657885),
                    fontSize: 18.0,
                  )),
            ]);
          },
          onChanged: (CountryCode code) {
            Text(code.flagUri);
            Text(code.name);
            pais = code.name;
          },
        ));
  }

  Widget _botonRegistrar() {
    return ButtonTheme(
        minWidth: 400.0,
        height: 60.0,
        child: FlatButton(
            color: const Color(0xff788d9b),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: () async {
              var data = await FirebaseFirestore.instance
                  .collection('users')
                  .getDocuments();

              if (_formKey.currentState.validate()) {
                if (data.documents.length == 0) {
                  userSetup(_auth.currentUser.uid);
                  //data.documents.first['username'] != _usuarioController.text
                } else if (data.documents.length > 0 &&
                    data.documents.first['username'] !=
                        _usuarioController.text) {
                  userSetup(_auth.currentUser.uid);
                } else {
                  return Text('usuario ya existente');
                }
              }
            },
            child: Text(
              "Siguiente",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
  }

  Future<void> userSetup(String displayName) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    String uid = _auth.currentUser.uid.toString();

    FirebaseFirestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData({
      'displayName': displayName == null ? "" : _auth.currentUser.displayName,
      'uid': uid == null ? Uuid().v1 : _auth.currentUser.uid,
      'username': _usuarioController.text,
      'email':
          _auth.currentUser.email == null ? email1 : _auth.currentUser.email,
      'foto': (_imageFile == null)
          ? '/private/var/mobile/Containers/Data/Application/logo/CopiadeCaptura2.png'
          : _imageFile.path,
      'portada': (_imageFile == null)
          ? '/private/var/mobile/Containers/Data/Application/logo/CopiadeCaptura2.png'
          : _imageFile.path,
      'name': _nombreController.text,
      'cargo': _cargoController.text,
      'direccion': _direccionController.text,
      'empresa': _empresaController.text,
      'emailCorporativo': _emailCorpController.text,
      'telefono': _telefonoController.text,
      'webEmpresa': _webEmpresaController.text,
      'pais': pais,
      'friendList': _friendList.toList(),
      'favoriteList': _favoriteList.toList(),
      'SenderRequestList': _senderRequestList.toList(),
      'IsfavoriteList': _isFavoriteList.toList(),
      'requestList': _requestList.toList(),
    });
    uploadImageToFirebase(context);
    //print("guardado");
    Navigator.pushNamedAndRemoveUntil(
        context, '/principal_screen', (route) => false);
    return;
  }

  List _friendList = [];
  List _favoriteList = [];
  List _senderRequestList = [];
  List _isFavoriteList = [];
  List _requestList = [];

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('Profile/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 60);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}
