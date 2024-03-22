import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../Widget/LoadingNFCReaderWidget.dart';
import 'FormDetectScreen.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';

class DetectCardScreen extends StatefulWidget {
  const DetectCardScreen({
    super.key,
    required this.navigatorKey,
    this.detectCard = true,
    required this.typeDetect,
    this.refreshToken,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final bool detectCard;
  final int typeDetect;
  final VoidCallback? refreshToken;

  @override
  State<DetectCardScreen> createState() => _DetectCardScreenState(detectCard);
}

JWTDecode? jwtData;
String? accessToken;

class _DetectCardScreenState extends State<DetectCardScreen> {
  Connection conn = Connection();
  // bool detectCard = true;
  bool _isMounted = false;
  late bool _detectCard;

  _DetectCardScreenState(bool detectCard) {
    _detectCard = detectCard;
  }

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _detectCard = widget.detectCard;
    checkLocalStorage().then((value) {
      setState(() {
        jwtData =
            JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
      });
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
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
        widget.refreshToken!();
        Navigator.of(context).pop();
      },
      child: Scaffold(
          appBar: appBar,
          body: Padding(
            padding: const EdgeInsets.all(20),
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
                      widget.refreshToken!();
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
                  child: FutureBuilder<bool>(
                      future: NfcManager.instance.isAvailable(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingNFCReaderWidget(
                              mediaQueryWidth: mediaQueryWidth);
                        } else if (snapshot.data != true) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                  'assets/img/lottie/device_error.json'),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "NFC tidak tersedia atau NFC dalam posisi mati, silakan nyalakan dan coba lagi!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          );
                        } else {
                          NfcManager.instance.startSession(
                              onDiscovered: (NfcTag tag) async {
                            Set<String> identifiers = {};

                            // Iterate over each data item in the tag
                            tag.data.forEach((key, value) {
                              if (value.containsKey('identifier') &&
                                  value['identifier'] is List<int>) {
                                // Convert byte array to hexadecimal string
                                String identifier = value['identifier']
                                    .map((byte) =>
                                        byte.toRadixString(16).padLeft(2, '0'))
                                    .join(':')
                                    .toUpperCase(); // Convert to uppercase
                                // Add the identifier to the set
                                identifiers.add(identifier);
                              }
                            });

                            // Convert the set of identifiers to a single string
                            String identifiersString = identifiers.join('');

                            // Check if there are any identifiers
                            if (identifiers.isNotEmpty) {
                              // Print the unique identifiers without brackets
                              // print(identifiersString);
                              var res;
                              if (widget.typeDetect == 1) {
                                res = await conn.getCardByIDUser(
                                    accessToken!, jwtData!.id_user,
                                    id_rfid: identifiersString);
                              } else {
                                res = await conn.searchCard(
                                    accessToken!, identifiersString);
                              }
                              if (_isMounted) {
                                if (res.status) {
                                  setState(() {
                                    checkLocalStorage();
                                  });
                                  widget.navigatorKey.currentState
                                      ?.pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => FormDetectScreen(
                                              refreshToken: widget.refreshToken,
                                              idRfid: widget.typeDetect == 1
                                                  ? ""
                                                  : identifiersString,
                                              walletAddress:
                                                  widget.typeDetect == 1
                                                      ? res.data[0]
                                                          .wallet_address
                                                      : "",
                                              id_card: widget.typeDetect == 1
                                                  ? res.data[0].id_card
                                                  : "",
                                              balance: widget.typeDetect == 1
                                                  ? res.data[0].balance
                                                  : 0,
                                              typeDetect: widget.typeDetect,
                                            )),
                                  );
                                } else {
                                  setState(() {
                                    _detectCard = false;
                                    checkLocalStorage();
                                  });
                                }
                              } else {
                                if (res.status) {
                                  checkLocalStorage();
                                  widget.navigatorKey.currentState
                                      ?.pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => FormDetectScreen(
                                              refreshToken: widget.refreshToken,
                                              idRfid: widget.typeDetect == 1
                                                  ? ""
                                                  : identifiersString,
                                              walletAddress:
                                                  widget.typeDetect == 1
                                                      ? res.data[0]
                                                          .wallet_address
                                                      : "",
                                              id_card: widget.typeDetect == 1
                                                  ? res.data[0].id_card
                                                  : "",
                                              balance: widget.typeDetect == 1
                                                  ? res.data[0].balance
                                                  : 0,
                                              typeDetect: widget.typeDetect,
                                            )),
                                  );
                                } else {
                                  widget.navigatorKey.currentState
                                      ?.pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => DetectCardScreen(
                                        navigatorKey: widget.navigatorKey,
                                        detectCard: false,
                                        typeDetect: widget.typeDetect,
                                        refreshToken: widget.refreshToken,
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          });
                          return _detectCard
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                        'assets/img/lottie/contactless.json'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Tempelkan kartu Kamu ke area NFC Ponsel",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                        'assets/img/lottie/nfc_read_false.json'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${widget.typeDetect == 1 ? "Kartu Belum Terdaftar Diakun kamu" : "Kartu Sudah Terdaftar Diakun lain"}, Silakan coba dengan kartu lain!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ButtonWidget(
                                        buttonText: "Coba Lagi",
                                        colorSetBody: Colors.blue.shade100,
                                        colorSetText: Colors.black,
                                        functionTap: () {
                                          setState(() {
                                            _detectCard = true;
                                          });
                                        }),
                                  ],
                                );
                        }
                        // }
                      })),
            ]),
          )),
    );
  }
}
