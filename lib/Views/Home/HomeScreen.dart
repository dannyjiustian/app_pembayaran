import 'package:card_swiper/card_swiper.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Models/JWT/JWTDecode.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  Connection conn = Connection();
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();

    accessToken = pref.getString('accessToken');
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
              _selectedIndex = index;
            });
          },
          children: [
            SingleChildScrollView(
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
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/img/logo.png"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${jwtData?.name} 👋",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
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
                      future: conn.getCardByID("${jwtData?.id_user}"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingCardRFIDVirtualWidget(
                            mediaQueryWidth: mediaQueryWidth,
                          ); // Show loading indicator while fetching data
                        } else {
                          if (snapshot.data.data != null) {
                            return SizedBox(
                              height: 230,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardRFIDVirtualWidget(
                                      idCard:
                                          snapshot.data!.data[index].id_card,
                                      saldo: snapshot.data!.data[index].balance,
                                      walletAddress: snapshot
                                          .data!.data[index].wallet_address,
                                      mediaQueryWidth: mediaQueryWidth,
                                    );
                                  },
                                  itemCount: snapshot.data!.data.length,
                                  itemWidth: mediaQueryWidth - 40,
                                  itemHeight: 180,
                                  layout: SwiperLayout.STACK,
                                  scrollDirection: Axis.vertical,
                                  axisDirection: AxisDirection.down,
                                  loop: snapshot.data!.data.length > 1
                                      ? true
                                      : false,
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
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
                            );
                          }
                        }
                      }),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: mediaQueryWidth / 2 - 30,
                            child: ButtonWidget(
                                buttonText: "Top Up",
                                colorSetBody: Colors.blue.shade100,
                                colorSetText: Colors.black,
                                functionTap: () async {
                                  // var res =
                                  //     await conn.getTransasctionByIDWithLimit(
                                  //         "a270e97f-ca5e-4547-be7d-25ee71f18824",
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
                      future: conn.getTransasctionByIDWithLimit(
                          "${jwtData?.id_user}",
                          take: 5),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            child: LoadingListTransactionsWidget(
                                mediaQueryWidth: mediaQueryWidth),
                          ); // Show loading indicator while fetching data
                        } else {
                          if (snapshot.data.data != null) {
                            return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.data.length,
                                    itemBuilder: (context, index) =>
                                        CardListTranasctionWidget(
                                            type:
                                                snapshot.data!.data[index].type,
                                            updatedAt: snapshot
                                                .data!.data[index].updated_at,
                                            totalPayment: snapshot.data!
                                                .data[index].total_payment,
                                            mediaQueryWidth: mediaQueryWidth),
                                    separatorBuilder: (context, index) =>
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
            DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Scaffold(
                appBar: TabBar(
                    labelColor: Colors.blue.shade500,
                    unselectedLabelColor: Colors.grey.shade500,
                    tabs: [
                      Tab(
                          child: Text(
                        'Selesai',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )),
                      Tab(
                          child: Text('On Proses',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w600))),
                    ]),
                body: TabBarView(
                  children: <Widget>[
                    ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: 50,
                        itemBuilder: (context, index) =>
                            CardListTranasctionWidget(
                                type: 0,
                                updatedAt: "",
                                totalPayment: 0,
                                mediaQueryWidth: mediaQueryWidth),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            )),
                    ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                            CardListTranasctionWidget(
                                type: 0,
                                updatedAt: "",
                                totalPayment: 0,
                                mediaQueryWidth: mediaQueryWidth),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/img/logo.png"),
                    radius: 65,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Budi Susanto',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('Bergabung Sejak: 01 Jan 2024',
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
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
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
