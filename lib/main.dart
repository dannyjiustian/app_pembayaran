import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Views/Boarding/OnBoardingPage.dart';
import 'Views/Home/Auth/LoginScreen.dart';
import 'Views/Home/HomeScreen.dart';

int OnBoarding = 0, OnHomeScreen = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
  await initOnBoarding();
  runApp(const OnBoardingView());
}

Future initOnBoarding() async {
  final pref = await SharedPreferences.getInstance();

  String? email, nama, username, token;
  email = pref.getString('email');
  nama = pref.getString('nama');
  username = pref.getString('username');
  token = pref.getString('token');
  if (email != null && nama != null && username != null && token != null) {
    OnHomeScreen = 1;
  }
  int? boarding = pref.getInt('OnBoarding');
  if (boarding != null && boarding == 1) {
    return OnBoarding = 1;
  }
}

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: OnBoarding == 0
          ? OnBoardingPage(
              valueHome: OnHomeScreen,
            )
          : OnHomeScreen == 0
              ? LoginScreen()
              : HomeScreen(),
    );
  }
}
