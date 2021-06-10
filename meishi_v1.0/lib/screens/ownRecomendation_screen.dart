import 'package:firebase_image/firebase_image.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OwnRecomendationView extends StatefulWidget {
  final DocumentSnapshot userInfo;
  static const String routename = "/recomendation_screen";

  const OwnRecomendationView({Key key, this.userInfo}) : super(key: key);

  _RecomendationViewState createState() => _RecomendationViewState();
}

class _RecomendationViewState extends State<OwnRecomendationView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cargoController = TextEditingController();
  TextEditingController _portadaController = TextEditingController();
  List _recomendationList = [];
  List _addRecomendationList = [];

  getRecomendations() async {
    var data = await Firestore.instance
        .collection('recomendations')
        .where('uidUserRecomendation',
            isEqualTo: "${widget.userInfo.data()['uid']}")
        .getDocuments();

    setState(() {
      _recomendationList = data.documents;
      _recomendationList.sort((a, b) => b['fecha'].compareTo(a['fecha']));
    });

    var data1 = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: data.documents.first['uid']);
  }

  String iduser = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecomendations();
    Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: "${_auth.currentUser.uid}")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _nameController.text = snapshot.documents.first['name'];
      _imageController.text = snapshot.documents.first['foto'];
      _cargoController.text = snapshot.documents.first['cargo'];
      _portadaController.text = snapshot.documents.first['portada'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text('Loading...'));
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                    child: RawMaterialButton(
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
                  ),
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
                          margin: EdgeInsets.only(top: 120),
                          child: SizedBox(
                            height: 130,
                            width: 130,
                            child: ClipOval(
                                child: Image(
                                    image: FirebaseImage(
                                      'gs://meishi-7d80a.appspot.com/Profile/' +
                                          widget.userInfo.data()['foto'],
                                      maxSizeBytes: 3500 * 1000,
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 270),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(widget.userInfo.data()['name'],
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Recomendaciones',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey),
                              ),
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('recomendations')
                                      .where('uidUserRecomendation',
                                          isEqualTo:
                                              "${widget.userInfo.data()['uid']}")
                                      .orderBy('fecha', descending: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: _recomendationList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 0.5)),
                                                        color: Colors.white,
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Align(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .topCenter,
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        top:
                                                                            10),
                                                                    height: 60,
                                                                    width: 60,
                                                                    child: ClipOval(
                                                                        child: Image(
                                                                            image: FirebaseImage(
                                                                              'gs://meishi-7d80a.appspot.com/Profile/' + _recomendationList[index]['foto'],
                                                                              maxSizeBytes: 3500 * 1000,
                                                                            ),
                                                                            fit: BoxFit.cover)),
                                                                  )),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              SizedBox(
                                                                  height: 100,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Flexible(
                                                                          child:
                                                                              Container(
                                                                        margin:
                                                                            EdgeInsets.only(
                                                                          top:
                                                                              30,
                                                                        ),
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.5,
                                                                        child: Text(
                                                                            _recomendationList[index][
                                                                                'nameUserRecomendation'],
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                                                      )),
                                                                      Flexible(
                                                                          child: Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                _recomendationList[index]['cargo'],
                                                                                style: TextStyle(fontSize: 16),
                                                                              )))
                                                                    ],
                                                                  ))
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.75,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  _recomendationList[
                                                                          index]
                                                                      [
                                                                      'recomendation'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                )),
                                                          ),
                                                          SizedBox(height: 10)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              )),
        );
      }
    });
  }

  TextEditingController _recomendationController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  Future<void> addRecomendation() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyy-MM-dd');
    final String formatted = formatter.format(now);

    FirebaseFirestore.instance.collection('recomendations').document().setData({
      'uidUserRecomendation': widget.userInfo.data()['uid'],
      'uidUserAddRecomendation': _auth.currentUser.uid,
      'recomendation': _recomendationController.text,
      'nameUserRecomendation': widget.userInfo.data()['name'],
      'cargoUserRecomendation': widget.userInfo.data()['cargo'],
      'foto': widget.userInfo.data()['foto'],
      'fecha': formatted,
    });

    Navigator.pop(context);
  }
}
