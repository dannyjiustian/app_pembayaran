import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../../Models/ListCard/ListCard.dart';
import '../Auth/LoginScreen.dart';
import '../Card/DetectCardScreen.dart';
import '../Widget/CardListRFIDVirtualWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/LoadingCardRFIDVirtualWidget.dart';

class CardListScreen extends StatefulWidget {
  const CardListScreen({
    super.key,
    required this.navigatorKey,
    this.refreshToken,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final VoidCallback? refreshToken;

  @override
  State<CardListScreen> createState() => _CardListScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _CardListScreenState extends State<CardListScreen> {
  Connection conn = Connection();
  Future<ListCard>? _futureDataCard;

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  void detectAndRefreshData(data) {
    if (!data.status && data.message == "refresh token verification failed") {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Silakan Login Kembali, Karena 3 Hari Tidak Ada Buka Aplikasi',
      );
      widget.navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(
                navigatorKey: widget.navigatorKey,
              )));
    }
    widget.refreshToken?.call();
  }

  Future<void> refreshData() async {
    setState(() {
      _futureDataCard = fetchDataCard();
      print("old ${accessToken}");
    });
  }

  Future<ListCard> fetchDataCard() async {
    ListCard data = await conn.getCardByIDUser(accessToken!, jwtData!.id_user);
    detectAndRefreshData(data);
    return data;
  }

  @override
  void initState() {
    super.initState();
    checkLocalStorage().then((value) {
      setState(() {
        jwtData =
            JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
      });
      _futureDataCard = fetchDataCard();
    });
    _futureDataCard =
        Future.value(ListCard(status: false, message: "Waiting data!"));
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
        widget.refreshToken?.call();
        Navigator.of(context).pop();
      },
      child: Scaffold(
          appBar: appBar,
          body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconAppbarCustomWidget(
                    iconType: Iconsax.arrow_left_2,
                    functionTap: () async {
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
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(
                      future: _futureDataCard,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingCardRFIDVirtualWidget(
                            mediaQueryWidth: mediaQueryWidth,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.data!.status) {
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 20),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CardListRFIDVirtualCard(
                                    mediaQueryWidth: mediaQueryWidth,
                                    idCard: snapshot.data!.data![index].id_card,
                                    walletAddress: snapshot
                                        .data!.data![index].wallet_address,
                                    balance:
                                        snapshot.data!.data![index].balance,
                                    balanceEth:
                                        snapshot.data!.data![index].balance_eth,
                                    createdAt:
                                        snapshot.data!.data![index].created_at,
                                    transactionLength: snapshot.data!
                                        .data![index].transactions!.length,
                                    isActive:
                                        snapshot.data!.data![index].is_active,
                                    refreshData: refreshData,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetectCardScreen(
                                                    refreshToken:
                                                        widget.refreshToken,
                                                    navigatorKey:
                                                        widget.navigatorKey,
                                                    typeDetect: 1,
                                                  )));
                                    },
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      strokeWidth: 2,
                                      dashPattern: const [6, 3, 6, 3],
                                      color: Colors.grey.shade500,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          height: 130,
                                          width: mediaQueryWidth - 50,
                                          color: Colors.blue.shade50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Iconsax.cards,
                                                size: 50,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Daftar Kartu",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Lottie.asset(
                                      'assets/img/lottie/no_transaction.json',
                                      width: 200),
                                  Text(
                                    "Belum Ada Kartu Terdaftar!",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      }),
                ),
              ),
            )
          ])),
    );
  }
}
