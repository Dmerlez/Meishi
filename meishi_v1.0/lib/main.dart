import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meishi_v1/mainPage.dart';
import 'package:meishi_v1/screens/createuser_screen.dart';
import 'package:meishi_v1/screens/createuserprofile_screen.dart';
import 'package:meishi_v1/screens/edituser_screen.dart';
import 'package:meishi_v1/screens/launch_screen.dart';
import 'package:meishi_v1/screens/launch_screen_profile.dart';
import 'package:meishi_v1/screens/login_screen.dart';
import 'package:meishi_v1/screens/loginuser_screen.dart';
import 'package:meishi_v1/screens/ownprofileview_screen.dart';
import 'package:meishi_v1/screens/principalView_screen.dart';
import 'package:meishi_v1/screens/principal_screen.dart';
import 'package:meishi_v1/screens/solicitudes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/main_screen',
    routes: <String, WidgetBuilder>{
      LaunchScreenProfile.routename: (BuildContext context) =>
          LaunchScreenProfile(),
      EditProfileView.routename: (BuildContext context) => EditProfileView(),
      SolitudeScreen.routename: (BuildContext context) => SolitudeScreen(),
      PrincipalScreen.routename: (BuildContext context) => PrincipalScreen(),
      LoginUserScreen.routename: (BuildContext context) => LoginUserScreen(),
      MainPage.routename: (BuildContext context) => MainPage(),
      LaunchScreen.routename: (BuildContext context) => LaunchScreen(),
      LoginScreen.routename: (BuildContext context) => LoginScreen(),
      PrincipalView.routename: (BuildContext context) => PrincipalView(),
      ProfileOwnView.routename: (BuildContext context) => ProfileOwnView(),
      CreateUserProfileScreen.routename: (BuildContext context) =>
          CreateUserProfileScreen(),
      CreateUserScreen.routename: (BuildContext context) => CreateUserScreen(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
