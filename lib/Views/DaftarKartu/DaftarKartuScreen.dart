import 'package:app_pembayaran/Views/Card/SuccessScreen.dart';
import 'package:app_pembayaran/Views/Widget/CardRFIDVirtualWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class DaftarKartuScreen extends StatefulWidget {
  const DaftarKartuScreen({super.key});

  @override
  State<DaftarKartuScreen> createState() => _DaftarKartuScreenState();
}

class _DaftarKartuScreenState extends State<DaftarKartuScreen> {
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
      title: "Daftar Kartu",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(
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
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 180,
                  child:
                      CardRFIDVirtualWidget(mediaQueryWidth: mediaQueryWidth)),
              SizedBox(
                height: 30,
              ),
              ButtonWidget(
                buttonText: "Daftar Kartu",
                colorSetBody: Colors.blue,
                colorSetText: Colors.white,
                functionTap: () async {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SuccessScreen()));
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
