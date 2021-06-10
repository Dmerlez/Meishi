import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:meishi_v1/screens/recomendation_screen.dart';
import 'package:meishi_v1/widgets/enlaces_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

class UserProfilePage extends StatefulWidget {
  static const String routename = "/principalUser_screen";
  final DocumentSnapshot userInfo;

  const UserProfilePage({Key key, this.userInfo}) : super(key: key);

  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List _recomendationList = [];

  final GlobalKey<TagsState> _tagsKey = GlobalKey<TagsState>();
  List tags = new List();
  TextEditingController _noteController = TextEditingController();
  FocusNode _focusNode;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getRecomendations();
    getNotes();
    getFavorites();
    _focusNode = FocusNode();
    getContactos();
    getEnlaces();
    getTags();
    print(_noteController.text);
  }

  List _getTags = [];
  List _items = [];
  List _items1;

  Future<void> getTags() async {
    var tags = await Firestore.instance
        .collection('tags')
        .where('uidUserTags', isEqualTo: widget.userInfo.data()['uid'])
        .where('uidUserAddTags', isEqualTo: _auth.currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _getTags = snapshot.documents.first['tags'];
      _items = _getTags;

      //print(_items);
    });
  }

  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  bool checkIsFavorite = false;

  Future<void> getFavorites() async {
    DocumentReference docRef =
        Firestore.instance.collection('users').document(_auth.currentUser.uid);
    DocumentSnapshot doc = await docRef.get();
    List friendList = doc.data()['favoriteList'];

    if (friendList.contains(widget.userInfo.data()['uid'])) {
      setState(() {
        checkIsFavorite = true;
        iconStar = Icon(
          (Icons.star),
          size: 25,
          color: Colors.pink,
        );
      });
    } else {
      //print('no es favorito');
    }
  }

  int prueba = 0;

  Future<void> getNotes() async {
    Firestore.instance
        .collection('notes')
        .where('uidUserAddNotes', isEqualTo: _auth.currentUser.uid)
        .where('uidUserNotes', isEqualTo: widget.userInfo.data()['uid'])
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        _noteController.text = snapshot.documents.first['notes'];
      });
    });

    print(_noteController.text);
  }

  int recomendaciones = 0;
  List contactos = [];
  int contacts = 0;
  int enlaces = 0;

  getRecomendations() async {
    var data = await Firestore.instance
        .collection('recomendations')
        .where('uidUserRecomendation',
            isEqualTo: "${widget.userInfo.data()['uid']}")
        .getDocuments();

    setState(() {
      _recomendationList = data.documents;
    });

    for (var recomendation in data.documents) {
      recomendaciones++;
    }
  }

  Future<void> _launched;

  getEnlaces() async {
    var data = await Firestore.instance
        .collection('enlaces')
        .where('uidEnlace', isEqualTo: widget.userInfo.data()['uid'])
        .getDocuments();

    for (var enlace in data.documents) {
      enlaces++;
    }
  }

  getContactos() async {
    DocumentReference docRef = Firestore.instance
        .collection('users')
        .document(widget.userInfo.data()['uid']);
    DocumentSnapshot doc = await docRef.get();
    List friendList = doc.data()['friendList'];

    setState(() {
      contactos = friendList;
      contacts = contactos.length;
      print(contactos.length);
    });
  }

  String url = '';
  Future<void> callNow() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'call not posible';
    }
  }

  String email = '';
  _launchEmail() async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    setState(() {
      seleccionable = true;
    });
  }

  bool seleccionable = false;

  String title = '';

  /*_launchMap() async {
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps);
    if (await MapLauncher.isMapAvailable(MapType.apple)) {
      await MapLauncher.showMarker(
        mapType: MapType.apple,
        coords: Coords(37.759392, -122.5107336),
        title: title,
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text('Loading...'));
      } else {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            body: Stack(
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Image(
                            image: FirebaseImage(
                              'gs://meishi-7d80a.appspot.com/Profile/' +
                                  widget.userInfo['portada'],
                              maxSizeBytes: 3500 * 1000,
                            ),
                            fit: BoxFit.fitWidth))),
                SafeArea(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      fillColor: Colors.grey.withOpacity(0.8),
                      child: Icon(Icons.chevron_left_rounded,
                          size: 25, color: Colors.white),
                      padding: EdgeInsets.all(10),
                      shape: CircleBorder(),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Row(
                          children: <Widget>[
                            RawMaterialButton(
                              constraints: BoxConstraints.tight(Size(45, 45)),
                              onPressed: () {
                                isFavorite();
                              },
                              fillColor: Colors.grey.withOpacity(0.8),
                              child: iconStar,
                              shape: CircleBorder(),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            RawMaterialButton(
                              constraints: BoxConstraints.tight(Size(45, 45)),
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
                                      'Desea confirmar los cambios',
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
                                                    fontWeight: FontWeight.w700,
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
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17)),
                                            onPressed: () async {
                                              saveNotes();
                                              //deleteTags();
                                              addTags();

                                              Navigator.pop(context);
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
                              child: Icon(
                                Icons.save,
                                size: 25,
                                color: Colors.white,
                              ),
                              shape: CircleBorder(),
                            ),
                          ],
                        ))
                  ],
                )),
                Column(children: [
                  Center(
                      child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.239),
                    child: Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 130,
                              width: 130,
                              child: ClipOval(
                                child: Image(
                                    image: FirebaseImage(
                                      'gs://meishi-7d80a.appspot.com/Profile/' +
                                          widget.userInfo.data()['foto'],
                                      maxSizeBytes: 3500 * 1000,
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 35),
                                  child: Text(widget.userInfo.data()['name'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Roboto',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(height: 10),
                                Text(widget.userInfo.data()['cargo'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          url = 'tel:' +
                                              widget.userInfo
                                                  .data()['telefono'];
                                        });
                                        callNow();
                                      },
                                      child: Icon(Icons.phone,
                                          color: Colors.black, size: 20),
                                    ),
                                    SizedBox(width: 15),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          email = widget.userInfo
                                              .data()['emailCorporativo'];
                                        });
                                        _launchEmail();
                                      },
                                      child: Icon(Icons.email,
                                          color: Colors.black, size: 20),
                                    ),
                                    SizedBox(width: 15),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          title = widget.userInfo
                                              .data()['direccion'];
                                        });
                                        MapsLauncher.launchQuery(title);
                                      },
                                      child: Icon(Icons.add_location,
                                          color: Colors.black, size: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 60),
                              ],
                            )),
                          ],
                        )),
                  )),
                  Flexible(
                      child: DraggableScrollableSheet(
                          minChildSize: 0.1,
                          initialChildSize: 1,
                          builder: (context, scrollController) {
                            return NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  if (scrollNotification
                                      is ScrollUpdateNotification) {
                                    _onUpdateScroll(scrollNotification.metrics);
                                  }
                                },
                                child: SingleChildScrollView(
                                    child: Container(
                                        child: Center(
                                            child: Container(
                                                child: Column(
                                  children: <Widget>[
                                    Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: Column(
                                          children: [
                                            Text(
                                              "Contactos",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '$contacts',
                                              style: TextStyle(
                                                color: Colors.lightBlueAccent,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 25,
                                              ),
                                            )
                                          ],
                                        )),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1),
                                        Container(
                                            child: Column(
                                          children: <Widget>[
                                            InkWell(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Recomendaciones",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    '$recomendaciones',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                DocumentSnapshot result =
                                                    widget.userInfo;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RecomendationView(
                                                                userInfo:
                                                                    result)));
                                              },
                                            ),
                                          ],
                                        )),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1),
                                        Container(
                                            child: Column(
                                          children: <Widget>[
                                            InkWell(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Enlaces",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    '$enlaces',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                DocumentSnapshot result =
                                                    widget.userInfo;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EnlacesProfileScreen(
                                                                userInfo:
                                                                    result)));
                                              },
                                            ),
                                          ],
                                        ))
                                      ],
                                    )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text("NOMBRE DE USUARIO",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            SizedBox(width: 10),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      widget.userInfo
                                                          .data()['username'],
                                                      style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 14,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text("EMAIL",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            SizedBox(width: 10),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      widget.userInfo.data()[
                                                          'emailCorporativo'],
                                                      style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 14,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text("TELÉFONO",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            SizedBox(width: 10),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      widget.userInfo
                                                          .data()['telefono'],
                                                      style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 14,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text("SITIO WEB",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            SizedBox(width: 10),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      widget.userInfo
                                                          .data()['webEmpresa'],
                                                      style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 14,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text("PAÍS",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            SizedBox(width: 10),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      widget.userInfo
                                                          .data()['pais'],
                                                      style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 14,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text("EMPRESA",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            SizedBox(width: 10),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      widget.userInfo
                                                          .data()['empresa'],
                                                      style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 14,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text("DIRECCIÓN",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            SizedBox(width: 10),
                                            Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    child: Text(
                                                      widget.userInfo
                                                          .data()['direccion'],
                                                      style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 14,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Container(
                                            margin: EdgeInsets.only(
                                                right: 30, left: 30),
                                            child: Divider(
                                              color: Colors.grey,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                                height: 50,
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'NOTAS',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 30, right: 30),
                                                child: TextField(
                                                  enabled: seleccionable
                                                      ? true
                                                      : false,
                                                  controller: _noteController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Escribe una nota aquí',
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                      border: InputBorder.none),
                                                )),
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                    height: 50,
                                                    margin: EdgeInsets.only(
                                                        left: 30),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'ETIQUETAS',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.blueGrey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                _tags1,
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                    child: Container(
                                                  child: Tags(
                                                    key: _tagsKey,
                                                    itemCount: tags.length,
                                                    columns: 6,
                                                    textField: TagsTextField(
                                                      autofocus: false,
                                                      hintText:
                                                          'Agregar etiqueta',
                                                      textStyle: TextStyle(
                                                          fontSize: 14),
                                                      onSubmitted: (string) {
                                                        setState(() {
                                                          tags.add(Item(
                                                              title: string));
                                                        });
                                                      },
                                                    ),
                                                    itemBuilder: (index) {
                                                      final Item currentItem =
                                                          tags[index];
                                                      return ItemTags(
                                                        index: index,
                                                        title:
                                                            currentItem.title,
                                                        customData: currentItem
                                                            .customData,
                                                        textStyle: TextStyle(
                                                            fontSize: 14),
                                                        combine: ItemTagsCombine
                                                            .withTextBefore,
                                                        onPressed: (i) =>
                                                            print(i),
                                                        onLongPressed: (i) =>
                                                            print(i),
                                                        removeButton:
                                                            ItemTagsRemoveButton(
                                                                onRemoved: () {
                                                          setState(() {
                                                            tags.removeAt(
                                                                index);
                                                          });
                                                          return true;
                                                        }),
                                                      );
                                                    },
                                                  ),
                                                )),
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                Container(
                                                  child: InkWell(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        FaIcon(
                                                            EvaIcons
                                                                .trash2Outline,
                                                            color: Colors.pink,
                                                            size: 25),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Eliminar contacto',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.pink),
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          titlePadding:
                                                              EdgeInsets.only(
                                                                  top: 60),
                                                          title: Text(
                                                              'Eliminar contacto',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          content: Text(
                                                            'Esta seguro que desea eliminar el contacto',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          actions: <Widget>[
                                                            Row(
                                                                children: <
                                                                    Widget>[
                                                                  ButtonTheme(
                                                                    height: 50,
                                                                    minWidth:
                                                                        120,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child:
                                                                        RaisedButton(
                                                                      color: const Color(
                                                                          0xff788d9b),
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      child: Text(
                                                                          'Cancelar',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 17)),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  ButtonTheme(
                                                                    minWidth:
                                                                        120,
                                                                    height: 50,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child:
                                                                        RaisedButton(
                                                                      color: Colors
                                                                          .pink,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      child: Text(
                                                                          'Eliminar',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 17)),
                                                                      onPressed:
                                                                          () async {
                                                                        DocumentReference docRef = Firestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .document(_auth.currentUser.uid);

                                                                        DocumentReference docRef1 = Firestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .document(widget.userInfo.data()['uid']);

                                                                        docRef1
                                                                            .updateData({
                                                                          'friendList':
                                                                              FieldValue.arrayRemove([
                                                                            _auth.currentUser.uid
                                                                          ])
                                                                        });

                                                                        docRef
                                                                            .updateData({
                                                                          'friendList':
                                                                              FieldValue.arrayRemove([
                                                                            widget.userInfo.data()['uid']
                                                                          ])
                                                                        });

                                                                        docRef
                                                                            .updateData({
                                                                          'favoriteList':
                                                                              FieldValue.arrayRemove([
                                                                            widget.userInfo.data()['uid']
                                                                          ])
                                                                        });

                                                                        docRef
                                                                            .updateData({
                                                                          'IsfavoriteList':
                                                                              FieldValue.arrayRemove([
                                                                            widget.userInfo.data()['uid']
                                                                          ])
                                                                        });

                                                                        docRef1
                                                                            .updateData({
                                                                          'IsfavoriteList':
                                                                              FieldValue.arrayRemove([
                                                                            _auth.currentUser.uid
                                                                          ])
                                                                        });

                                                                        docRef1
                                                                            .updateData({
                                                                          'favoriteList':
                                                                              FieldValue.arrayRemove([
                                                                            _auth.currentUser.uid
                                                                          ])
                                                                        });

                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'notes')
                                                                            .where('uidUserNotes',
                                                                                isEqualTo: widget.userInfo.data()['uid'])
                                                                            .where('uidUserAddNotes', isEqualTo: _auth.currentUser.uid)
                                                                            .getDocuments()
                                                                            .then((snapshot) => {
                                                                                  snapshot.docs.first.reference.delete(),
                                                                                });

                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'tags')
                                                                            .where('uidUserTags',
                                                                                isEqualTo: widget.userInfo.data()['uid'])
                                                                            .where('uidUserAddTags', isEqualTo: _auth.currentUser.uid)
                                                                            .getDocuments()
                                                                            .then((snapshot) => {
                                                                                  snapshot.docs.first.reference.delete(),
                                                                                });

                                                                        setState(
                                                                            () {
                                                                          iconStar =
                                                                              Icon(
                                                                            (Icons.star_border),
                                                                            size:
                                                                                25,
                                                                            color:
                                                                                Colors.pink,
                                                                          );
                                                                        });

                                                                        Navigator.pushNamed(
                                                                            context,
                                                                            '/principal_screen');
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                ]),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 80,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ))))));
                          }))
                ])
              ],
            ));
      }
    });
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  Widget get _tags1 {
    return Tags(
      key: _tagStateKey,
      symmetry: false,
      columns: 6,
      itemCount: (_items == null) ? 0 : _items.length,
      itemBuilder: (index) {
        final item = _items[index];
        return ItemTags(
          textColor: Colors.white,
          color: Colors.blueGrey,
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: true,
          activeColor: Colors.blueGrey,
          singleItem: true,
          splashColor: Colors.green,
          combine: ItemTagsCombine.withTextBefore,
          onPressed: (i) => print(i),
          onLongPressed: (i) => print(i),
          removeButton: ItemTagsRemoveButton(onRemoved: () {
            setState(() {
              _items.removeAt(index);
            });
            return true;
          }),
        );
      },
    );
  }

  Future<void> saveNotes() async {
    if (_noteController.text.length == 0) {
      FirebaseFirestore.instance
          .collection('notes')
          .where('uidUserNotes', isEqualTo: widget.userInfo.data()['uid'])
          .where('uidUserAddNotes', isEqualTo: _auth.currentUser.uid)
          .getDocuments()
          .then((snapshot) => {
                snapshot.docs.last.reference.delete(),
              });
      print('no hay notas');
    } else {
      FirebaseFirestore.instance
          .collection('notes')
          .where('uidUserNotes', isEqualTo: widget.userInfo.data()['uid'])
          .where('uidUserAddNotes', isEqualTo: _auth.currentUser.uid)
          .getDocuments()
          .then((snapshot) => {
                if (snapshot.docs.length < 1)
                  {
                    FirebaseFirestore.instance
                        .collection('notes')
                        .document()
                        .setData({
                      'uidUserNotes': widget.userInfo.data()['uid'],
                      'uidUserAddNotes': _auth.currentUser.uid,
                      'notes': _noteController.text,
                      'createdAt': DateTime.now(),
                    })
                  }
                else
                  {
                    snapshot.docs.last.reference.delete(),
                    FirebaseFirestore.instance
                        .collection('notes')
                        .document()
                        .setData({
                      'uidUserNotes': widget.userInfo.data()['uid'],
                      'uidUserAddNotes': _auth.currentUser.uid,
                      'notes': _noteController.text,
                      'createdAt': DateTime.now(),
                    })
                  }
              });
    }
  }

  Future<void> addTags() async {
    FirebaseFirestore.instance
        .collection('tags')
        .where('uidUserTags', isEqualTo: widget.userInfo.data()['uid'])
        .where('uidUserAddTags', isEqualTo: _auth.currentUser.uid)
        .getDocuments()
        .then((snapshot) => {
              if (snapshot.docs.length < 1)
                {
                  FirebaseFirestore.instance
                      .collection('tags')
                      .document()
                      .setData({
                    'uidUserTags': widget.userInfo.data()['uid'],
                    'uidUserAddTags': _auth.currentUser.uid,
                    'tags': _items,
                    'createdAt': Timestamp.now(),
                  })
                }
              else
                {
                  snapshot.docs.last.reference.delete(),
                  FirebaseFirestore.instance
                      .collection('tags')
                      .document()
                      .setData({
                    'uidUserTags': widget.userInfo.data()['uid'],
                    'uidUserAddTags': _auth.currentUser.uid,
                    'tags': _items,
                    'createdAt': Timestamp.now(),
                  })
                }
            });

    if (_items.length < 1) {
      FirebaseFirestore.instance
          .collection('tags')
          .where('uidUserTags', isEqualTo: widget.userInfo.data()['uid'])
          .where('uidUserAddTags', isEqualTo: _auth.currentUser.uid)
          .getDocuments()
          .then((snapshot) => {
                snapshot.docs.last.reference.delete(),
              });
    }

    print(_items.length);

    List _allTags = [];

    for (var tag in tags) {
      _allTags.add(tag.title);
    }

    if (_items == null) {
      _items = _allTags;
    } else {
      _items = List.from(_allTags)..addAll(_items);
    }
  }

  isFavorite() async {
    DocumentReference docRef =
        Firestore.instance.collection('users').document(_auth.currentUser.uid);
    DocumentSnapshot doc = await docRef.get();
    List friendList = doc.data()['favoriteList'];

    DocumentReference docRef1 = Firestore.instance
        .collection('users')
        .document(widget.userInfo.data()['uid']);
    DocumentSnapshot doc1 = await docRef.get();
    List friendList1 = doc.data()['favoriteList'];

    if (friendList == null ||
        !friendList.contains(widget.userInfo.data()['uid'])) {
      docRef.updateData({
        'favoriteList': FieldValue.arrayUnion([widget.userInfo.data()['uid']])
      });

      docRef1.updateData({
        'IsfavoriteList': FieldValue.arrayUnion([_auth.currentUser.uid])
      });

      setState(() {
        iconStar = Icon(
          (Icons.star),
          size: 25,
          color: Colors.pink,
        );
      });
    } else {
      docRef.updateData({
        'favoriteList': FieldValue.arrayRemove([widget.userInfo.data()['uid']])
      });
      docRef1.updateData({
        'IsfavoriteList': FieldValue.arrayRemove([_auth.currentUser.uid])
      });
      setState(() {
        iconStar = Icon(
          (Icons.star_border),
          size: 25,
          color: Colors.pink,
        );
      });
    }
  }

  Icon iconStar = Icon(
    (Icons.star_border),
    size: 25,
    color: Colors.pink,
  );
}
