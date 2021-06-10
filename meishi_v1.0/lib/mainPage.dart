import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  static const String routename = "/main_screen";
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool auth = false;

  @override
  void initState() {
    
    if (_auth.currentUser == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/launch_screen', (route) => false);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/principal_screen', (route) => false);
      });
    }
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext) {
    return Center(
        child: Column(
      children: <Widget>[
        Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    ));
  }
}
