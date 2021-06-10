import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatefulWidget {
  final DocumentSnapshot userInfo;

  const QrPage({Key key, this.userInfo}) : super(key: key);

  QrPageState createState() => QrPageState();
}

class QrPageState extends State<QrPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
  }

  getActualUser() {
    if (_auth.currentUser.uid == null) {
      setState(() {
        existe = true;
      });
    }
  }

  bool existe = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .where('uid', isEqualTo: _auth.currentUser.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Scaffold(
                body: SingleChildScrollView(
                    child: Stack(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Container(
                          child: Image(
                            image: FirebaseImage(
                              'gs://meishi-7d80a.appspot.com/Profile/' +
                                  widget.userInfo.data()['portada'],
                              maxSizeBytes: 3500 * 1000,
                            ),
                            fit: BoxFit.cover,
                          ),
                        )),
                    SafeArea(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () async {
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
                      ],
                    )),
                    Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 200),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                children: <Widget>[
                                  Center(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 50),
                                          child: Text(
                                            'Meishi QR',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                  SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      'Comparte tu código QR para que te\nañadan como contacto a Meishi',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: QrImage(
                                      data: widget.userInfo.data()['username'],
                                      version: QrVersions.auto,
                                      size: 300.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )),
              );
            }
          }),
    );
  }

  String _hola = "";
  bool hasData = false;

  _signOut() async {
    await _auth.signOut();
    Navigator.pushNamed(context, '/login_screen');
  }
}
