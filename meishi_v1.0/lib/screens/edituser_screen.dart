import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meishi_v1/mixins/validation_mixins.dart';

class EditProfileView extends StatefulWidget with ValidationMixins {
  static const String routename = "/editProfile_screen";
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with ValidationMixins {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _imageFile;
  File _portadaFile;
  final ImagePicker _picker = ImagePicker();
  String pais = "Chile";
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _cargoController = TextEditingController();
  TextEditingController _empresaController = TextEditingController();
  TextEditingController _emailCorpController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _webEmpresaController = TextEditingController();
  TextEditingController _paisController = TextEditingController();

  TextEditingController _imageController = TextEditingController();
  TextEditingController _portadaController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  double _offset = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: "${_auth.currentUser.uid}")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _nombreController.text = snapshot.documents.first['name'];
      _cargoController.text = snapshot.documents.first['cargo'];
      _empresaController.text = snapshot.documents.first['empresa'];
      _emailCorpController.text = snapshot.documents.first['emailCorporativo'];
      _telefonoController.text = snapshot.documents.first['telefono'];
      _webEmpresaController.text = snapshot.documents.first['webEmpresa'];
      _paisController.text = snapshot.documents.first['pais'];
      _imageController.text = snapshot.documents.first['foto'];
      _portadaController.text = snapshot.documents.first['portada'];
      _direccionController.text = snapshot.documents.first['direccion'];
      _userController.text = snapshot.documents.first['username'];
      _friendList = snapshot.documents.first['friendList'];
      _favoriteList = snapshot.documents.first['favoriteList'];
      _senderRequestList = snapshot.documents.first['SenderRequestList'];
      _isFavoriteList = snapshot.documents.first['IsfavoriteList'];
      _requestList = snapshot.documents.first['requestList'];

