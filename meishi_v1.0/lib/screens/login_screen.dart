import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meishi_v1/model/user.dart';
import 'package:meishi_v1/services/authentication.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  static const String routename = "/login_screen";

  LoginScreen({Key key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  User loggedInUser;
  var uuid = Uuid().v1().toString();

  void getCurrentUser() async {
    try {
      final user = await Authentication().getCurrentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      } else {
        print("error");
      }
    } catch (e) {
      print(e);
    }
  }

/*
  final String redirectURL = 'https://api-meishi.com';
  final String clientID = '776i7tyhjsf7aa';
  final String clientSecret = '85m1zDPMVf56fHZg';
*/
  void initState() {
    /*LinkedInLogin.initialize(context,
        clientId: clientID,
        clientSecret: clientSecret,
        redirectUri: redirectURL);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0xff141b21),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 35.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _irAtras(),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                      child: Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: _loginIcon(),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: ButtonTheme(
                          minWidth: 350.0,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: RaisedButton(
                              color: const Color(0xff647382),
                              textColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () {
                                handleSignIn();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    EvaIcons.google,
                                    size: 20,
                                  ),
                                  Text("   Continuar con Google",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    /*Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: _linkedinField(),
                    ),*/
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: _crearField(),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    _crearCuenta(),
                  ])),
                  Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "Siempre protegeremos y respetaremos\ntus datos y privacidad",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ))
                        ],
                      )),
                ])));
  }

  Widget _loginIcon() {
    return Image(
      width: 100,
      height: 100,
      image: AssetImage('images/sin_fondo_meishi.png'),
    );
  }

  bool linklogin = false;

  /*Widget _linkedinField() {
    return ButtonTheme(
        minWidth: 350.0,
        height: MediaQuery.of(context).size.height * 0.07,
        child: RaisedButton(
          color: const Color(0xff344353),
          textColor: Colors.white,
          padding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: () async {
            //linkedinLogin();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(EvaIcons.linkedin, size: 20),
              Text("   Continuar con LinkedIn",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            ],
          ),
        ));
  }*/

  /*LinkUser _userFromFirebaseUser(User user) {
    return user != null ? LinkUser(uid: user.uid) : null;
  }*/

  /*Stream<LinkUser> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }*/

  String email1 = "";

  /*void LinkEmail() {
    LinkedInLogin.getEmail().then((email) {
      String hola =
          '${email.elements.first.elementHandle.emailAddress}'.toString();
      email1 = hola;
    }).catchError((error) {
      print(error.errorDescription);
    });
  }*/

  /*Future<FirebaseUser> linkedinLogin() async {
    LinkedInLogin.loginForAccessToken(
      destroySession: true,
    ).then((accessToken) async {
      print(accessToken);
      UserCredential result = (await _auth.signInAnonymously());
      _user = result.user;
      print(accessToken);
      setState(() {
        isSignIn = true;
        if (isSignIn = true) {
          Navigator.pushNamed(context, '/createuserprofile_screen');
        }
      });
    }).catchError((error) {
      print(error);
    });
  }
*/
  Widget _crearCuenta() {
    return Column(
      children: <Widget>[
        Text("¿Ya tienes una cuenta?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            )),
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/loginuser_screen'),
          child: Text("Ingresa aquí",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )),
        ),
      ],
    );
  }

  Widget _crearField() {
    return ButtonTheme(
        minWidth: 350.0,
        height: MediaQuery.of(context).size.height * 0.07,
        child: RaisedButton(
            color: const Color(0xff04cbf3),
            textColor: Colors.white,
            padding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/createuser_screen');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Crear una cuenta",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
              ],
            )));
  }

  Widget _irAtras() {
    return FlatButton(
        textColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/launch_screen');
        },
        child: Icon(Icons.error_outline, size: 30.0, color: Colors.white));
  }

  bool isSignIn = false;

  Future<void> handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = (await _auth.signInWithCredential(credential));

    _user = result.user;

    setState(() {
      isSignIn = true;
      if (isSignIn = true) {
        if (result.additionalUserInfo.isNewUser) {
          print("Bienvenido: $_user");
          Navigator.pushNamed(context, '/createuserprofile_screen');
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/principal_screen', (route) => false);
        }
      }
    });
  }

  Future<void> googleSignOut() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
      setState(() {
        isSignIn = false;
        print('Desconectado');
      });
    });
  }
}
