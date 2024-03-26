import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../../Models/UpdateUser/UpdateUser.dart';
import '../Widget/AlertWidget.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/LoadingWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.refreshToken,
  });

  final VoidCallback refreshToken;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _ProfileScreenState extends State<ProfileScreen> {
  Connection conn = Connection();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  Future checkAuthorize() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  Future<void> refreshData() async {
    setState(() {
      checkAuthorize().then((value) {
        setState(() {
          jwtData =
              JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
          nameController.text = jwtData!.name;
          usernameController.text = jwtData!.username;
          emailController.text = jwtData!.email;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthorize().then((value) {
      setState(() {
        jwtData =
            JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
        nameController.text = jwtData!.name;
        usernameController.text = jwtData!.username;
        emailController.text = jwtData!.email;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    final appBar = PreferredSize(
      preferredSize: Size.zero,
      child: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        widget.refreshToken();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: appBar,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconAppbarCustomWidget(
                    iconType: Iconsax.arrow_left_2,
                    functionTap: () async {
                      widget.refreshToken();
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
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldInputWidget(
                        nameController: nameController,
                        label: "Nama Lengkap",
                        obscureCondition: false,
                        keyboardNext: true,
                        keyboard: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldInputWidget(
                        nameController: usernameController,
                        label: "Username",
                        obscureCondition: false,
                        keyboardNext: true,
                        keyboard: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldInputWidget(
                        nameController: emailController,
                        label: "Email",
                        obscureCondition: false,
                        keyboardNext: false,
                        keyboard: true,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _loading
                                ? const LoadingWidget()
                                : ButtonWidget(
                                    buttonText: "Simpan Perubahan",
                                    colorSetBody: Colors.blue,
                                    colorSetText: Colors.white,
                                    functionTap: () async {
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        setState(() {
                                          _loading = true;
                                        });
                                        if (jwtData!.name ==
                                                nameController.text &&
                                            jwtData!.username ==
                                                usernameController.text &&
                                            jwtData!.email ==
                                                emailController.text) {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.error,
                                            title: 'Oops...',
                                            text: 'Tidak ada perubahan data!',
                                          );
                                        } else {
                                          UpdateUser data = UpdateUser(
                                              id_user: jwtData!.id_user,
                                              name: nameController.text,
                                              username: usernameController.text,
                                              email: emailController.text);
                                          var res = await conn.updateAction(
                                              accessToken!, data.toJson());
                                          if (res.status) {
                                            localStorage.setString(
                                                'accessToken',
                                                (res.data?.accessToken)
                                                    .toString());
                                            localStorage.setString(
                                                'refreshToken',
                                                (res.data?.refreshToken)
                                                    .toString());
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              title: "Berhasil",
                                              text: "Update Data Berhasil",
                                              barrierDismissible: false,
                                            ).then((value) {
                                              refreshData();
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
                                        }
                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          title: 'Oops...',
                                          text:
                                              'Harap isi input field yang diperlukan / format salah!',
                                        );
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
