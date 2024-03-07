import 'package:app_pembayaran/Views/Widget/ButtonWidget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

    List _widgetOptions = [
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: bodyHeight * 0.13,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/img/logo.png"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
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
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 230,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return CardRFIDVirtual(mediaQueryWidth: mediaQueryWidth);
                  },
                  itemCount: 3,
                  itemWidth: mediaQueryWidth - 40,
                  itemHeight: 180,
                  layout: SwiperLayout.STACK,
                  scrollDirection: Axis.vertical,
                  axisDirection: AxisDirection.down,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.5),
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
                          functionTap: () => {}),
                    ),
                    SizedBox(
                      width: mediaQueryWidth / 2 - 30,
                      child: ButtonWidget(
                          buttonText: "Daftar Kartu",
                          colorSetBody: Colors.blue.shade100,
                          colorSetText: Colors.black,
                          functionTap: () => {}),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 130,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return CardBanner();
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
                        CardListTranasction(mediaQueryWidth: mediaQueryWidth),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.separated(
                    itemCount: 50,
                    itemBuilder: (context, index) =>
                        CardListTranasction(mediaQueryWidth: mediaQueryWidth),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        )),
              ),
              Center(
                child: Text("It's rainy here"),
              ),
            ],
          ),
        ),
      ),
      Text(
        'Index 2: School',
      ),
    ];

    return MaterialApp(
      title: "Home",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue.shade500,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class CardListTranasction extends StatelessWidget {
  const CardListTranasction({
    super.key,
    required this.mediaQueryWidth,
  });

  final double mediaQueryWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQueryWidth,
      margin: EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.blue.shade100,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/img/logo.png"),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pembayaran",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            "01 Mar 2024",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "-Rp.5.000",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            "Uang Keluar",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardBanner extends StatelessWidget {
  const CardBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.blue.shade100,
        image: DecorationImage(
          image: NetworkImage(
              "https://images.tokopedia.net/img/cache/1208/NsjrJu/2024/3/5/71ceb9ec-a589-4faa-b0b4-769956548964.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CardRFIDVirtual extends StatelessWidget {
  const CardRFIDVirtual({
    super.key,
    required this.mediaQueryWidth,
  });

  final double mediaQueryWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.5),
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
              "Kartu Pembayaran",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.rotate(
                  angle: 90 * (3.14 / 180),
                  child: Icon(
                    Iconsax.wifi,
                    size: 25,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sisa Saldo",
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: Colors.black),
                      ),
                      Text(
                        "Rp. 10.000",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ]),
                Text(
                  "0xC660DC42xxxxxx",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
