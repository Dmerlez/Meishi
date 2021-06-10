import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:intl/intl.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meishi_v1/mixins/validation_mixins.dart';
import 'package:url_launcher/url_launcher.dart';

class EnlacesScreen extends StatefulWidget {
  final DocumentSnapshot userInfo;
  static const String routename = "/enlaces_screen";

  const EnlacesScreen({Key key, this.userInfo}) : super(key: key);

  _EnlacesScreenViewState createState() => _EnlacesScreenViewState();
}

class _EnlacesScreenViewState extends State<EnlacesScreen>
    with ValidationMixins {
  String _launchUrl = '';

  Future<void> _launchInApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  var response = 'https://google.com';

  getHtml(url) async {
    var response = await http.get(url);
    var document = responseToDocument(response);
    var data = MetadataParser.parse(document);

    print(data);
  }

  final String _errorImage =
      "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getEnlaces() async {
    var data = await Firestore.instance
        .collection('enlaces')
        .where('uidEnlace', isEqualTo: _auth.currentUser.uid)
        .getDocuments();

    setState(() {
      _recomendationList = data.documents;
    });
  }

  void initState() {
    getEnlaces();
  }

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
                    )),
                  ),
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
                            )),
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
                                          isEqualTo: _auth.currentUser.uid)
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  child: AnyLinkPreview(
                                                      link: document['enlace'],
                                                      displayDirection: UIDirection
                                                          .UIDirectionHorizontal,
                                                      showMultimedia: true,
                                                      bodyMaxLines: 3,
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
                                                        fontSize: 12,
                                                      ),
                                                      errorBody: 'DESCRIPCIÓN',
                                                      errorTitle: 'ENLACE',
                                                      errorWidget: Container(
                                                        height: 0.0,
                                                      ),
                                                      errorImage: _errorImage,
                                                      backgroundColor:
                                                          Colors.white)),

                                              /*
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
                                                                    child:
                                                                        CachedNetworkImage(
                                                                  imageUrl: document[
                                                                          'enlace'] +
                                                                      '/favicon.ico',
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      new Image
                                                                              .asset(
                                                                          'images/CapturaCopy.png'),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
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
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              10),
                                                                  child: Text(
                                                                      'titulo enlace',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
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
                                              )*/
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              ButtonTheme(
                                  minWidth: 300,
                                  height: 50,
                                  child: RaisedButton(
                                    color: Colors.grey,
                                    textColor: Colors.white,
                                    child: Text('Escribe aquí el enlace'),
                                    padding: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    onPressed: () async {
                                      _displayDialog(context);
                                    },
                                  )),
                              Container(height: 50),
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

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Escribe un enlace de interes'),
            content: Form(
                key: _formKey,
                child: TextFormField(
                  validator: validateUrl,
                  controller: _recomendationController,
                  keyboardType: TextInputType.multiline,
                  minLines: 7,
                  maxLines: 15,
                  decoration: InputDecoration(
                      hintText: "Escribir aqui enlace...",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                )),
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
                              'Aceptar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                addRecomendation();
                              } else {}
                            },
                          )),
                    ],
                  )),
            ],
          );
        });
  }

  final _auth = FirebaseAuth.instance;

  Future<void> addRecomendation() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyy-MM-dd');
    final String formatted = formatter.format(now);

    FirebaseFirestore.instance.collection('enlaces').document().setData({
      'uidEnlace': _auth.currentUser.uid,
      'enlace': _recomendationController.text,
      'fecha': formatted,
    });

    bool _validURL = Uri.parse(_launchUrl).isAbsolute;

    Navigator.pop(context);
  }
}
