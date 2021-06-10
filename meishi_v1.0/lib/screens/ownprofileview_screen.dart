import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meishi_v1/screens/enlaces_screen.dart';
import 'package:meishi_v1/screens/ownRecomendation_screen.dart';
import 'package:meishi_v1/screens/qr_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileOwnView extends StatefulWidget {
  static const String routename = "/ownprofile_screen";
  _ProfileOwnViewState createState() => _ProfileOwnViewState();
}

class _ProfileOwnViewState extends State<ProfileOwnView> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  int contactos = 0;
  int recomendaciones = 0;
  int enlaces = 0;
  bool isSignIn = true;
  var _recomendationList = [];
  List contacts = [];
  List listEnlaces = [];
  double _offset = 0.0;

  getContactos() async {
    DocumentReference docRef =
        Firestore.instance.collection('users').document(_auth.currentUser.uid);
    DocumentSnapshot doc = await docRef.get();
    List friendList = doc.data()['friendList'];

    setState(() {
      contacts = friendList;
      contactos = contacts.length;
      print(contacts.length);
    });
  }

  initState() {
    super.initState();
    getRecomendations();
    getContactos();
    getEnlaces();
    getData();
  }

  getEnlaces() async {
    var data1 = await Firestore.instance
        .collection('enlaces')
        .where('uidEnlace', isEqualTo: _auth.currentUser.uid)
        .getDocuments();

    setState(() {
      listEnlaces = data1.documents;
    });

    for (var enlacess in data1.documents) {
      enlaces++;

      print(enlaces);
    }
  }

  getData() async {
    Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: "${_auth.currentUser.uid}")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _offset = snapshot.documents.first['position'];
    });
  }

  getRecomendations() async {
    var data = await Firestore.instance
        .collection('recomendations')
        .where('uidUserRecomendation', isEqualTo: "${_auth.currentUser.uid}")
        .getDocuments();

    setState(() {
      _recomendationList = data.documents;
    });

    for (var recomendation in data.documents) {
      recomendaciones++;
    }
  }

  Future<void> _launchInApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('users')
                .where('uid', isEqualTo: "${_auth.currentUser.uid}")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Scaffold(
                    key: _scaffoldKey,
                    resizeToAvoidBottomInset: false,
                    drawer: Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: const Color(0xff141b21)),
                      child: new Drawer(
                          child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          SizedBox(
                            height: 150,
                          ),
                          ListTile(
                            title: Text(
                              'Editar mi tarjeta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/editProfile_screen');
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Cambiar Contraseña',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Términos y Condiciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onTap:(){
                              _launchInApp('https://mprogol.cl/wp-content/uploads/2021/06/Poli%CC%81tica-de-Privacidad-para-aplicaciones-mo%CC%81viles.docx-1-1.pdf');
                            }
                          ),
                          ListTile(
                            title: Text(
                              'Sobre Meishi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/launch_screen_profile');
                            },
                          ),
                          SizedBox(height: 30),
                          Container(
                              padding: EdgeInsets.only(right: 40, left: 17),
                              child: Divider(
                                color: Colors.white,
                              )),
                          SizedBox(height: 10),
                          ListTile(
                            title: Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () {
                              _signOut();
                            },
                          ),
                          SizedBox(height: 100),
                          Image(
                            width: 150,
                            height: 150,
                            image: AssetImage('images/sin_fondo_meishi.png'),
                          )
                        ],
                      )),
                    ),
                    body: Stack(
                        children: snapshot.data.documents.map((document) {
                      return Stack(
                        children: <Widget>[
                          Positioned(
                            top: _offset,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: !snapshot.hasData
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Image(
                                          image: FirebaseImage(
                                            'gs://meishi-7d80a.appspot.com/Profile/' +
                                                document['portada'],
                                            maxSizeBytes: 3500 * 1000,
                                          ),
                                          fit: BoxFit.cover),
                                )),
                          ),
                          SafeArea(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () async {
                                  _scaffoldKey.currentState.openDrawer();
                                },
                                fillColor: Colors.grey.withOpacity(0.8),
                                child: Icon(
                                  Icons.menu,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () async {
                                  DocumentSnapshot result = await Firestore
                                      .instance
                                      .collection('users')
                                      .document(_auth.currentUser.uid)
                                      .get();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QrPage(userInfo: result)));
                                },
                                fillColor: Colors.grey.withOpacity(0.8),
                                child: FaIcon(FontAwesomeIcons.qrcode,
                                    size: 25.0, color: Colors.white),
                                padding: EdgeInsets.all(10),
                                shape: CircleBorder(),
                              ),
                            ],
                          )),
                          Container(
                            child: Column(
                              children: [
                                Center(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(75)),
                                          image: !snapshot.hasData
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : DecorationImage(
                                                  image: FirebaseImage(
                                                    'gs://meishi-7d80a.appspot.com/Profile/' +
                                                        document['foto'],
                                                    maxSizeBytes: 3500 * 1000,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                    ),
                                  ),
                                )),
                                SizedBox(height: 15),
                                Flexible(
                                    child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        document['name'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Text(
                                        document['email'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Flexible(
                                        child: DraggableScrollableSheet(
                                            minChildSize: 0.1,
                                            initialChildSize: 0.90,
                                            builder:
                                                (context, scrollController) {
                                              return SingleChildScrollView(
                                                  child: Container(
                                                      child: Center(
                                                          child: Container(
                                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                            child: Column(
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  Navigator.pushNamedAndRemoveUntil(
                                                                      context,
                                                                      '/principal_screen',
                                                                      (route) =>
                                                                          false);
                                                                },
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "Contactos",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey[700],
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "$contactos",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .lightBlueAccent,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        fontSize:
                                                                            25,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                            SizedBox(height: 5),
                                                          ],
                                                        )),
                                                        SizedBox(width: 30),
                                                        Container(
                                                            child: Column(
                                                          children: <Widget>[
                                                            InkWell(
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Recomendaciones",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          700],
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    '$recomendaciones',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightBlueAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontSize:
                                                                          25,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () async {
                                                                DocumentSnapshot
                                                                    result =
                                                                    snapshot
                                                                        .data
                                                                        .documents
                                                                        .first;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                OwnRecomendationView(userInfo: result)));
                                                              },
                                                            ),
                                                          ],
                                                        )),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1),
                                                        Container(
                                                            child: Column(
                                                          children: <Widget>[
                                                            InkWell(
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Enlaces",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          700],
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    '$enlaces',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightBlueAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontSize:
                                                                          25,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () async {
                                                                DocumentSnapshot
                                                                    result =
                                                                    snapshot
                                                                        .data
                                                                        .documents
                                                                        .first;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                EnlacesScreen(userInfo: result)));
                                                              },
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text(
                                                              "NOMBRE DE USUARIO",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 30),
                                                            child: Text(
                                                              document[
                                                                  'username'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[900],
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text("CARGO",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 30),
                                                            child: Text(
                                                              document['cargo'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[900],
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text("EMPRESA",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(width: 10),
                                                      Flexible(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          30),
                                                              child: Text(
                                                                document[
                                                                    'empresa'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      900],
                                                                  fontSize: 14,
                                                                ),
                                                              )))
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text(
                                                              "DIRECCIÓN",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 30),
                                                            child: Text(
                                                              document[
                                                                  'direccion'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[900],
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text("EMAIL",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(width: 10),
                                                      Flexible(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          30),
                                                              child: Text(
                                                                document[
                                                                    'emailCorporativo'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      900],
                                                                  fontSize: 14,
                                                                ),
                                                              )))
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text(
                                                              "TELÉFONO",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(width: 10),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 30),
                                                          child: Text(
                                                            document[
                                                                'telefono'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[900],
                                                              fontSize: 14,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text(
                                                              "SITIO WEB",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(width: 10),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 30),
                                                          child: Text(
                                                            document[
                                                                'webEmpresa'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[900],
                                                              fontSize: 14,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text("PAÍS",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(width: 10),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 30),
                                                          child: Text(
                                                            document['pais'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[900],
                                                              fontSize: 14,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 20,
                                                  )
                                                ],
                                              )))));
                                            }))
                                  ],
                                )),
                              ],
                            ),
                          )
                        ],
                      );
                    }).toList()));
              }
            }));
  }

  _signOut() async {
    await _auth.signOut();
    Navigator.pushNamed(context, '/login_screen');
  }
}
