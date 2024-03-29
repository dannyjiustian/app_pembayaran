import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Function/cutString.dart';
import '../../Function/formatToRupiah.dart';
import 'ButtonWidget.dart';

class CardRFIDVirtualWidget extends StatelessWidget {
  const CardRFIDVirtualWidget({
    super.key,
    required this.mediaQueryWidth,
    required this.saldo,
    this.walletAddress,
    this.balanceEth,
  });

  final String? walletAddress;
  final double mediaQueryWidth;
  final int saldo;
  final double? balanceEth;

  Future<void> _launchInBrowser(String urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kartu Pembayaran",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                balanceEth != null
                    ? Row(
                        children: [
                          Text(
                            "Ketuk Untuk Info",
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.black),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.custom,
                                barrierDismissible: true,
                                confirmBtnText: 'Tutup',
                                showConfirmBtn: false,
                                customAsset: 'assets/img/gif/info.gif',
                                widget: Column(
                                  children: [
                                    Text(
                                      "Detail Etherium Wallet",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Wallet Address",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                cutString(walletAddress!,
                                                    change: "..."),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                        text: walletAddress!))
                                                    .then((_) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'Wallet Address Tersalin',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
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
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Saldo ETH",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            )),
                                        Text(
                                            "${cutString(balanceEth!.toString(), cut: 7, change: "")} ETH",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Tambah Saldo Etherium",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ButtonWidget(
                                        buttonText: "Alchamy Faucet",
                                        colorSetBody: Colors.blue,
                                        colorSetText: Colors.white,
                                        functionTap: () {
                                          _launchInBrowser(
                                              "https://www.alchemy.com/faucets/ethereum-sepolia");
                                        }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ButtonWidget(
                                        buttonText: "PoW Faucet",
                                        colorSetBody: Colors.blue,
                                        colorSetText: Colors.white,
                                        functionTap: () {
                                          _launchInBrowser(
                                              "https://sepolia-faucet.pk910.de/");
                                        })
                                  ],
                                ),
                                onConfirmBtnTap: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              );
                            },
                            child: const Icon(
                              Iconsax.info_circle,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.rotate(
                  angle: 90 * (3.14 / 180),
                  child: const Icon(
                    Iconsax.wifi,
                    size: 25,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
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
                        formatToRupiah(saldo),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      balanceEth != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sisa Saldo ETH",
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: Colors.black),
                                ),
                                Text(
                                  '${cutString(balanceEth!.toString(), cut: 7, change: "")} ETH',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            )
                          : const SizedBox()
                    ]),
                walletAddress != null
                    ? Text(
                        cutString(walletAddress!),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
