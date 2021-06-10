import 'dart:io';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EnlacesProfileScreen extends StatefulWidget {
  final DocumentSnapshot userInfo;
  static const String routename = "/enlaces_screen";

  const EnlacesProfileScreen({Key key, this.userInfo}) : super(key: key);

  _EnlacesProfileScreenViewState createState() =>
      _EnlacesProfileScreenViewState();
}

class _EnlacesProfileScreenViewState extends State<EnlacesProfileScreen> {
  getRecomendations() async {
    var data = await Firestore.instance
        .collection('enlaces')
        .where('uidEnlace', isEqualTo: widget.userInfo.data()['uid'])
        .getDocuments();

    setState(() {
      _recomendationList = data.documents;
    });
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

  String _launchUrl = '';

  void initState() {
    getRecomendations();
  }

  final String _errorImage =
      "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg";

  List _recomendationList = [];

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
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
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
                                'Links de Interés',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey),
                              ),
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('enlaces')
                                      .where('uidEnlace',
                                          isEqualTo:
                                              widget.userInfo.data()['uid'])
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        children: snapshot.data.documents
                                            .map((document) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  height: 120,
                                                  child: AnyLinkPreview(
                                                      link: document['enlace'],
                                                      displayDirection: UIDirection
                                                          .UIDirectionHorizontal,
                                                      showMultimedia: true,
                                                      bodyMaxLines: 5,
                                                      bodyTextOverflow:
                                                          TextOverflow.ellipsis,
                                                      titleStyle: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                      bodyStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                      errorBody: 'DESCRIPCIÓN',
                                                      errorTitle: 'ENLACE',
                                                      errorWidget: Container(
                                                        height: 0.0,
                                                      ),
                                                      errorImage: _errorImage,
                                                      backgroundColor:
                                                          Colors.white)),
                                              /*
                                              SizedBox(
                                                height: 15,
                                              ),
                                              RaisedButton(
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                onPressed: () {
                                                  setState(() {
                                                    _launchUrl =
                                                        document['enlace'];
                                                  });
                                                  _launchInApp(_launchUrl);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 0.1,
                                                      color: Colors.black,
                                                    ),
                                                    color: Colors.white,
                                                   ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: SizedBox(
                                                    height: 120,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .topCenter,
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        top:
                                                                            10),
                                                                height: 60,
                                                                width: 60,
                                                                child: ClipOval(
                                                                    child: Image.network(
                                                                        document['enlace'] +
                                                                            '/favicon.ico',
                                                                        fit: BoxFit
                                                                            .contain)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.50,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              10),
                                                                  child: Text(
                                                                      document[
                                                                              'enlace'] +
                                                                          '/title/',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w700)),
                                                                ),
                                                                Text(
                                                                  'Descripción enlace',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Flexible(
                                                            child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                document[
                                                                    'enlace'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                              )),
                                                        )),
                                                        SizedBox(height: 10)
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                /*
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 0.1,
                                                      color: Colors.black,
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  width: MediaQuery.of(context)
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
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      top: 10),
                                                              height: 60,
                                                              width: 60,
                                                              child: ClipOval(
                                                                  child: Image.network(
                                                                      document[
                                                                              'enlace'] +
                                                                          '/favicon.ico',
                                                                      fit: BoxFit
                                                                          .contain)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.50,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                    document[
                                                                            'enlace'] +
                                                                        '/title/',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ),
                                                              Text(
                                                                'Descripción enlace',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Flexible(
                                                          child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Text(
                                                              document[
                                                                  'enlace'],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                            )),
                                                      )),
                                                      SizedBox(height: 10)
                                                    ],
                                                  ),
                                                ),*/
                                              ),*/
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }
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
}