      _nombre1Controller.text = snapshot.documents.first['name'];
      _cargo1Controller.text = snapshot.documents.first['cargo'];
      _telefono1Controller.text = snapshot.documents.first['telefono'];
      _emailCorp1Controller.text = snapshot.documents.first['emailCorporativo'];
      _sitioWeb1Controller.text = snapshot.documents.first['webEmpresa'];
      _empresa1Controller.text = snapshot.documents.first['empresa'];
      _direccion1Controller.text = snapshot.documents.first['direccion'];
      _offset = snapshot.documents.first['position'];
    });

    print(_cargo1Controller.text);
  }

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

  Future uploadPortadaToFirebase(BuildContext context) async {
    String fileName = _portadaFile.path;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('Profile/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_portadaFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  void addUser(String displayName) async {
    var User = await FirebaseAuth.instance.currentUser;
    String uid = _auth.currentUser.uid.toString();
    Firestore.instance.collection('users').document(User.uid).setData({
      'displayName': displayName == null ? "" : _auth.currentUser.displayName,
      'uid': uid == null ? "" : _auth.currentUser.uid,
      'email': _auth.currentUser.email == null ? "" : _auth.currentUser.email,
      'foto': (_imageFile == null) ? _imageController.text : _imageFile.path,
      'portada':
          (_portadaFile == null) ? _portadaController.text : _portadaFile.path,
      'name': _nombreController.text,
      'cargo': _cargoController.text,
      'direccion': _direccionController.text,
      'empresa': _empresaController.text,
      'emailCorporativo': _emailCorpController.text,
      'telefono': _telefonoController.text,
      'webEmpresa': _webEmpresaController.text,
      'pais': pais,
      'username': _userController.text,
      'friendList': _friendList.toList(),
      'favoriteList': _favoriteList.toList(),
      'SenderRequestList': _senderRequestList.toList(),
      'IsfavoriteList': _isFavoriteList.toList(),
      'requestList': _requestList.toList(),
      'position': offset.dy,
    });

    if (_nombre1Controller.text != _nombreController.text) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyy-MM-dd');
      final String formatted = formatter.format(now);
      FirebaseFirestore.instance
          .collection('nameSolicitud')
          .document()
          .setData({
        'uidNombreSolicitud': _auth.currentUser.uid,
        'data': _nombre1Controller.text,
        'newData': _nombreController.text,
        'fecha': formatted,
        'name': _nombreController.text,
        'friendList': _friendList.toList(),
        'dato': 'Nombre',
        'fechaHora': now,
      });
    }

    if (_cargo1Controller.text != _cargoController.text) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyy-MM-dd');
      final String formatted = formatter.format(now);
      FirebaseFirestore.instance
          .collection('nameSolicitud')
          .document()
          .setData({
        'uidCargoSolicitud': _auth.currentUser.uid,
        'data': _cargo1Controller.text,
        'newData': _cargoController.text,
        'fecha': formatted,
        'name': _nombreController.text,
        'friendList': _friendList.toList(),
        'dato': 'Cargo',
        'fechaHora': now,
      });
    }

    if (_telefono1Controller.text != _telefonoController.text) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyy-MM-dd');
      final String formatted = formatter.format(now);
      FirebaseFirestore.instance
          .collection('nameSolicitud')
          .document()
          .setData({
        'uidCargoSolicitud': _auth.currentUser.uid,
        'data': _telefono1Controller.text,
        'newData': _telefonoController.text,
        'fecha': formatted,
        'name': _nombreController.text,
        'friendList': _friendList.toList(),
        'dato': 'Telefono',
        'fechaHora': now,
      });
    }

    if (_emailCorp1Controller.text != _emailCorpController.text) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyy-MM-dd');
      final String formatted = formatter.format(now);
      FirebaseFirestore.instance
          .collection('nameSolicitud')
          .document()
          .setData({
        'uidCargoSolicitud': _auth.currentUser.uid,
        'data': _emailCorp1Controller.text,
        'newData': _emailCorpController.text,
        'fecha': formatted,
        'name': _nombreController.text,
        'friendList': _friendList.toList(),
        'dato': 'Email Corporativo',
        'fechaHora': now,
      });
    }

    if (_sitioWeb1Controller.text != _webEmpresaController.text) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyy-MM-dd');
      final String formatted = formatter.format(now);
      FirebaseFirestore.instance
          .collection('nameSolicitud')
          .document()
          .setData({
        'uidCargoSolicitud': _auth.currentUser.uid,
        'data': _sitioWeb1Controller.text,
        'newData': _webEmpresaController.text,
        'fecha': formatted,
        'name': _nombreController.text,
        'friendList': _friendList.toList(),
        'dato': 'Sitio web',
        'fechaHora': now,
      });
    }

    if (_empresa1Controller.text != _empresaController.text) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyy-MM-dd');
      final String formatted = formatter.format(now);
      FirebaseFirestore.instance
          .collection('nameSolicitud')
          .document()
          .setData({
        'uidCargoSolicitud': _auth.currentUser.uid,
        'data': _empresa1Controller.text,
        'newData': _empresaController.text,
        'fecha': formatted,
        'name': _nombreController.text,
        'friendList': _friendList.toList(),
        'dato': 'Empresa',
        'fechaHora': now,
      });
    }

    if (_direccion1Controller.text != _direccionController.text) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyy-MM-dd');
      final String formatted = formatter.format(now);
      FirebaseFirestore.instance
          .collection('nameSolicitud')
          .document()
          .setData({
        'uidCargoSolicitud': _auth.currentUser.uid,
        'data': _direccion1Controller.text,
        'newData': _direccionController.text,
        'fecha': formatted,
        'name': _nombreController.text,
        'friendList': _friendList.toList(),
        'dato': 'Dirección',
        'fechaHora': now,
      });
    }

    uploadPortadaToFirebase(context);
    uploadImageToFirebase(context);
    Navigator.pushNamed(context, '/principal_screen');
  }

  TextEditingController _nombre1Controller = TextEditingController();
  TextEditingController _cargo1Controller = TextEditingController();
  TextEditingController _telefono1Controller = TextEditingController();
  TextEditingController _emailCorp1Controller = TextEditingController();
  TextEditingController _sitioWeb1Controller = TextEditingController();
  TextEditingController _empresa1Controller = TextEditingController();
  TextEditingController _direccion1Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List _friendList = [];
  List _favoriteList = [];
  List _senderRequestList = [];
  List _isFavoriteList = [];
  List _requestList = [];

  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .where('uid', isEqualTo: "${_auth.currentUser.uid}")
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return Scaffold(
                    key: _scaffoldKey,
                    body: SingleChildScrollView(
                        child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: offset.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              if (offset.dy > 0) {
                                setState(() {
                                  offset = Offset(
                                      offset.dx + offset.dx + details.delta.dx,
                                      0.0 + 0.0);
                                });
                              }
                              if (offset.dy < -190) {
                                setState(() {
                                  offset = Offset(
                                      offset.dx + offset.dx + details.delta.dx,
                                      -95.0 + -95.0);
                                });
                              }
                              setState(() {
                                offset = Offset(offset.dx + details.delta.dx,
                                    offset.dy + details.delta.dy);

                                print(offset.dy);
                                //print(details.delta.dy);
                              });
                            },
                            child: portadaProfile(),
                          ),
                        ),
                        SafeArea(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              fillColor: Colors.grey.withOpacity(0.8),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                size: 25.0,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(10),
                              shape: CircleBorder(),
                            ),
                            Row(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) =>
                                          bottomSheetPortada()),
                                    );
                                  },
                                  fillColor: Colors.grey.withOpacity(0.8),
                                  child: FaIcon(
                                    FontAwesomeIcons.camera,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                  constraints:
                                      BoxConstraints.tight(Size(45, 45)),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(width: 15),
                                RawMaterialButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        titlePadding: EdgeInsets.only(top: 60),
                                        title: Text('Guardar cambios',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        content: Text(
                                          '¿Estás seguro de modificar los datos de\ntu tarjeta Meishi?',
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: <Widget>[
                                          Row(children: <Widget>[
                                            ButtonTheme(
                                              height: 50,
                                              minWidth: 120,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: RaisedButton(
                                                color: const Color(0xff788d9b),
                                                textColor: Colors.white,
                                                child: Text('Cancelar',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 17)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            ButtonTheme(
                                              minWidth: 120,
                                              height: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: RaisedButton(
                                                color: Colors.pink,
                                                textColor: Colors.white,
                                                child: Text('Guardar',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 17)),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    addUser(_auth.currentUser
                                                        .displayName);
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            "/ownprofile_screen",
                                                            (route) => false);
                                                    imageCache.clear();
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ]),
                                          SizedBox(
                                            height: 80,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  fillColor: Colors.grey.withOpacity(0.8),
                                  child: FaIcon(
                                    FontAwesomeIcons.save,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                  constraints:
                                      BoxConstraints.tight(Size(45, 45)),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(
                                  width: 15,
                                )
                              ],
                            )
                          ],
                        )),
                        Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 200),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              height: MediaQuery.of(context).size.height,
                            ),
                            Stack(children: <Widget>[
                              Container(
                                  alignment: Alignment(0.0, -0.95),
                                  margin: EdgeInsets.only(top: 100),
                                  child: imageProfile()),
                            ]),
                            Form(
                                key: _formKey,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 300, left: 40, right: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Nombre",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey,
                                          )),
                                      TextFormField(
                                        validator: validateName,
                                        decoration: InputDecoration(
                                          fillColor: const Color(0xffEBECF1),
                                          filled: true,
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          hintStyle: TextStyle(
                                            color: const Color(0xff657885),
                                            fontSize: 18,
                                          ),
                                        ),
                                        controller: _nombreController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Cargo o posición",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      TextFormField(
                                        validator: validateName,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fillColor: const Color(0xffEBECF1),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: const Color(0xff657885),
                                            fontSize: 18,
                                          ),
                                        ),
                                        controller: _cargoController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Dirección",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      TextFormField(
                                        validator: validateName,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fillColor: const Color(0xffEBECF1),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: const Color(0xff657885),
                                            fontSize: 18,
                                          ),
                                        ),
                                        controller: _direccionController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Empresa",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      TextFormField(
                                        validator: validateName,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fillColor: const Color(0xffEBECF1),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: const Color(0xff657885),
                                            fontSize: 18,
                                          ),
                                        ),
                                        controller: _empresaController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Email corporativo",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      TextFormField(
                                        validator: validateEmail,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fillColor: const Color(0xffEBECF1),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: const Color(0xff657885),
                                            fontSize: 18,
                                          ),
                                        ),
                                        controller: _emailCorpController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Teléfono",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      TextFormField(
                                        validator: validatePhone,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fillColor: const Color(0xffEBECF1),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: const Color(0xff657885),
                                            fontSize: 18,
                                          ),
                                        ),
                                        controller: _telefonoController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Web de empresa",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      TextFormField(
                                        validator: validateName,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fillColor: const Color(0xffEBECF1),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: const Color(0xff657885),
                                            fontSize: 18,
                                          ),
                                        ),
                                        controller: _webEmpresaController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("País",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      Container(
                                          height: 55.0,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffEBECF1),
                                              border: Border.all(width: 0.0),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              )),
                                          child: CountryListPick(
                                            initialSelection: '+56',
                                            appBar: AppBar(
                                              backgroundColor:
                                                  const Color(0xffEBECF1),
                                              title:
                                                  Text("Seleccionar un País"),
                                            ),
                                            pickerBuilder:
                                                (context, CountryCode code) {
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
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                    )),
                                              ]);
                                            },
                                            onChanged: (CountryCode code) {
                                              Text(code.flagUri);
                                              Text(code.name);
                                              pais = code.name;
                                            },
                                          )),
                                      SizedBox(
                                        height: 50,
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ],
                    )));
              }
            }));
  }

  Widget imageProfile() {
    return Center(
        child: Stack(children: <Widget>[
      CircleAvatar(
        radius: 80,
        backgroundImage: _imageFile == null
            ? FirebaseImage('gs://meishi-7d80a.appspot.com/Profile/' +
                _imageController.text)
            : FileImage(File(_imageFile.path)),
      ),
      Positioned(
        bottom: 0.1,
        top: 0.1,
        right: 0.1,
        left: 0.1,
        child: RawMaterialButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: ((builder) => bottomSheet()),
            );
          },
          fillColor: Colors.black.withOpacity(0.4),
          child: Icon(
            Icons.photo_camera,
            color: Colors.white,
            size: 40,
          ),
          padding: EdgeInsets.all(10),
          shape: CircleBorder(),
        ),
      )
    ]));
  }

  Widget portadaProfile() {
    return InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomSheetPortada()),
          );
        },
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              child: _portadaFile == null
                  ? Image(
                      image: FirebaseImage(
                          'gs://meishi-7d80a.appspot.com/Profile/' +
                              _portadaController.text,
                          maxSizeBytes: 3500 * 1000),
                      fit: BoxFit.cover,
                    )
                  : Image.file(File(_portadaFile.path), fit: BoxFit.fill),
            )));
  }

  Widget bottomSheetPortada() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text("Elegir foto de portada",
              style: TextStyle(
                fontSize: 20.0,
              )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.camera,
                  size: 25,
                ),
                onPressed: () {
                  takePortada(ImageSource.camera);
                },
                label: Text("camara"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePortada(ImageSource.gallery);
                },
                label: Text("Galería"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePortada(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 60);
    setState(() {
      _portadaFile = File(pickedFile.path);
    });
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

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 60);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}
