import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import '../Auth/LoginScreen.dart';
import '../Home/HomeScreen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key, required this.valueHome, required this.navigatorKey});
  final int valueHome;
 final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 17),
      bodyPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 100),
    );
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Transparansi",
          body:
              "Memberikan transaparansi untuk setiap transaksi kartu yang dilakukan.",
          image: Lottie.asset('assets/img/lottie/transaction.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Keamanan",
          body:
              "Memberikan keamanan yang terintegrasi dengan sistem blockchain.",
          image: Lottie.asset('assets/img/lottie/secure.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Fleksibel",
          body:
              "Memberikan fleksibilitas untuk melakukan pelacakan setiap transaksi.",
          image: Lottie.asset('assets/img/lottie/tracking.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Permintaan Access",
          body:
              "Harap berikan access ke internet agar bisa terkoneksi secara realtime.",
          image: Lottie.asset('assets/img/lottie/access.json'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () async {
        if (Platform.isAndroid) {
          AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
          PermissionWithService locationPermission =
              Permission.locationWhenInUse;

          final pref = await SharedPreferences.getInstance();
          pref.setInt('OnBoarding', 1);
          var permissionStatus = await locationPermission.status;
          if (build.version.sdkInt >= 28) {
            if (permissionStatus == PermissionStatus.denied) {
              permissionStatus = await locationPermission.request();

              if (permissionStatus == PermissionStatus.denied) {
                permissionStatus = await locationPermission.request();
              }
            }
          } else {
            if (permissionStatus == PermissionStatus.denied) {
              permissionStatus = await locationPermission.request();

              if (permissionStatus == PermissionStatus.denied) {
                permissionStatus = await locationPermission.request();
              }
            }
          }
          if (permissionStatus == PermissionStatus.granted) {
            bool isLocationServiceOn =
                await locationPermission.serviceStatus.isEnabled;
            if (isLocationServiceOn) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (builder) {
                return widget.valueHome == 0 ? LoginScreen(navigatorKey: widget.navigatorKey,) : HomeScreen(navigatorKey: widget.navigatorKey,);
              }));
            }
          }
        }
      },
      dotsFlex: 4,
      showSkipButton: true,
      showBackButton: false,
      showDoneButton: true,
      showNextButton: true,
      back: Icon(Icons.arrow_back),
      next: Icon(Icons.arrow_forward),
      skip: Text(
        'Skip',
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      done: Text(
        'Done',
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      dotsDecorator: DotsDecorator(
          size: Size(10, 10),
          color: Colors.grey,
          activeSize: Size(22, 10),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)))),
    );
  }
}
