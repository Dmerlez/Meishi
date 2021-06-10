import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meishi_v1/model/slide.dart';
import 'package:meishi_v1/widgets/slide_dots.dart';
import 'package:meishi_v1/widgets/slide_item.dart';

class LaunchScreen extends StatefulWidget {
  static const String routename = "/launch_screen";

  LaunchScreen({Key key}) : super(key: key);

  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = -1;

  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void initState() {
    super.initState();
    if (_currentPage < 4) {
      _currentPage++;
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  _signOut() async {
    await _auth.signOut();
    Navigator.pushNamed(context, '/login_screen');
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color(0xff141c24),
          child: (Padding(
              padding: const EdgeInsets.all(20),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                if (_currentPage != 3)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[_boton()],
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Expanded(
                  child: Column(children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('images/CapturaCopy.png'),
                      )),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: slideList.length,
                              itemBuilder: (ctx, i) => SlideItem(i),
                            ),
                          ]),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (_currentPage == 3)
                          ButtonTheme(
                              minWidth: 330,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: RaisedButton(
                                  color: Colors.pink,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/login_screen');
                                  },
                                  child: Text("Ingresar a Meishi",
                                      style: TextStyle(fontSize: 16.0))))
                      ],
                    ))
                  ]),
                ),
                Stack(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < slideList.length; i++)
                            if (i == _currentPage)
                              SlideDots(true)
                            else
                              SlideDots(false)
                        ],
                      ))
                ])
              ])))),
    );
  }

  Widget _boton() {
    return FlatButton(
        textColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/login_screen');
         
        },
        child: Row(
          children: <Widget>[
            Icon(
              Icons.skip_next,
              size: 20.0,
            ),
            Text("Omitir", style: TextStyle(fontSize: 19.0)),
          ],
        ));
  }
}
