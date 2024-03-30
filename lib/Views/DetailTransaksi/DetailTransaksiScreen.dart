import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Connection/Connection.dart';
import '../../Function/cutString.dart';
import '../../Function/formatDateFull.dart';
import '../../Function/formatDateOnly.dart';
import '../../Function/formatTime.dart';
import '../../Function/formatToRupiah.dart';
import '../../Models/DetailTransaction/DetailTransaction.dart';
import '../Auth/LoginScreen.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/LoadingDetailTransactionWidget.dart';

class DetailTransaksiScreen extends StatefulWidget {
  const DetailTransaksiScreen({
    super.key,
    required this.idTransaction,
    required this.status,
    this.refreshToken,
    this.refreshCallback,
    required this.navigatorKey,
    required this.role,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String idTransaction, status, role;
  final VoidCallback? refreshToken, refreshCallback;

  @override
  State<DetailTransaksiScreen> createState() => _DetailTransaksiScreenState();
}

String? accessToken;

class _DetailTransaksiScreenState extends State<DetailTransaksiScreen> {
  Connection conn = Connection();
  Future<DetailTransaction>? _futureDataDetailTransaction;

  Future<void> _launchInBrowser(String urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  Future<DetailTransaction> fetchDataDetailTransaction() async {
    DetailTransaction data = await conn.getTransasctionByIDTransaction(
        accessToken!, widget.idTransaction,
        status: widget.status == "On Proses" ? false : true);
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
    setState(() {
      checkLocalStorage();
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    checkLocalStorage().then((value) {
      setState(() {
        _futureDataDetailTransaction = fetchDataDetailTransaction();
        print("sadasds ${accessToken}");
      });
    });

    // Initialize _futureDataDetailTransaction with Future.value
    _futureDataDetailTransaction = Future.value(
        DetailTransaction(status: false, message: "Waiting data!"));
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
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
            Expanded(
              child: FutureBuilder(
                  future: _futureDataDetailTransaction,
                  builder: (contextFuture, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingDetailTransactionWidget(
                          mediaQueryWidth:
                              mediaQueryWidth); // Show loading indicator while fetching data
                    } else {
                      if (snapshot.data!.status) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            SvgPicture.asset(
                              "assets/img/svg/${snapshot.data!.data!.status == "Selesai" ? "success_transaction" : snapshot.data!.data!.status == "Batal" ? "error_transaction" : "process_transaction"}.svg",
                              width: 150,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                                formatToRupiah(
                                    snapshot.data!.data!.total_payment,
                                    type: snapshot.data!.data!.type,
                                    role: widget.role),
                                style: GoogleFonts.poppins(
                                    fontSize: 24, fontWeight: FontWeight.w600)),
                            Text(
                                formatDateFull(snapshot.data!.data!.updated_at),
                                style: GoogleFonts.poppins(fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(color: Colors.grey.shade300),
                                color: snapshot.data!.data!.status == "Selesai"
                                    ? Colors.blue.shade100
                                    : snapshot.data!.data!.status == "Batal"
                                        ? Colors.red.shade100
                                        : Colors.amber.shade100,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                child: Text(snapshot.data!.data!.status,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const DottedLine(
                              direction: Axis.horizontal,
                              lineThickness: 2,
                              dashLength: 6.0,
                              dashColor: Colors.black,
                              dashGapLength: 3.0,
                              dashGapColor: Colors.transparent,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tipe Transaksi",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    snapshot.data!.data!.type == 0
                                        ? "Pembayaran"
                                        : snapshot.data!.data!.type == 1
                                            ? "Top Up"
                                            : snapshot.data!.data!.type == 2
                                                ? "Penarikan Dana"
                                                : "",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID Transaksi",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        cutString(
                                            snapshot.data!.data!.id_transaction,
                                            cut: 13,
                                            change: "..."),
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                                text: snapshot.data!.data!
                                                    .id_transaction))
                                            .then((_) {
                                          Fluttertoast.showToast(
                                            msg: 'ID Transaksi Tersalin',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        });
                                      },
                                      child: const Icon(Iconsax.document_copy,
                                          size: 20),
                                    )
                                  ],
                                ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID Kartu",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                snapshot.data!.data!.id_card != null
                                    ? Expanded(
                                        child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              cutString(
                                                  snapshot.data!.data!.id_card!,
                                                  cut: 13,
                                                  change: "..."),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: snapshot.data!.data!
                                                          .id_card!))
                                                  .then((_) {
                                                Fluttertoast.showToast(
                                                  msg: 'ID Transaksi Tersalin',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              });
                                            },
                                            child: const Icon(
                                                Iconsax.document_copy,
                                                size: 20),
                                          )
                                        ],
                                      ))
                                    : Text(
                                        snapshot.data!.data!.type == 0
                                            ? "Pembayaran ${snapshot.data!.data!.status}"
                                            : snapshot.data!.data!.type == 1
                                                ? "Pembayaran ${snapshot.data!.data!.status}"
                                                : snapshot.data!.data!.type == 2
                                                    ? "Penarikan Dana"
                                                    : "",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID Mesin",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                snapshot.data!.data!.id_hardware != null
                                    ? Expanded(
                                        child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              cutString(
                                                  snapshot
                                                      .data!.data!.id_hardware!,
                                                  cut: 13,
                                                  change: "..."),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: snapshot.data!.data!
                                                          .id_hardware!))
                                                  .then((_) {
                                                Fluttertoast.showToast(
                                                  msg: 'ID Mesin Tersalin',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              });
                                            },
                                            child: const Icon(
                                                Iconsax.document_copy,
                                                size: 20),
                                          )
                                        ],
                                      ))
                                    : Text(
                                        snapshot.data!.data!.type == 0
                                            ? "Pembayaran ${snapshot.data!.data!.status}"
                                            : snapshot.data!.data!.type == 1
                                                ? widget.role == "3"
                                                    ? "Pembayaran ${snapshot.data!.data!.status}"
                                                    : "Transaksi NFC"
                                                : snapshot.data!.data!.type == 2
                                                    ? "Penarikan Dana"
                                                    : "",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID Toko",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                snapshot.data!.data!.id_outlet != null
                                    ? Expanded(
                                        child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              cutString(
                                                  snapshot
                                                      .data!.data!.id_outlet!,
                                                  cut: 13,
                                                  change: "..."),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: snapshot.data!.data!
                                                          .id_outlet!))
                                                  .then((_) {
                                                Fluttertoast.showToast(
                                                  msg: 'ID Toko Tersalin',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              });
                                            },
                                            child: const Icon(
                                                Iconsax.document_copy,
                                                size: 20),
                                          )
                                        ],
                                      ))
                                    : Text(
                                        snapshot.data!.data!.type == 1
                                            ? "Transaksi NFC"
                                            : snapshot.data!.data!.type == 2
                                                ? "Penarikan Dana"
                                                : "",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("TXN Hash",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                snapshot.data!.data!.txn_hash != null
                                    ? Expanded(
                                        child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              cutString(
                                                  snapshot
                                                      .data!.data!.txn_hash!,
                                                  cut: 13,
                                                  change: "..."),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: snapshot.data!.data!
                                                          .txn_hash!))
                                                  .then((_) {
                                                Fluttertoast.showToast(
                                                  msg: 'TXN Hash Tersalin',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              });
                                            },
                                            child: const Icon(
                                                Iconsax.document_copy,
                                                size: 20),
                                          )
                                        ],
                                      ))
                                    : Text(
                                        snapshot.data!.data!.status ==
                                                "On Proses"
                                            ? "Menunggu Selesai"
                                            : "Pembayaran Batal",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tanggal",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    formatDateOnly(
                                        snapshot.data!.data!.updated_at),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Waktu",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    formatTime(snapshot.data!.data!.updated_at),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    formatToRupiah(
                                        snapshot.data!.data!.total_payment,
                                        type: snapshot.data!.data!.type,
                                        role: widget.role),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const DottedLine(
                              direction: Axis.horizontal,
                              lineThickness: 2,
                              dashLength: 6.0,
                              dashColor: Colors.black,
                              dashGapLength: 3.0,
                              dashGapColor: Colors.transparent,
                            ),
                            snapshot.data!.data!.status == "Selesai"
                                ? Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ButtonWidget(
                                          buttonText:
                                              "Check Validasi Transaksi",
                                          colorSetBody: Colors.blue,
                                          colorSetText: Colors.white,
                                          functionTap: () async {
                                            QuickAlert.show(
                                              context: contextFuture,
                                              type: QuickAlertType.loading,
                                              title: 'Loading',
                                              text:
                                                  'Proses Validasi Transaksi, Mohon Tunggu!',
                                              barrierDismissible: false,
                                            );
                                            var res = await conn.validateTxHash(
                                                accessToken!,
                                                snapshot.data!.data!.txn_hash!);
                                            Navigator.of(contextFuture,
                                                    rootNavigator: true)
                                                .pop();
                                            if (res!.status) {
                                              QuickAlert.show(
                                                context: contextFuture,
                                                type: QuickAlertType.success,
                                                title: "Berhasil",
                                                text:
                                                    "Transaksi Sama Dengan Blockchain!",
                                              );
                                            } else {
                                              QuickAlert.show(
                                                context: contextFuture,
                                                type: QuickAlertType.error,
                                                title: 'Oops...',
                                                text:
                                                    'Transaksi Tidak Sama Dengan Blockchain!, Coba Lagi!',
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ButtonWidget(
                                          buttonText: "Etherscan Blockchain",
                                          colorSetBody: Colors.blue,
                                          colorSetText: Colors.white,
                                          functionTap: () {
                                            _launchInBrowser(
                                                "https://sepolia.etherscan.io/tx/${snapshot.data!.data!.txn_hash}");
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : snapshot.data!.data!.status == "On Proses"
                                    ? Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ButtonWidget(
                                              buttonText: "Batalkan Transaksi",
                                              colorSetBody: Colors.blue,
                                              colorSetText: Colors.white,
                                              functionTap: () async {
                                                QuickAlert.show(
                                                  context: contextFuture,
                                                  type: QuickAlertType.confirm,
                                                  title: "Kamu Yakin?",
                                                  text:
                                                      "Transaksi akan dibatalkan",
                                                  cancelBtnText: 'Tidak',
                                                  confirmBtnText: 'Iya',
                                                  customAsset:
                                                      'assets/img/gif/delete.gif',
                                                  confirmBtnColor: Colors.red,
                                                  onConfirmBtnTap: () async {
                                                    Navigator.of(contextFuture,
                                                            rootNavigator: true)
                                                        .pop();
                                                    QuickAlert.show(
                                                      context: contextFuture,
                                                      type: QuickAlertType
                                                          .loading,
                                                      title: 'Loading',
                                                      text:
                                                          'Proses Batalkan Transaksi, Mohon Tunggu!',
                                                      barrierDismissible: false,
                                                    );
                                                    var res = await conn
                                                        .cancelTransaction(
                                                            accessToken!,
                                                            snapshot.data!.data!
                                                                .id_transaction);
                                                    Navigator.of(contextFuture,
                                                            rootNavigator: true)
                                                        .pop();
                                                    if (mounted &&
                                                        res!.status) {
                                                      QuickAlert.show(
                                                        context: contextFuture,
                                                        type: QuickAlertType
                                                            .success,
                                                        title: "Berhasil",
                                                        text:
                                                            "Transaksi Dibatalkan",
                                                        barrierDismissible:
                                                            false,
                                                      ).then((value) {
                                                        widget.refreshCallback
                                                            ?.call();
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    } else {
                                                      QuickAlert.show(
                                                        context: contextFuture,
                                                        type: QuickAlertType
                                                            .error,
                                                        title: 'Oops...',
                                                        text:
                                                            'Terjadi kesalahan, silakan coba lagi!',
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                'assets/img/lottie/no_transaction.json',
                                width: 200),
                            Text(
                              "Transaksi Tidak Ditemukan!",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text(
                              "Silakan Muat Ulang Halaman",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        );
                      }
                    }
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
