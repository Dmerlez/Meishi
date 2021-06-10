import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meishi_v1/screens/badge_icons_screen.dart';
import 'package:meishi_v1/screens/upercase_screen.dart';
import 'package:meishi_v1/widgets/UserProfilePage.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:meishi_v1/screens/badge_icons_screen.dart';
import 'package:meishi_v1/widgets/UserProfilePage.dart';
import 'package:shimmer/shimmer.dart';

class PrincipalView extends StatefulWidget {
  static const String routename = "/principalView_screen";

  const PrincipalView({Key key}) : super(key: key);

  _PrincipalViewState createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();

  Future resultLoaded;

  List _allResults = [];

  List _favoriteList = [];
  FocusNode _focus = new FocusNode();

  int _selectedIndex = 0;
  bool searchState = false;

  Future getUsers() async {
    QuerySnapshot qn =
        await Firestore.instance.collection('users').getDocuments();

    return qn.documents;
  }

  Stream<QuerySnapshot> getFavoriteStream() {
    return Firestore.instance
        .collection('users')
        .where('IsfavoriteList', arrayContains: _auth.currentUser.uid)
        .snapshots();
  }

  getFavoriteUsers() async {
    var data = await Firestore.instance
        .collection('users')
        .where('IsfavoriteList', arrayContains: _auth.currentUser.uid)
        .getDocuments();

    setState(() {
      _favoriteList = data.documents;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = getSearchUsers();
  }

  getSearchUsers() async {
    var data = await Firestore.instance
        .collection('users')
        .where('friendList', arrayContains: _auth.currentUser.uid)
        .getDocuments();

    setState(() {
      _allResults = data.documents;
    });

    return "complete";
  }

  Stream<QuerySnapshot> getUsersStream() {
    var data = Firestore.instance
        .collection('users')
        .where('friendList', arrayContains: _auth.currentUser.uid)
        .snapshots();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Text(
        "TODOS",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    ),
    Tab(
      child: Text(
        "FAVORITOS",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    ),
    Tab(
      child: Text(
        "ETIQUETAS",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    ),
  ];

  TabController _tabController;

  Icon iconSearch = Icon(
    (Icons.search),
    size: 25,
    color: Colors.white,
  );

  Widget cusSearchBar = Text('Buscar contactos',
      style: TextStyle(color: Colors.white, fontSize: 18));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFriendsSort();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    getSearchUsers();
    getSolicitude();
    searchController.addListener(_onSearchChanged);
    getFavoriteUsers();
    _focus.addListener(_onFocusChange);
    getFavoriteSort();
    getDocs();
    time();
  }

  List friendList = [];
  List users1 = [];

  Stream<QuerySnapshot> data;

  void _onFocusChange() {
    debugPrint('Focus' + _focus.hasFocus.toString());
  }

  void dispose() {
    super.dispose();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _focus.dispose();
  }

  getSolicitude() async {
    DocumentReference docRef =
        Firestore.instance.collection('users').document(_auth.currentUser.uid);
    DocumentSnapshot doc = await docRef.get();
    List requestedList = doc.data()['requestList'];

    solicitud = requestedList.length;
  }

  int solicitud = 0;

  _onSearchChanged() {}

  bool userPage = false;

  int _dataLength = 0;

  Widget tab1() {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: const Color(0xffdcdee8),
        child: RefreshIndicator(
            color: Colors.blue,
            displacement: 20,
            onRefresh: () async {
              QuerySnapshot querySnapshot = await Firestore.instance
                  .collection('users')
                  .where('friendList', arrayContains: _auth.currentUser.uid)
                  .getDocuments();
              setState(() {
                getFriends = querySnapshot.docs;
                getFriends.sort((a, b) {
                  return a['name'].toString().compareTo(b['name'].toString());
                });
              });
              setState(() {
                dropdownValue2 = 'Nombre';
              });
            },
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(right: 30),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: DropdownButton<String>(
                          elevation: 0,
                          value: dropdownValue2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                          iconSize: 25,
                          underline: Container(height: 0),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue2 = newValue;
                            });
                            if (newValue == 'Nombre') {
                              getFriends.sort((a, b) {
                                return a['name']
                                    .toString()
                                    .compareTo(b['name'].toString());
                              });
                            } else if (newValue == 'Cargo') {
                              getFriends.sort((a, b) {
                                return a['cargo']
                                    .toString()
                                    .compareTo(b['cargo'].toString());
                              });
                            }
                          },
                          items: <String>['Nombre', 'Cargo']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                    )),
                Flexible(
                    child: isLoading
                        ? Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: Colors.white,
                            /*const Color(0xff00c8f0),*/
                            highlightColor: Colors.grey[400],
                            /*const Color(0xffff3377),*/
                            child: ListView.builder(
                                itemCount: getFriends.length,
                                itemBuilder: (context, index) {
                                  return Column(children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      height: 140,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                    )
                                  ]);
                                }))
                        : ListView.builder(
                            itemCount: getFriends.length,
                            itemBuilder: (context, index) {
                              if (searchController.text == '' ||
                                  getFriends[index]['name']
                                      .contains(searchController.text) ||
                                  getFriends[index]['cargo']
                                      .contains(searchController.text) ||
                                  getFriends[index]['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  getFriends[index]['cargo']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  getFriends[index]['name']
                                      .toString()
                                      .toUpperCase()
                                      .contains(searchController.text) ||
                                  getFriends[index]['cargo']
                                      .toString()
                                      .toUpperCase()
                                      .contains(searchController.text)) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 10.0),
                                    Container(
                                      height: 140.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.90,
                                      child: RaisedButton(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          color: Colors.white,
                                          onPressed: () async {
                                            DocumentSnapshot result =
                                                await Firestore.instance
                                                    .collection('users')
                                                    .document(getFriends[index]
                                                        ['uid'])
                                                    .get();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfilePage(
                                                            userInfo: result)));
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: FirebaseImage(
                                                              'gs://meishi-7d80a.appspot.com/Profile/' +
                                                                  getFriends[index]
                                                                      ['foto'],
                                                              maxSizeBytes:
                                                                  3500 * 1000,
                                                              cacheRefreshStrategy:
                                                                  CacheRefreshStrategy
                                                                      .NEVER),
                                                          fit: BoxFit.cover),
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(15),
                                                          bottomLeft: Radius.circular(15)))),
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: Text(
                                                              getFriends[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Flexible(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: Text(
                                                              getFriends[index]
                                                                  ['cargo'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          )),
                                    ),
                                  ],
                                );
                              } else {
                                return (Container(
                                  height: 0,
                                ));
                              }
                            }))
              ],
            )));
  }

  Widget tab2() {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: const Color(0xffdcdee8),
        child: RefreshIndicator(
          color: Colors.blue,
          displacement: 20,
          onRefresh: () async {
            QuerySnapshot querySnapshot = await Firestore.instance
                .collection('users')
                .where('IsfavoriteList', arrayContains: _auth.currentUser.uid)
                .getDocuments();

            setState(() {
              getFavorite = querySnapshot.docs;
              getFavorite.sort((a, b) {
                return a['name'].toString().compareTo(b['name'].toString());
              });
              setState(() {
                dropdownValue = 'Nombre';
              });
            });
          },
          child: getFavorite.length == 0
              ? ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.1),
                            child: Center(
                                child: Text(
                              'Agrega tus contactos favoritos.',
                              style: TextStyle(fontSize: 18),
                            )))
                      ],
                    );
                  })
              : Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: DropdownButton<String>(
                              value: dropdownValue,
                              underline: Container(height: 0),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                                if (newValue == 'Nombre') {
                                  getFavorite.sort((a, b) {
                                    return a['name']
                                        .toString()
                                        .compareTo(b['name'].toString());
                                  });
                                } else if (newValue == 'Cargo') {
                                  getFavorite.sort((a, b) {
                                    return a['cargo']
                                        .toString()
                                        .compareTo(b['cargo'].toString());
                                  });
                                }
                              },
                              items: <String>[
                                'Nombre',
                                'Cargo'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()),
                        )),
                    Flexible(
                        child: ListView.builder(
                            itemCount: getFavorite.length,
                            itemBuilder: (context, index) {
                              if (searchController.text == '' ||
                                  getFavorite[index]['name']
                                      .contains(searchController.text) ||
                                  getFavorite[index]['cargo']
                                      .contains(searchController.text) ||
                                  getFavorite[index]['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  getFavorite[index]['cargo']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  getFavorite[index]['name']
                                      .toString()
                                      .toUpperCase()
                                      .contains(searchController.text) ||
                                  getFavorite[index]['cargo']
                                      .toString()
                                      .toUpperCase()
                                      .contains(searchController.text)) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 10.0),
                                    Container(
                                      height: 140.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.90,
                                      child: RaisedButton(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          color: Colors.white,
                                          onPressed: () async {
                                            DocumentSnapshot result =
                                                await Firestore.instance
                                                    .collection('users')
                                                    .document(getFavorite[index]
                                                        ['uid'])
                                                    .get();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfilePage(
                                                            userInfo: result)));
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: FirebaseImage(
                                                            'gs://meishi-7d80a.appspot.com/Profile/' +
                                                                getFavorite[
                                                                        index]
                                                                    ['foto'],
                                                            maxSizeBytes:
                                                                3500 * 1000,
                                                          ),
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      15)))),
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: Text(
                                                              getFavorite[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Flexible(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: Text(
                                                              getFavorite[index]
                                                                  ['cargo'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          )),
                                    ),
                                  ],
                                );
                              } else {
                                return (Container(
                                  height: 0,
                                ));
                              }
                            }))
                  ],
                ),
        ));
  }

  Widget tab3() {
    return userPage
        ? Column(children: <Widget>[
            userPageScreen(),
            Expanded(child: containerUser())
          ])
        : Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            color: const Color(0xffdcdee8),
            child: RefreshIndicator(
              color: Colors.blue,
              displacement: 20,
              onRefresh: () async {
                QuerySnapshot querySnapshot = await Firestore.instance
                    .collection('tags')
                    .where('uidUserAddTags', isEqualTo: _auth.currentUser.uid)
                    .getDocuments();

                for (int i = 0; i < querySnapshot.documents.length; i++) {
                  var e = querySnapshot.docs[i];

                  test.add(e['tags']);
                }

                var x = test.map((e) => e.join(",")).join(",");

                if (x == '') {
                  x1.clear();
                } else {
                  setState(() {
                    x1 = x.split(',').toSet().toList();
                    x1.sort();
                  });
                }
                setState(() {
                  dropdownValue1 = 'A-Z';
                });
              },
              child: x1.length == 0
                  ? ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Center(
                                    child: Text(
                                  'Agrega etiqueta a tus contactos.',
                                  style: TextStyle(fontSize: 18),
                                )))
                          ],
                        );
                      })
                  : Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(right: 30),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: DropdownButton<String>(
                                  value: dropdownValue1,
                                  underline: Container(height: 0),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 25,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue1 = newValue;
                                    });
                                    if (newValue == 'A-Z') {
                                      x1.sort();
                                    } else if (newValue == 'Z-A') {
                                      x1.sort((a, b) => b.compareTo(a));
                                    }
                                  },
                                  items: <String>['A-Z', 'Z-A']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()),
                            )),
                        Flexible(
                            child: ListView.builder(
                                itemCount: x1.length,
                                itemBuilder: (context, index) {
                                  if (x1.length < 1) {
                                    return Center(
                                      child: Text(
                                          'Añade etiquetas a tus contactos'),
                                    );
                                  } else if (x1.length >= 1 &&
                                          searchController.text == '' ||
                                      x1[index]
                                          .toString()
                                          .contains(searchController.text) ||
                                      x1[index]
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchController.text) ||
                                      x1[index]
                                          .toString()
                                          .toUpperCase()
                                          .contains(searchController.text)) {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                x1[index].toString().length > 0
                                                    ? EdgeInsets.only(
                                                        top: 10,
                                                        left: 20,
                                                        right: 20,
                                                      )
                                                    : EdgeInsets.only(top: 0.0),
                                            height:
                                                x1[index].toString().length > 0
                                                    ? 60
                                                    : 0,
                                            child: RaisedButton(
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                color: Colors.white,
                                                onPressed: () {
                                                  setState(() {
                                                    dropdownValue1 = 'A-Z';
                                                    x1.sort();
                                                  });
                                                  setState(() {
                                                    searchController.text = "";
                                                  });
                                                  setState(() {
                                                    userUidTag =
                                                        x1[index].toString();
                                                    userPage = true;
                                                    time1();
                                                  });

                                                  getAllList();
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                        color: Colors.primaries[
                                                            Random().nextInt(
                                                                Colors.primaries
                                                                    .length)],
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    SizedBox(width: 15),
                                                    Text(
                                                      x1[index].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15),
                                                        child: x1[index]
                                                                    .toString()
                                                                    .length >
                                                                0
                                                            ? Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: Colors
                                                                    .black,
                                                              )
                                                            : Text('')),
                                                  ],
                                                )),
                                          ),
                                        ]);
                                  } else {
                                    return Container();
                                  }
                                }))
                      ],
                    ),
            ));
  }

  Widget search() {
    return Container(
        margin: EdgeInsets.only(right: 15, top: 10),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
            color: const Color(0xff485464),
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          style: TextStyle(color: Colors.white),
          focusNode: _focus,
          onChanged: (String value) {
            setState(() {
              searchController.text = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar en mi agenda',
            hintStyle: TextStyle(color: Colors.white, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () async {
                      //_signOut();
                      Navigator.pushNamed(context, '/solitude_screen');
                    },
                    icon: BadgeIcon(
                      badgeCount: solicitud,
                      icon: Icon(Icons.notifications),
                      badgeColor: Colors.red,
                      badgeTextStyle: TextStyle(color: Colors.white),
                      showIfZero: false,
                    ),
                  ),
                  actions: <Widget>[search()],
                  backgroundColor: const Color(0xff01040f),
                  titleSpacing: 0.0,
                  bottom: TabBar(
                    labelColor: Colors.lightBlueAccent,
                    unselectedLabelColor: Colors.blueGrey,
                    tabs: myTabs,
                  ),
                ),
                body: TabBarView(
                  children: [
                    tab1(),
                    tab2(),
                    tab3(),
                  ],
                ))));
  }

  String dropdownValue = 'Nombre';
  String dropdownValue1 = 'A-Z';
  String dropdownValue2 = 'Nombre';
  String dropdownValue3 = 'Nombre';

  _signOut() async {
    await _auth.signOut();
    Navigator.pushNamed(context, '/login_screen');
  }

  String userUidTag = "";

  String tagPruebas = '';

  List string = [];

  bool isLoading = true;

  Widget time() {
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        //print(isLoading);
      });
    });
  }

  Widget time1() {
    Timer timer = Timer(Duration(seconds: 1), () {
      setState(() {
        isLoadingUsers = false;
        //print(isLoading);
      });
    });
  }

  Future getFavoriteSort() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .where('IsfavoriteList', arrayContains: _auth.currentUser.uid)
        .getDocuments();

    setState(() {
      getFavorite = querySnapshot.docs;
      getFavorite.sort((a, b) {
        return a['name'].toString().compareTo(b['name'].toString());
      });
    });
  }

  List getFavorite = [];

  Future getFriendsSort() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .where('friendList', arrayContains: _auth.currentUser.uid)
        .getDocuments();

    setState(() {
      getFriends = querySnapshot.docs;
      getFriends.sort((a, b) {
        return a['name'].toString().compareTo(b['name'].toString());
      });
    });
  }

  List getFriends = [];

  String testing = "";

  Future getDocs() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('tags')
        .where('uidUserAddTags', isEqualTo: _auth.currentUser.uid)
        .getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var e = querySnapshot.docs[i];

      test.add(e['tags']);
    }

    var x = test.map((e) => e.join(",")).join(",");

    if (x == '') {
      x1.clear();
    } else {
      x1 = x.split(',').toSet().toList();

      x1.sort();
    }
  }

  List x1 = [];

  List test = [];

  Widget userPageScreen() {
    return Container(
        color: const Color(0xffdcdee8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                setState(() {
                                  userUidTag = "";
                                  userPage = false;
                                  tagUser2 = [];
                                  dropdownValue3 = 'Nombre';
                                  tagUser3 = [];
                                  isLoadingUsers = true;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.chevron_left_rounded,
                                        size: 30,
                                      ),
                                      SizedBox(width: 7),
                                      Container(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            userUidTag.capitalize(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.only(right: 30),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: DropdownButton<String>(
                                    underline: Container(height: 0),
                                    value: dropdownValue3,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 25,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue3 = newValue;
                                      });
                                      if (newValue == 'Nombre') {
                                        tagUser3.sort((a, b) {
                                          return a['name']
                                              .toString()
                                              .compareTo(b['name'].toString());
                                        });
                                      } else if (newValue == 'Cargo') {
                                        tagUser3.sort((a, b) {
                                          return a['cargo']
                                              .toString()
                                              .compareTo(b['cargo'].toString());
                                        });
                                      }
                                    },
                                    items: <String>['Nombre', 'Cargo']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList()),
                              ))
                        ],
                      )),
                ],
              ),
            ]));
  }

  List tagUser1 = [];
  List tagUser2 = [];
  List tagUser3 = [];

  bool isLoadingUsers = true;

  List allUsers = [];

  Future getAllList() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('tags')
        .where('tags', arrayContains: userUidTag)
        .getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var e = querySnapshot.docs[i];

      tagUser3.add(e['uidUserTags']);
    }

    QuerySnapshot querySnapshot1 = await Firestore.instance
        .collection('users')
        .where('uid', whereIn: tagUser3)
        .getDocuments();

    setState(() {
      tagUser3 = querySnapshot1.docs;
      tagUser3.sort((a, b) {
        return a['name'].toString().compareTo(b['name'].toString());
      });
    });
  }

  Widget containerUser() {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        color: const Color(0xffdcdee8),
        child: isLoadingUsers
            ? Shimmer.fromColors(
                direction: ShimmerDirection.ltr,
                baseColor: Colors.white,
                highlightColor: Colors.grey[400],
                child: ListView.builder(
                    itemCount: tagUser3.length,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          height: 140,
                          width: MediaQuery.of(context).size.width * 0.9,
                        )
                      ]);
                    }))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: tagUser3.length,
                itemBuilder: (context, index) {
                  if (searchController.text == '' ||
                      tagUser3[index]['name']
                          .toString()
                          .contains(searchController.text) ||
                      tagUser3[index]['cargo']
                          .toString()
                          .contains(searchController.text) ||
                      tagUser3[index]['name']
                          .toString()
                          .toLowerCase()
                          .contains(searchController.text) ||
                      tagUser3[index]['cargo']
                          .toString()
                          .toUpperCase()
                          .contains(searchController.text)) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Container(
                          height: 140.0,
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: RaisedButton(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Colors.white,
                              onPressed: () async {
                                DocumentSnapshot result = await Firestore
                                    .instance
                                    .collection('users')
                                    .document(tagUser3[index]['uid'])
                                    .get();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserProfilePage(userInfo: result)));
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FirebaseImage(
                                                'gs://meishi-7d80a.appspot.com/Profile/' +
                                                    tagUser3[index]['foto'],
                                                maxSizeBytes: 3500 * 1000,
                                                scale: 0.5),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft:
                                                  Radius.circular(15)))),
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  tagUser3[index]['name'],
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Flexible(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  tagUser3[index]['cargo'],
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              )),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                }));
  }

  String user01 = "";
}
