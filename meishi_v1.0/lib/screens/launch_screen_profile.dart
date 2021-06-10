import 'package:flutter/material.dart';
import 'package:meishi_v1/model/slide.dart';
import 'package:meishi_v1/widgets/slide_dots.dart';
import 'package:meishi_v1/widgets/slide_item.dart';

class LaunchScreenProfile extends StatefulWidget {
  static const String routename = "/launch_screen_profile";

  LaunchScreenProfile({Key key}) : super(key: key);

  _LaunchScreenProfileState createState() => _LaunchScreenProfileState();
}

class _LaunchScreenProfileState extends State<LaunchScreenProfile> {
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[_boton()],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Expanded(
                      child: Column(children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.height * 0.20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('images/CapturaCopy.png'),
                          )),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                      ]),
                    ),
                    Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
        Navigator.pop(context);
      },
      child: Icon(
        Icons.chevron_left_rounded,
        size: 25.0,
      ),
    );
  }
}
