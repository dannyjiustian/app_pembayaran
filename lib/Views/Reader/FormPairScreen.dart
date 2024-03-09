import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class FormPairScreen extends StatefulWidget {
  const FormPairScreen({super.key});

  @override
  State<FormPairScreen> createState() => _FormPairScreenState();
}

class _FormPairScreenState extends State<FormPairScreen> {
  final _formKey = GlobalKey<FormState>();

  final serialNumberController = TextEditingController();
  final wifiController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    final appBar = PreferredSize(
      preferredSize: Size.zero,
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
    );

    final bodyHeight = mediaQueryHeight -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return MaterialApp(
      title: "Add Reader",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconAppbarCustomWidget(
                  iconType: Iconsax.arrow_left_2,
                  functionTap: () async {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Kembali",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/img/pairing.svg",
                  width: 150,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: bodyHeight * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Waktunya Pairing Reader Baru Nih",
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Isi semua data yang diperlukan!",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    height: bodyHeight * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFieldInputWidget(
                            nameController: serialNumberController,
                            label: "Serial Number Reader",
                            obscureCondition: false,
                            keyboardNext: true,
                            keyboard: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldInputWidget(
                            nameController: wifiController,
                            label: "Nama WiFi",
                            obscureCondition: false,
                            keyboardNext: true,
                            keyboard: false,
                            enabledField: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldInputWidget(
                            nameController: passwordController,
                            label: "Password WiFi",
                            obscureCondition: true,
                            keyboardNext: false,
                            keyboard: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonWidget(
                              buttonText: "Scan QR Code Serial Number",
                              colorSetBody: Colors.indigo,
                              colorSetText: Colors.white,
                              functionTap: () => {}),
                          SizedBox(
                            height: 10,
                          ),
                          ButtonWidget(
                            buttonText: "Pairing",
                            colorSetBody: Colors.blue,
                            colorSetText: Colors.white,
                            functionTap: () async {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: bodyHeight * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        "*Harap memasukkan Serial Number Reader yang benar!, Pastikan juga WiFi yang digunakan berfrekuenzi 2.4GHz serta juga telah terkoneksi dengan ponsel, [JANGAN UBAH NAMA WIFI SUDAH AUTO DETECT!]",
                        style: GoogleFonts.poppins(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
        ]),
      ),
    );
  }
}
