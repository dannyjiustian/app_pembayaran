import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../Connection/Connection.dart';
import '../../Function/cutString.dart';
import '../../Function/formatDateFull.dart';
import '../../Function/formatDateOnly.dart';
import '../../Function/formatTime.dart';
import '../../Function/formatToRupiah.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';

class DetailTransaksiScreen extends StatefulWidget {
  const DetailTransaksiScreen({
    super.key,
    required this.idTransaction,
  });

  final String idTransaction;

  @override
  State<DetailTransaksiScreen> createState() => _DetailTransaksiScreenState();
}

class _DetailTransaksiScreenState extends State<DetailTransaksiScreen> {
  Connection conn = Connection();
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
      title: "Detail Transaksi",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
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
                  future:
                      conn.getTransasctionByIDTransaction(widget.idTransaction),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Show loading indicator while fetching data
                    } else {
                      if (snapshot.data.data != null) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            SvgPicture.asset(
                              "assets/img/svg/${snapshot.data!.data.status == "Selesai" ? "success_transaction" : snapshot.data!.data.status == "Batal" ? "error_transaction" : "process_transaction"}.svg",
                              width: 150,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                                formatToRupiah(
                                    snapshot.data!.data.total_payment,
                                    type: snapshot.data!.data.type),
                                style: GoogleFonts.poppins(
                                    fontSize: 24, fontWeight: FontWeight.w600)),
                            Text(formatDateFull(snapshot.data!.data.updated_at),
                                style: GoogleFonts.poppins(fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(color: Colors.grey.shade300),
                                color: snapshot.data!.data.status == "Selesai"
                                    ? Colors.blue.shade100
                                    : snapshot.data!.data.status == "Batal"
                                        ? Colors.red.shade100
                                        : Colors.amber.shade100,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                child: Text(snapshot.data!.data.status,
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
                                            snapshot.data!.data.id_transaction,
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
                                                text: snapshot
                                                    .data!.data.id_transaction))
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
                                Text("ID Mesin",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        cutString(
                                            snapshot.data!.data.id_hardware,
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
                                                text: snapshot
                                                    .data!.data.id_hardware))
                                            .then((_) {
                                          Fluttertoast.showToast(
                                            msg: 'ID Mesin Tersalin',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        });
                                      },
                                      child:
                                          Icon(Iconsax.document_copy, size: 20),
                                    )
                                  ],
                                ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID Toko",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        cutString(snapshot.data!.data.id_outlet,
                                            cut: 13, change: "..."),
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                                text: snapshot
                                                    .data!.data.id_outlet))
                                            .then((_) {
                                          Fluttertoast.showToast(
                                            msg: 'ID Toko Tersalin',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        });
                                      },
                                      child:
                                          Icon(Iconsax.document_copy, size: 20),
                                    )
                                  ],
                                ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("TXN Hash",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                snapshot.data!.data.txn_hash != null
                                    ? Expanded(
                                        child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              cutString(
                                                  snapshot.data!.data.txn_hash,
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
                                                      text: snapshot
                                                          .data!.data.txn_hash))
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
                                            child: Icon(Iconsax.document_copy,
                                                size: 20),
                                          )
                                        ],
                                      ))
                                    : snapshot.data!.data.status == "On Proses"
                                        ? Text("Menunggu Selesai",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))
                                        : Text("Transaksi Batal",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
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
                                        snapshot.data!.data.updated_at),
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
                                Text(formatTime(snapshot.data!.data.updated_at),
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
                                        snapshot.data!.data.total_payment,
                                        type: snapshot.data!.data.type),
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
                            snapshot.data!.data.status == "Selesai"
                                ? Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ButtonWidget(
                                          buttonText: "Etherscan Blockchain",
                                          colorSetBody: Colors.blue,
                                          colorSetText: Colors.white,
                                          functionTap: () async {},
                                        ),
                                      ],
                                    ),
                                  )
                                : snapshot.data!.data.status == "On Proses"
                                    ? Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ButtonWidget(
                                              buttonText: "Batalkan Transaksi",
                                              colorSetBody: Colors.blue,
                                              colorSetText: Colors.white,
                                              functionTap: () async {},
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                          ],
                        );
                      } else {
                        return const Text("null");
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
