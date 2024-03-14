// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Connection/Connection.dart';
import '../../../Models/JWT/JWTDecode.dart';
import '../../Widget/AlertWidget.dart';
import '../../Widget/ButtonWidget.dart';
import '../../Widget/CardAlertCustomWidget.dart';
import '../../Widget/LoadingWidget.dart';
import '../../Widget/TextFieldInputWidget.dart';
import 'LoginScreen.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  Connection conn = Connection();

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
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
      title: "Login",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  height: bodyHeight * 0.4,
                  child: SvgPicture.asset("assets/img/reset.svg"),
                ),
                SizedBox(
                  height: bodyHeight * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Selamat Datang",
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Silakan reset akun kamu!",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: bodyHeight * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFieldInputWidget(
                            nameController: email,
                            label: "Email",
                            obscureCondition: false,
                            keyboardNext: true,
                            keyboard: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldInputWidget(
                            nameController: username,
                            label: "Username",
                            obscureCondition: false,
                            keyboardNext: true,
                            keyboard: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldInputWidget(
                            nameController: password,
                            label: "Password",
                            obscureCondition: true,
                            keyboardNext: false,
                            keyboard: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _loading
                              ? const LoadingWidget()
                              : ButtonWidget(
                                  buttonText: "Reset Password",
                                  colorSetBody: Colors.blue,
                                  colorSetText: Colors.white,
                                  functionTap: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      var res = await conn.resetAction(
                                          username.text,
                                          email.text,
                                          password.text);
                                      setState(() {
                                        _loading = false;
                                      });
                                      if (res == null) {
                                        AlertWidget(
                                                mediaQueryWidth,
                                                Iconsax.close_square,
                                                Colors.red.shade300,
                                                "Error!",
                                                "${res!.message}")
                                            .show(context);
                                        return;
                                      }

                                      if (res!.status) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CardAlertCustomWidget(
                                                  bodyHeight: bodyHeight * 0.25,
                                                  bodyScreen: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Akun telah berhasil direset passwordnya!",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      ButtonWidget(
                                                        buttonText:
                                                            "Kembali ke login",
                                                        colorSetBody:
                                                            Colors.blue,
                                                        colorSetText:
                                                            Colors.white,
                                                        functionTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (builder) {
                                                            return LoginScreen();
                                                          }));
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                            });
                                      } else {
                                        AlertWidget(
                                                mediaQueryWidth,
                                                Iconsax.close_square,
                                                Colors.red.shade300,
                                                "Error!",
                                                "${res!.message}")
                                            .show(context);
                                      }
                                    } else {
                                      AlertWidget(
                                              mediaQueryWidth,
                                              Iconsax.info_circle,
                                              Colors.amber.shade400,
                                              "Masih Kosong!",
                                              "Harap isi input field yang diperlukan / format salah!")
                                          .show(context);
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: bodyHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah Punya Akun?",
                        style: GoogleFonts.poppins(fontSize: 11),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Ink(
                          child: Text(
                            "Login Sekarang!",
                            style: GoogleFonts.poppins(
                                fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
