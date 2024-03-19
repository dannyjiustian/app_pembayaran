import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Function/formatDateOnly.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../../Models/ListCard/ListCard.dart';
import '../../Models/ListTransaction/ListTransaction.dart';
import '../Auth/LoginScreen.dart';
import '../Card/DetectCardScreen.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/CardBannerWidget.dart';
import '../Widget/CardListTransactionWidget.dart';
import '../Widget/CardRFIDVirtualWidget.dart';
import '../Widget/LoadingCardRFIDVirtualWidget.dart';
import '../Widget/LoadingListTransactionWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Connection conn = Connection();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndexBottomNav = 0, _selectedIndexTab = 0;
  PageController _pageController = PageController(initialPage: 0);
  Future<ListCard>? _futureDataCard;
  Future<ListTransaction>? _futureDataLastTransaction,
      _futureDataTransactionFinish,
      _futureDataTransactionOnProcess;
  late TabController _tabController;

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
    // pref.setString("refreshToken",
    //     "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpZF91c2VyIjoiYTI3MGU5N2YtY2E1ZS00NTQ3LWJlN2QtMjVlZTcxZjE4ODI0IiwiaWF0IjoxNzA5MjE0ODIzLCJleHAiOjE3MDkyMTg0MjN9.nMVjX6fX1vscnrcmbRZHt-UgIQXzAK2VlZK5Dgla-4AcEVSYJPm0-rwLXeSeJCIZdHAAWqLBv-2pn_FNihWD-Q");
  }

  Future<ListCard> fetchDataCard() async {
    ListCard data = await conn.getCardByIDUser(accessToken!, jwtData!.id_user);
    if (!data.status)
      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    return data;

    // print(data.status);
    // print(data.message);
    // return data;
    // // try {
    // //   return await conn.getCardByIDUser(accessToken!, jwtData!.id_user);
    // // } catch (e) {
    // //   print(e);
    //   navigatorKey.currentState?.pushReplacement(
    //       MaterialPageRoute(builder: (context) => LoginScreen()));
    // //   Map<String, dynamic> data =
    // //       (json.decode('{"status": false, "message": "${e.toString()}"}')
    // //           as Map<String, dynamic>);
    // //   return ListCard.fromJson(data);
    // // }
  }

  Future<ListTransaction> fetchDataLastTransaction() async {
    return await conn.getTransasctionByIDUser("${jwtData?.id_user}",
        status: true, take: 5);
  }

  Future<ListTransaction> fetchDataTransactionFinish() async {
    return await conn.getTransasctionByIDUser("${jwtData?.id_user}",
        status: true);
  }

  Future<ListTransaction> fetchDataTransactionOnProcess() async {
    return await conn.getTransasctionByIDUser("${jwtData?.id_user}",
        status: false);
  }

  Future<void> refreshData() async {
    setState(() {
      if (_selectedIndexBottomNav == 0) {
        _futureDataCard = fetchDataCard();
        _futureDataLastTransaction = fetchDataLastTransaction();
      } else if (_selectedIndexBottomNav == 1 && _selectedIndexTab == 0) {
        _futureDataTransactionFinish = fetchDataTransactionFinish();
      } else if (_selectedIndexBottomNav == 1 && _selectedIndexTab == 1) {
        _futureDataTransactionOnProcess = fetchDataTransactionOnProcess();
      }
      checkLocalStorage().then((value) {
        setState(() {
          jwtData =
              JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
        });
      });
    });
  }

  Future<void> refreshDataAfterCancel() async {
    setState(() {
      _futureDataLastTransaction = fetchDataLastTransaction();
      _futureDataTransactionFinish = fetchDataTransactionFinish();
      _futureDataTransactionOnProcess = fetchDataTransactionOnProcess();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocalStorage().then((value) {
      setState(() {
        jwtData =
            JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
      });
      _futureDataCard = fetchDataCard();
      _futureDataLastTransaction = fetchDataLastTransaction();
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndexTab = _tabController.index;
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

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "Home",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndexBottomNav = index;
            });
          },
          children: [
            _selectedIndexBottomNav == 0
                ? RefreshIndicator(
                    onRefresh: refreshData,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            height: bodyHeight * 0.13,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    child: SizedBox(
                                      width:
                                          48, // Set the width and height according to your requirement
                                      height: 48,
                                      child: SvgPicture.asset(
                                          "assets/img/svg/user.svg"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hi, ${jwtData?.name} 👋",
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Selamat datang kembali!",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder(
                              future: _futureDataCard,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingCardRFIDVirtualWidget(
                                    mediaQueryWidth: mediaQueryWidth,
                                  );
                                } else {
                                  if (snapshot.data!.status) {
                                    return SizedBox(
                                      height: 230,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Swiper(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CardRFIDVirtualWidget(
                                              idCard: snapshot
                                                  .data!.data![index].id_card,
                                              saldo: snapshot
                                                  .data!.data![index].balance,
                                              walletAddress: snapshot.data!
                                                  .data![index].wallet_address,
                                              mediaQueryWidth: mediaQueryWidth,
                                            );
                                          },
                                          itemCount:
                                              snapshot.data!.data!.length,
                                          itemWidth: mediaQueryWidth - 40,
                                          itemHeight: 180,
                                          layout: SwiperLayout.STACK,
                                          scrollDirection: Axis.vertical,
                                          axisDirection: AxisDirection.down,
                                          loop: snapshot.data!.data!.length > 1
                                              ? true
                                              : false,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetectCardScreen()));
                                        },
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          strokeWidth: 2,
                                          dashPattern: const [6, 3, 6, 3],
                                          color: Colors.grey.shade500,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: mediaQueryWidth / 2 - 30,
                                    child: ButtonWidget(
                                        buttonText: "Top Up",
                                        colorSetBody: Colors.blue.shade100,
                                        colorSetText: Colors.black,
                                        functionTap: () async {
                                          // var res =
                                          //     await conn.getTransasctionByIDUser(
                                          //         "${jwtData?.id_user}",
                                          //         offset: 1);
                                          // print(res);
                                          // print(jwtData!.id_user);
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             DetectCardScreen()))
                                        }),
                                  ),
                                  SizedBox(
                                    width: mediaQueryWidth / 2 - 30,
                                    child: ButtonWidget(
                                        buttonText: "Daftar Kartu",
                                        colorSetBody: Colors.blue.shade100,
                                        colorSetText: Colors.black,
                                        functionTap: () => {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetectCardScreen()))
                                            }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 130,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                              child: Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  return const CardBannerWidget();
                                },
                                itemCount: 3,
                                viewportFraction: 0.9,
                                scale: 0.98,
                                autoplay: true,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Text(
                                "Transaksi Terakhir",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          FutureBuilder(
                              future: _futureDataLastTransaction,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: LoadingListTransactionsWidget(
                                        mediaQueryWidth: mediaQueryWidth),
                                  );
                                } else {
                                  if (snapshot.data!.status) {
                                    return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 20),
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.data!.length,
                                            itemBuilder: (context, index) =>
                                                CardListTransactionWidget(
                                                    status: snapshot.data!
                                                        .data![index].status,
                                                    idTransaction: snapshot
                                                        .data!
                                                        .data![index]
                                                        .id_transaction,
                                                    type: snapshot.data!
                                                        .data![index].type,
                                                    updatedAt: snapshot
                                                        .data!
                                                        .data![index]
                                                        .updated_at,
                                                    totalPayment: snapshot
                                                        .data!
                                                        .data![index]
                                                        .total_payment,
                                                    mediaQueryWidth:
                                                        mediaQueryWidth),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      height: 10,
                                                    )));
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Lottie.asset(
                                              'assets/img/lottie/no_transaction.json',
                                              width: 200),
                                          Text(
                                            "Belum Ada Transaksi!",
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
                        ],
                      ),
                    ),
                  )
                : _selectedIndexBottomNav == 1
                    ? DefaultTabController(
                        initialIndex: 0,
                        length: 2,
                        child: Scaffold(
                          appBar: TabBar(
                              controller: _tabController,
                              labelColor: Colors.blue.shade500,
                              unselectedLabelColor: Colors.grey.shade500,
                              tabs: [
                                Tab(
                                    child: Text(
                                  'Selesai',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )),
                                Tab(
                                    child: Text('On Proses',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600))),
                              ]),
                          body: TabBarView(
                            controller: _tabController,
                            children: [
                              RefreshIndicator(
                                onRefresh: refreshData,
                                child: FutureBuilder(
                                    future: _futureDataTransactionFinish,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 20),
                                          child: LoadingListTransactionsWidget(
                                              mediaQueryWidth: mediaQueryWidth),
                                        );
                                      } else {
                                        if (snapshot.data!.status) {
                                          return ListView.separated(
                                              padding: const EdgeInsets.all(20),
                                              itemCount:
                                                  snapshot.data!.data!.length,
                                              itemBuilder: (context, index) =>
                                                  CardListTransactionWidget(
                                                      status: snapshot.data!
                                                          .data![index].status,
                                                      idTransaction: snapshot
                                                          .data!
                                                          .data![index]
                                                          .id_transaction,
                                                      type: snapshot.data!
                                                          .data![index].type,
                                                      updatedAt: snapshot
                                                          .data!
                                                          .data![index]
                                                          .updated_at,
                                                      totalPayment: snapshot
                                                          .data!
                                                          .data![index]
                                                          .total_payment,
                                                      mediaQueryWidth:
                                                          mediaQueryWidth),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                        height: 10,
                                                      ));
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: ListView(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Lottie.asset(
                                                        'assets/img/lottie/no_transaction.json',
                                                        width: 200),
                                                    Text(
                                                      "Belum Ada Transaksi!",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    }),
                              ),
                              RefreshIndicator(
                                onRefresh: refreshData,
                                child: FutureBuilder(
                                    future: _futureDataTransactionOnProcess,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 20),
                                          child: LoadingListTransactionsWidget(
                                              mediaQueryWidth: mediaQueryWidth),
                                        );
                                      } else {
                                        if (snapshot.data!.status &&
                                            snapshot.hasData) {
                                          return ListView.separated(
                                              padding: const EdgeInsets.all(20),
                                              itemCount: snapshot
                                                  .data!.data!.length,
                                              itemBuilder: (context, index) =>
                                                  CardListTransactionWidget(
                                                      refreshCallback:
                                                          refreshDataAfterCancel,
                                                      status: snapshot.data!
                                                          .data![index].status,
                                                      idTransaction: snapshot
                                                          .data!
                                                          .data![index]
                                                          .id_transaction,
                                                      type: snapshot.data!
                                                          .data![index].type,
                                                      updatedAt: snapshot
                                                          .data!
                                                          .data![index]
                                                          .updated_at,
                                                      totalPayment: snapshot
                                                          .data!
                                                          .data![index]
                                                          .total_payment,
                                                      mediaQueryWidth:
                                                          mediaQueryWidth),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                        height: 10,
                                                      ));
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: ListView(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Lottie.asset(
                                                        'assets/img/lottie/no_transaction.json',
                                                        width: 200),
                                                    Text(
                                                      "Belum Ada Transaksi!",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 65,
                              child: SizedBox(
                                width:
                                    125, // Set the width and height according to your requirement
                                height: 125,
                                child:
                                    SvgPicture.asset("assets/img/svg/user.svg"),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('${jwtData?.name}',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Text(
                                'Bergabung Sejak: ${formatDateOnly(jwtData?.created_at)}',
                                style: GoogleFonts.poppins(fontSize: 14)),
                            const SizedBox(
                              height: 25,
                            ),
                            ButtonWidget(
                                buttonText: "Perbaharui Profile",
                                colorSetBody: Colors.blue.shade100,
                                colorSetText: Colors.black,
                                functionTap: () => {}),
                            const SizedBox(
                              height: 10,
                            ),
                            ButtonWidget(
                                buttonText: "Bantuan",
                                colorSetBody: Colors.blue.shade100,
                                colorSetText: Colors.black,
                                functionTap: () => {}),
                            const SizedBox(
                              height: 10,
                            ),
                            ButtonWidget(
                                buttonText: "Syarat & Ketentuan",
                                colorSetBody: Colors.blue.shade100,
                                colorSetText: Colors.black,
                                functionTap: () => {}),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ButtonWidget(
                                    buttonText: "Keluar",
                                    colorSetBody: Colors.red.shade100,
                                    colorSetText: Colors.black,
                                    functionTap: () => {}),
                              ],
                            ))
                          ],
                        ),
                      )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndexBottomNav,
          onTap: (index) {
            setState(() {
              _selectedIndexBottomNav = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
            if (_selectedIndexBottomNav == 1 &&
                _selectedIndexTab == 0 &&
                _futureDataTransactionFinish == null &&
                _futureDataTransactionOnProcess == null) {
              _futureDataTransactionFinish = fetchDataTransactionFinish();
              _futureDataTransactionOnProcess = fetchDataTransactionOnProcess();
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home_2),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.receipt_1),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_circle),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.blue.shade500,
        ),
      ),
    );
  }
}
