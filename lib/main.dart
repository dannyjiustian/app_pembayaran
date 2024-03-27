import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/JWT/JWTDecode.dart';
import 'Views/Boarding/OnBoardingPage.dart';
import 'Views/Auth/LoginScreen.dart';
import 'Views/Home/HomeScreen.dart';
import 'Views/Home/HomeScreenOutlet.dart';
import 'Views/Home/HomeScreenCounter.dart';

int onBoarding = 0, onHomeScreen = 0;
JWTDecode? data;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
  await initOnBoarding();
  runApp(OnBoardingView());
}

Future<void> initOnBoarding() async {
  final pref = await SharedPreferences.getInstance();

  String? accessToken = pref.getString('accessToken');
  if (accessToken != null) {
    onHomeScreen = 1;
    data = JWTDecode.fromJson(JWT.decode(accessToken).payload);
  }
  int? boarding = pref.getInt('OnBoarding');
  if (boarding != null && boarding == 1) {
    onBoarding = 1;
  }
}

class OnBoardingView extends StatelessWidget {
  OnBoardingView({Key? key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Pembayaran',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: onBoarding == 0
          ? OnBoardingPage(
              valueHome: onHomeScreen,
              navigatorKey: navigatorKey,
            )
          : onHomeScreen == 0
              ? LoginScreen(
                  navigatorKey: navigatorKey,
                )
              : _buildSwitch(context),
    );
  }

  Widget _buildSwitch(BuildContext context) {
    switch (data?.role) {
      case '1':
        return HomeScreen(
          navigatorKey: navigatorKey,
        );
      case '2':
        return HomeScreenOutlet(
          navigatorKey: navigatorKey,
        );
      case '3':
        return HomeScreenCounter(navigatorKey: navigatorKey,);
      default:
        return HomeScreen(
          navigatorKey: navigatorKey,
        );
    }
  }
}
