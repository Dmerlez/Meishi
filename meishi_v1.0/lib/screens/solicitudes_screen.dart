import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SolitudeScreen extends StatefulWidget {
  static const String routename = "/solitude_screen";

  const SolitudeScreen({Key key}) : super(key: key);

  _SolitudeScreenState createState() => _SolitudeScreenState();
}

class _SolitudeScreenState extends State<SolitudeScreen>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TabController _tabController;
  List _solicitudList = [];

  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Container(
        child: Text(
          "SOLICITUDES",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    ),
    Tab(
      child: Container(
        child: Text(
          "ACTUALIZACIONES",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  ];

  int _selectedIndex = 0;

  getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyy-MM-dd');
    final String formatted = formatter.format(now);
    setState(() {
      formateado = formatted;
      print(formateado);
    });
  }

  String formateado = "";

  TextEditingController _uid = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    List _requestList = [];
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    getSolicitude();
    getSearchUsers();
    getChangeNotifications();
    getDate();
  }

  getSearchUsers() async {
    var data = await Firestore.instance.collection('users').getDocuments();

    setState(() {
      _result = data.documents;
      print(_requestList);
    });
  }

  List _result = [];

  TextEditingController _nameController = TextEditingController();

  List _requestList = [];
  List _users = [];

  getSolicitude() async {
    DocumentReference docRef =
        Firestore.instance.collection('users').document(_auth.currentUser.uid);
    DocumentSnapshot doc = await docRef.get();
    List requestedList = doc.data()['requestList'];

    var docRef1 = await Firestore.instance
        .collection('users')
        .where('SenderRequestList', arrayContains: _auth.currentUser.uid)
        .getDocuments();

    if (requestedList != null) {
      setState(() {
        _users = docRef1.documents;
        _requestList = requestedList;

        print(_requestList);
      });
    }
  }

  List _friendList = [];
  List _cargoList = [];

  getChangeNotifications() async {
    var docRef1 = await Firestore.instance
        .collection('nameSolicitud')
        .where('friendList', arrayContains: _auth.currentUser.uid)
        .getDocuments();

    setState(() {
      _friendList = docRef1.documents;
      _friendList.sort((a, b) => b['fechaHora'].compareTo(a['fechaHora']));
      print(_friendList.length);
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: Text('Notificaciones'),
                backgroundColor: Colors.black,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.chevron_left_rounded)),
                bottom: TabBar(
                  labelColor: Colors.lightBlueAccent,
                  unselectedLabelColor: Colors.blueGrey,
                  tabs: myTabs,
                ),
              ),
              body: TabBarView(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      color: const Color(0xffdcdee8),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('users')
                              .where('SenderRequestList',
                                  arrayContains: _auth.currentUser.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.data.documents.length < 1) {
                              return Center(
                                  child: Text('Sin solicitudes pendientes.'));
                            } else {
                              return ListView(
                                  children:
                                      snapshot.data.documents.map((document) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                top: 30,
                                                right: 20,
                                                bottom: 30),
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Nuevo contacto',
                                                  style: TextStyle(
                                                      color: Colors.pink,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  document['name'] +
                                                      ' quiere agregarte como contacto a su agenda',
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ButtonTheme(
                                                        child: RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      color: Colors.green,
                                                      child: Text(
                                                        'Aceptar',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      onPressed: () async {
                                                        DocumentReference
                                                            docRef = Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(_auth
                                                                    .currentUser
                                                                    .uid);

                                                        DocumentSnapshot doc =
                                                            await docRef.get();

                                                        docRef.updateData({
                                                          'requestList':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            document['uid']
                                                          ])
                                                        });

                                                        docRef.updateData({
                                                          'friendList':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            document['uid']
                                                          ])
                                                        });

                                                        DocumentReference
                                                            docRef1 = Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(
                                                                    document[
                                                                        'uid']);

                                                        DocumentSnapshot doc1 =
                                                            await docRef1.get();

                                                        docRef1.updateData({
                                                          'friendList':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            _auth
                                                                .currentUser.uid
                                                          ])
                                                        });

                                                        docRef1.updateData({
                                                          'SenderRequestList':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            _auth
                                                                .currentUser.uid
                                                          ])
                                                        });
                                                      },
                                                    )),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    ButtonTheme(
                                                        child: RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      color: Colors.red,
                                                      child: Text(
                                                        'Rechazar',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      onPressed: () {
                                                        DocumentReference
                                                            docRef = Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(_auth
                                                                    .currentUser
                                                                    .uid);

                                                        DocumentReference
                                                            docRef1 = Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(
                                                                    document[
                                                                        'uid']);

                                                        docRef.updateData({
                                                          'requestList':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            document['uid']
                                                          ])
                                                        });

                                                        docRef1.updateData({
                                                          'SenderRequestList':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            _auth
                                                                .currentUser.uid
                                                          ])
                                                        });
                                                      },
                                                    )),
                                                  ],
                                                )
                                              ],
                                            )))
                                  ],
                                );
                              }).toList());
                            }
                          })),
                  Container(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      color: const Color(0xffdcdee8),
                      child: RefreshIndicator(
                          color: Colors.blue,
                          displacement: 20,
                          onRefresh: () async {
                            var docRef1 = await Firestore.instance
                                .collection('nameSolicitud')
                                .where('friendList',
                                    arrayContains: _auth.currentUser.uid)
                                .getDocuments();

                            setState(() {
                              _friendList = docRef1.documents;
                              _friendList.sort((a, b) =>
                                  b['fechaHora'].compareTo(a['fechaHora']));
                              print(_friendList.length);
                            });
                          },
                          child: ListView.builder(
                              itemCount: _friendList.length > 10
                                  ? 10
                                  : _friendList.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                top: 30,
                                                right: 20,
                                                bottom: 30),
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Nueva actualización',
                                                        style: TextStyle(
                                                            color: Colors.pink,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          _friendList[index]
                                                              ['fecha'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700],
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Contacto: ' +
                                                        _friendList[index]
                                                            ['name'],
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[700],
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  RichText(
                                                      text: TextSpan(
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .grey[700]),
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text: _friendList[
                                                                        index]
                                                                    ['dato'] +
                                                                ': ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text: _friendList[
                                                                index]['data'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' ha cambiado a '),
                                                        TextSpan(
                                                            text: _friendList[
                                                                    index]
                                                                ['newData'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                      ]))
                                                ])),
                                      )
                                    ],
                                  ))))
                ],
              )),
        ));
  }
}
