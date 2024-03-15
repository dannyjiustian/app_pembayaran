import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../Connection/Connection.dart';
import '../Widget/AlertWidget.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/CardAlertCustomWidget.dart';
import '../Widget/LoadingWidget.dart';
import '../Widget/TextFieldInputWidget.dart';
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Connection conn = Connection();
  final _formKey = GlobalKey<FormState>();

  final nama = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool _loading = false;

  // Future checkConnectionNetwork() async {
  //   await execute(InternetConnectionChecker());

  //   final InternetConnectionChecker customInstance =
  //       InternetConnectionChecker.createInstance(
  //     checkTimeout: const Duration(seconds: 1),
  //     checkInterval: const Duration(seconds: 1),
  //   );

  //   await execute(customInstance);
  // }

  // Future execute(
  //   InternetConnectionChecker internetConnectionChecker,
  // ) async {
  //   final StreamSubscription<InternetConnectionStatus> listener =
  //       InternetConnectionChecker().onStatusChange.listen(
  //     (InternetConnectionStatus status) {
  //       switch (status) {
  //         case InternetConnectionStatus.connected:
  //           break;
  //         case InternetConnectionStatus.disconnected:
  //           Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(builder: (context) => OfflineScreen()),
  //               (Route<dynamic> route) => false);
  //           break;
  //       }
  //     },
  //   );
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   checkConnectionNetwork();
  // }

  String? _selectedItem, _role = "1";

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
      title: "Register",
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
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                  height: bodyHeight * 0.3,
                  child: SvgPicture.asset("assets/img/svg/register.svg"),
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
                        "Ayo register akun dulu!",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: bodyHeight * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFieldInputWidget(
                            nameController: nama,
                            label: "Nama Lengkap",
                            obscureCondition: false,
                            keyboardNext: true,
                            keyboard: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldInputWidget(
                            nameController: username,
                            label: "Username",
                            obscureCondition: false,
                            keyboardNext: true,
                            keyboard: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                            nameController: password,
                            label: "Password",
                            obscureCondition: true,
                            keyboardNext: false,
                            keyboard: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8)),
                            child: DropdownButtonFormField<String>(
                              // value: _selectedItem,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.black),
                              onChanged: (String? role) {
                                setState(() {
                                  _selectedItem = role!;
                                });
                              },
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              borderRadius: BorderRadius.circular(8),
                              items: <String>[
                                'Pengguna',
                                'Outlet',
                                'Counter',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Pilih Jenis Akun",
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                errorStyle: TextStyle(height: 0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pilih Jenis Akun';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _loading
                              ? const LoadingWidget()
                              : ButtonWidget(
                                  buttonText: "Register",
                                  colorSetBody: Colors.blue,
                                  colorSetText: Colors.white,
                                  functionTap: () async {
                                    FocusScope.of(context).unfocus();
                                    switch (_selectedItem) {
                                      case 'Pengguna':
                                        _role = "1";
                                        break;
                                      case 'Outlet':
                                        _role = "2";
                                        break;
                                      case 'Counter':
                                        _role = "3";
                                        break;
                                      default:
                                        _role = "1"; // Default value
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      var res = await conn.registerAction(
                                          nama.text,
                                          username.text,
                                          email.text,
                                          password.text,
                                          _role);
                                      setState(() {
                                        _loading = false;
                                      });
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
                                                        "Akun telah berhasil dibuat silakan login!",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(
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
                                                            return const LoginScreen();
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
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                              child: Text(
                            "*Dengan register maka menyetujui S&K yang berlaku.",
                            style: GoogleFonts.poppins(fontSize: 11),
                          ))
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
                          Navigator.of(context).pop();
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
