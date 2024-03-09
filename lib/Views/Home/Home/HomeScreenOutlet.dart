import 'package:app_pembayaran/Views/Card/DetectCardScreen.dart';
import 'package:app_pembayaran/Views/Widget/ButtonWidget.dart';
import 'package:app_pembayaran/Views/Widget/CardRFIDVirtualWidget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../Widget/CardBannerWidget.dart';
import '../../Widget/CardListTransactionWidget.dart';
import '../../Withdraw/WithdrawScreen.dart';

class HomeScreenOutlet extends StatefulWidget {
  const HomeScreenOutlet({super.key});

  @override
  State<HomeScreenOutlet> createState() => _HomeScreenOutletState();
}

class _HomeScreenOutletState extends State<HomeScreenOutlet> {
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

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
                                "Hi, Budi 👋",
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: SizedBox(
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.blue.shade100),
                          width: mediaQueryWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Pendapatan",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Saldo",
                                            style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "Rp. 10.000",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ]),
                                    SizedBox(
                                      width: 130,
                                      child: ButtonWidget(
                                          buttonText: "Tarik Saldo",
                                          colorSetBody: Colors.indigo.shade500,
                                          colorSetText: Colors.white,
                                          functionTap: () => {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WithdrawScreen()))
                                              }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: [
                          ButtonWidget(
                              buttonText: "Tambah Reader Baru",
                              colorSetBody: Colors.blue.shade100,
                              colorSetText: Colors.black,
                              functionTap: () => {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetectCardScreen()))
                                  }),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonWidget(
                              buttonText: "Pembayaran",
                              colorSetBody: Colors.blue.shade100,
                              colorSetText: Colors.black,
                              functionTap: () => {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetectCardScreen()))
                                  }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) =>
                              CardListTranasctionWidget(
                                  mediaQueryWidth: mediaQueryWidth),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ))),
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
                                mediaQueryWidth: mediaQueryWidth),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            )),
                    ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                            CardListTranasctionWidget(
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
