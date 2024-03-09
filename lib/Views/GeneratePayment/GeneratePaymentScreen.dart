import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../Card/SuccessScreen.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class GeneratePaymentScreen extends StatefulWidget {
  const GeneratePaymentScreen({super.key});

  @override
  State<GeneratePaymentScreen> createState() => _GeneratePaymentScreenState();
}

class _GeneratePaymentScreenState extends State<GeneratePaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final amount = TextEditingController();
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
      title: "Buat Pembayaran",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
            SvgPicture.asset(
              "assets/img/shop.svg",
              width: 250,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  height: bodyHeight * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldInputWidget(
                        nameController: amount,
                        label: "Jumlah Pembayaran",
                        obscureCondition: false,
                        keyboardNext: true,
                        keyboard: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonWidget(
                        buttonText: "Proses Pembayaran",
                        colorSetBody: Colors.blue,
                        colorSetText: Colors.white,
                        functionTap: () async {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SuccessScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
