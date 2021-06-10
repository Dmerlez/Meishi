import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_linkedin/linkedloginflutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meishi_v1/screens/ownprofileview_screen.dart';
import 'package:meishi_v1/screens/principalView_screen.dart';
import 'package:meishi_v1/widgets/UserProfilePage.dart';

class PrincipalScreen extends StatefulWidget {
  static const String routename = "/principal_screen";

  PrincipalScreen({Key key}) : super(key: key);

  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  bool isSelected1 = true;
  bool isSelected2 = false;
  TextEditingController _userController = TextEditingController();
  TextEditingController _userControllerManual = TextEditingController();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    PrincipalView(),
    Text('Index 0: Sin contactos', style: optionStyle),
    ProfileOwnView(),
  ];

  AnimationController _animationController;
  bool isOpen = false;

  PageController _myPage = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
    _userController.text = '@';
    _userControllerManual.text = '@';
    setState(() {
      boton_1 = false;
    });
  }

  bool boton_1 = false;
  String user = "";

  Future<void> _scanCode() async {
    ScanResult qrScanResult = await BarcodeScanner.scan();
    String qrResult = qrScanResult.rawContent;

    _userController.text = qrResult;

    setState(() {
      user = _userController.text;
    });

    var data = await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: _userController.text)
        .getDocuments();

    var data1 = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: _auth.currentUser.uid)
        .getDocuments();

    if (_userController.text == data.documents.first['username'] &&
        data.documents.first['uid'] != _auth.currentUser.uid) {
      var firebaseUser = FirebaseAuth.instance.currentUser;

      DocumentReference docRef = Firestore.instance
          .collection('users')
          .document(_auth.currentUser.uid);
      DocumentSnapshot doc = await docRef.get();

      docRef.updateData({
        'SenderRequestList':
            FieldValue.arrayUnion([data.documents.first['uid']])
      });

      DocumentReference docRef1 = Firestore.instance
          .collection('users')
          .document(data.documents.first['uid']);
      DocumentSnapshot doc1 = await docRef1.get();

      docRef1.updateData({
        'requestList': FieldValue.arrayUnion([_auth.currentUser.uid])
      });

      FirebaseFirestore.instance
          .collection('users')
          .document(_auth.currentUser.uid)
          .updateData({});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return alert;
        },
      );
    } else {
      print('no');
    }
  }

  AlertDialog alert = AlertDialog(
    title: Text('Solicitud enviada'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        pageSnapping: false,
        controller: _myPage,
        onPageChanged: (int) {},
        children: <Widget>[
          Center(child: PrincipalView()),
          Center(child: ProfileOwnView())
        ],
      ),
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black,
        child: Icon(boton_1 ? Icons.group_add : Icons.add_box_outlined),
        animatedIconTheme: IconThemeData(size: 30),
        marginBottom: MediaQuery.of(context).size.height * 0.05,
        marginRight: MediaQuery.of(context).size.width * 0.465,
        onOpen: () {
          setState(() {
            boton_1 = true;
          });
        },
        onClose: () {
          setState(() {
            boton_1 = false;
          });
        },
        children: [
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.edit),
            backgroundColor: Colors.blueGrey,
            label: 'Manualmente',
            labelStyle: TextStyle(fontSize: 13),
            onTap: () => _displayDialog(context),
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.qrcode),
            backgroundColor: Colors.blueGrey,
            label: 'Código QR',
            labelStyle: TextStyle(fontSize: 13),
            onTap: () => _scanCode(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: IconButton(
                  onPressed: () {
                    PrincipalView();
                    setState(() {
                      _myPage.jumpToPage(0);

                      setState(() {
                        isSelected1 = true;

                        isSelected2 = false;
                      });
                    });
                  },
                  icon: Icon(Icons.business_center,
                      size: 40,
                      color: isSelected1 ? Colors.black : Colors.grey)),
            ),
            Expanded(child: new Text('')),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    ProfileOwnView();
                    setState(() {
                      _myPage.jumpToPage(1);
                      isSelected1 = false;
                      isSelected2 = true;
                    });
                  },
                  icon: Icon(Icons.person_outline,
                      size: 40,
                      color: isSelected2 ? Colors.black : Colors.grey)),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /*Widget getEmail() {
    LinkedInLogin.getEmail(
        destroySession: true,
        forceLogin: true,
        appBar: AppBar(
          title: Text('demo pagin'),
        )).then((email) {
      print('Email: ${email.elements.first.elementHandle.emailAddress}');
    }).catchError((error) {
      print(error);
    });
  }*/

  _displayDialog1(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text('Agregar nombre de usuario'));
        });
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar nombre de usuario'),
            content: TextFormField(
              controller: _userControllerManual,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: "Nombre de usuario",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
            actions: <Widget>[
              Container(
                  padding: EdgeInsets.only(right: 15),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ButtonTheme(
                          minWidth: 245,
                          child: RaisedButton(
                            color: Colors.pink,
                            child: Text(
                              'Enviar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              var data = await Firestore.instance
                                  .collection('users')
                                  .where('username',
                                      isEqualTo: _userControllerManual.text)
                                  .getDocuments();

                              var data1 = await Firestore.instance
                                  .collection('users')
                                  .where('uid',
                                      isEqualTo: _auth.currentUser.uid)
                                  .getDocuments();

                              if (_userControllerManual.text ==
                                      data.documents.first['username'] &&
                                  data.documents.first['uid'] !=
                                      _auth.currentUser.uid) {
                                var firebaseUser =
                                    FirebaseAuth.instance.currentUser;

                                DocumentReference docRef = Firestore.instance
                                    .collection('users')
                                    .document(_auth.currentUser.uid);
                                DocumentSnapshot doc = await docRef.get();

                                docRef.updateData({
                                  'SenderRequestList': FieldValue.arrayUnion(
                                      [data.documents.first['uid']])
                                });

                                DocumentReference docRef1 = Firestore.instance
                                    .collection('users')
                                    .document(data.documents.first['uid']);
                                DocumentSnapshot doc1 = await docRef1.get();

                                docRef1.updateData({
                                  'requestList': FieldValue.arrayUnion(
                                      [_auth.currentUser.uid])
                                });

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .document(_auth.currentUser.uid)
                                    .updateData({});

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    Future.delayed(Duration(seconds: 1), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return alert;
                                  },
                                );
                                _userControllerManual.text = '@';
                              } else {
                                print('no');
                              }
                            },
                          )),
                    ],
                  )),
            ],
          );
        });
  }
}
