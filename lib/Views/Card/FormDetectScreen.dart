import 'package:app_pembayaran/Views/Widget/CardRFIDVirtualWidget.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Models/CreateTransaction/CreateTransaction.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../../Models/SaveNewCard/SaveNewCard.dart';
import '../SuccessScreen/SuccessScreen.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/LoadingWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class FormDetectScreen extends StatefulWidget {
  const FormDetectScreen({
    super.key,
    required this.id_card,
    required this.balance,
    required this.typeDetect,
    required this.walletAddress,
    required this.idRfid,
    this.refreshToken,
  });

  final String id_card, walletAddress, idRfid;
  final int balance, typeDetect;
  final VoidCallback? refreshToken;

  @override
  State<FormDetectScreen> createState() => _FormDetectScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _FormDetectScreenState extends State<FormDetectScreen> {
  Connection conn = Connection();
  final _formKey = GlobalKey<FormState>();

  final amount = TextEditingController();

  bool _loading = false;

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  @override
  void initState() {
    super.initState();
    checkLocalStorage().then((value) {
      setState(() {
        jwtData =
            JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        bool isNfcAvailable = await NfcManager.instance.isAvailable();
        if (isNfcAvailable) {
          await NfcManager.instance.stopSession();
        }
        widget.refreshToken?.call();
        Navigator.of(context).pop();
      },
      child: Scaffold(
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
                      bool isNfcAvailable =
                          await NfcManager.instance.isAvailable();
                      if (isNfcAvailable) {
                        await NfcManager.instance.stopSession();
                      }
                      widget.refreshToken?.call();
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
              const SizedBox(
                height: 20,
              ),
              widget.typeDetect == 1
                  ? Column(
                      children: [
                        SizedBox(
                            height: 180,
                            child: CardRFIDVirtualWidget(
                                walletAddress: widget.walletAddress,
                                saldo: widget.balance,
                                mediaQueryWidth: mediaQueryWidth)),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            height: bodyHeight * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFieldInputWidget(
                                  nameController: amount,
                                  label: "Jumlah Pengisian",
                                  obscureCondition: false,
                                  keyboardNext: false,
                                  keyboard: true,
                                  keyboardType: true,
                                  typeInput: TextInputType.number,
                                  formatRupiah: true,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                _loading
                                    ? const LoadingWidget()
                                    : ButtonWidget(
                                        buttonText: "Isi Kartu",
                                        colorSetBody: Colors.blue,
                                        colorSetText: Colors.white,
                                        functionTap: () async {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            bool isNfcAvailable =
                                                await NfcManager.instance
                                                    .isAvailable();
                                            if (isNfcAvailable) {
                                              await NfcManager.instance
                                                  .stopSession();
                                            }

                                            setState(() {
                                              _loading = true;
                                            });
                                            CreateTransaction data =
                                                CreateTransaction(
                                                    id_user: jwtData!.id_user,
                                                    id_card: widget.id_card,
                                                    type: "1",
                                                    total_payment: amount.text
                                                        .replaceAll(".", ""),
                                                    status: "Selesai");
                                            var res =
                                                await conn.createTransaction(
                                                    accessToken!, data.toJson(),
                                                    topup: true);

                                            setState(() {
                                              _loading = false;
                                            });
                                            if (res.status) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SuccessScreen(
                                                          refreshToken: widget
                                                              .refreshToken,
                                                          typeDetect:
                                                              widget.typeDetect,
                                                        )),
                                              );
                                            }
                                          } else {
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              title: 'Oops...',
                                              text:
                                                  'Harap isi input field yang diperlukan!',
                                            );
                                          }
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                            height: 180,
                            child: CardRFIDVirtualWidget(
                                saldo: 0, mediaQueryWidth: mediaQueryWidth)),
                        SizedBox(
                          height: 30,
                        ),
                        _loading
                            ? const LoadingWidget()
                            : ButtonWidget(
                                buttonText: "Daftar Kartu",
                                colorSetBody: Colors.blue,
                                colorSetText: Colors.white,
                                functionTap: () async {
                                  setState(() {
                                    _loading = true;
                                  });

                                  SaveNewCard data = SaveNewCard(
                                    id_user: jwtData!.id_user,
                                    id_rfid: widget.idRfid,
                                    balance: "0",
                                  );
                                  var res = await conn.saveNewCard(
                                      accessToken!, data.toJson());
                                  setState(() {
                                    _loading = false;
                                  });

                                  if (res.status) {
                                    bool isNfcAvailable =
                                        await NfcManager.instance.isAvailable();
                                    if (isNfcAvailable) {
                                      await NfcManager.instance.stopSession();
                                    }
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => SuccessScreen(
                                                refreshToken:
                                                    widget.refreshToken,
                                                typeDetect: widget.typeDetect,
                                              )),
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
            ]),
          ),
        ),
      ),
    );
  }
}
