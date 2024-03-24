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
import '../../Models/ListReader/ListReader.dart';
import '../Auth/LoginScreen.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/ListReaderWidget.dart';
import '../Widget/LoadingListTransactionWidget.dart';
import 'FormPairScreen.dart';

class ListReaderScreen extends StatefulWidget {
  ListReaderScreen({
    super.key,
    required this.navigatorKey,
    required this.typeDetect,
    this.refreshToken,
  });

  final int typeDetect;
  final VoidCallback? refreshToken;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<ListReaderScreen> createState() => _ListReaderScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _ListReaderScreenState extends State<ListReaderScreen> {
  Connection conn = Connection();
  Future<ListReader>? _futureDataReader;

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
    widget.refreshToken!();
  }

  Future<ListReader> fetchDataReader() async {
    ListReader data =
        await conn.getReaderByIDUser(accessToken!, jwtData!.id_user);
    detectAndRefreshData(data);
    return data;
  }

  Future<void> refreshData() async {
    setState(() {
      _futureDataReader = fetchDataReader();
      print("old ${accessToken}");
    });
  }

  @override
  void initState() {
    super.initState();
    checkLocalStorage().then((value) {
      setState(() {
        jwtData =
            JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
      });
      _futureDataReader = fetchDataReader();
    });
    _futureDataReader =
        Future.value(ListReader(status: false, message: "Waiting data!"));
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
        widget.refreshToken!();
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
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 3),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FormPairScreen()));
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          strokeWidth: 2,
                          dashPattern: const [6, 3, 6, 3],
                          color: Colors.grey.shade500,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              height: 130,
                              width: mediaQueryWidth - 50,
                              color: Colors.blue.shade50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Iconsax.add_square,
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Tambah Reader Baru",
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
                    ),
                    FutureBuilder(
                        future: _futureDataReader,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: LoadingListTransactionsWidget(
                                  mediaQueryWidth: mediaQueryWidth),
                            );
                          } else {
                            if (snapshot.data!.status) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder: (context, index) =>
                                          ListReaderWidget(
                                            idHardware: snapshot
                                                .data!.data![index].id_hardware,
                                            nameReader: snapshot
                                                .data!.data![index].name,
                                            isActive: snapshot
                                                .data!.data![index].is_active,
                                            snReader: snapshot
                                                .data!.data![index].sn_sensor,
                                            createdAt: snapshot
                                                .data!.data![index].created_at,
                                            updatedAt: snapshot
                                                .data!.data![index].updated_at,
                                            transactionLength: snapshot
                                                .data!
                                                .data![index]
                                                .transactions
                                                .length,
                                            refreshData: refreshData,
                                          ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            height: 10,
                                          )));
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                        'assets/img/lottie/no_transaction.json',
                                        width: 200),
                                    Text(
                                      "Belum Ada Mesin Reader!",
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
                        })
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
