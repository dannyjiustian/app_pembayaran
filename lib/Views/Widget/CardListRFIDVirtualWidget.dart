import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Connection/Connection.dart';
import '../../Function/cutString.dart';
import '../../Function/formatDateOnly.dart';
import '../../Function/formatToRupiah.dart';
import 'ButtonWidget.dart';
import 'IconAppbarCostuimeWidget.dart';

class CardListRFIDVirtualCard extends StatefulWidget {
  CardListRFIDVirtualCard({
    super.key,
    required this.mediaQueryWidth,
    required this.idCard,
    required this.walletAddress,
    required this.balance,
    required this.balanceEth,
    required this.createdAt,
    required this.transactionLength,
    required this.isActive,
    required this.refreshData,
  });

  final double mediaQueryWidth, balanceEth;
  final int balance, transactionLength;
  final String idCard, walletAddress, createdAt;
  final bool isActive;
  final VoidCallback refreshData;

  @override
  State<CardListRFIDVirtualCard> createState() =>
      _CardListRFIDVirtualCardState();
}

String? accessToken;

class _CardListRFIDVirtualCardState extends State<CardListRFIDVirtualCard> {
  Connection conn = Connection();
  bool isActive = false;

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

  @override
  void initState() {
    super.initState();
    checkLocalStorage();
    isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.blue.shade100),
      width: widget.mediaQueryWidth,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cutString(widget.walletAddress),
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600)),
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
                        formatToRupiah(widget.balance),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Sisa Saldo ETH",
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: Colors.black),
                      ),
                      Text(
                        "${cutString(widget.balanceEth.toString(), cut: 7, change: "")} ETH",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconAppbarCustomWidget(
                      iconType: Iconsax.info_circle,
                      backgroundColor: Colors.indigo.shade500,
                      iconColor: Colors.white,
                      functionTap: () async {
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
                                "Detail Kartu Pembayaran",
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          cutString(widget.walletAddress,
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
                                                  text: widget.walletAddress))
                                              .then((_) {
                                            Fluttertoast.showToast(
                                              msg: 'Wallet Address Tersalin',
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
                                      "${cutString(widget.balanceEth.toString(), cut: 7, change: "")} ETH",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tanggal Daftar",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                      )),
                                  Text(formatDateOnly(widget.createdAt),
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Jumlah Transaksi",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                      )),
                                  Text("${widget.transactionLength} Transaksi",
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
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    IconAppbarCustomWidget(
                      iconType: Icons.power_settings_new,
                      backgroundColor: Colors.indigo.shade500,
                      iconColor: Colors.white,
                      functionTap: () async {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: "Kamu Yakin?",
                          text: "${isActive ? "Matikan" : "Hidupkan"} Kartu",
                          cancelBtnText: 'Tidak',
                          confirmBtnText: 'Iya',
                          customAsset: 'assets/img/gif/questions.gif',
                          confirmBtnColor: Colors.indigo.shade500,
                          onConfirmBtnTap: () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.loading,
                              title: 'Loading',
                              text:
                                  'Proses ${isActive ? "Matikan" : "Hidupkan"} Reader, Mohon Tunggu!',
                              barrierDismissible: false,
                            );
                            var res = await conn.updateCardActive(accessToken!,
                                widget.idCard, isActive ? "false" : "true");
                            Navigator.of(context, rootNavigator: true).pop();
                            if (mounted && res!.status) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                title: "Berhasil",
                                text: "Status Kartu diubah",
                                barrierDismissible: false,
                              ).then((value) {
                                setState(() {
                                  isActive = res!.data!.is_active;
                                });
                              });
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Terjadi kesalahan, silakan coba lagi!',
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    IconAppbarCustomWidget(
                      iconType: Iconsax.trash,
                      backgroundColor: Colors.indigo.shade500,
                      iconColor: Colors.white,
                      functionTap: () async {
                        if (widget.transactionLength < 1) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: "Kamu Yakin?",
                            text: "Menghapus Kartu",
                            cancelBtnText: 'Tidak',
                            confirmBtnText: 'Iya',
                            customAsset: 'assets/img/gif/delete.gif',
                            confirmBtnColor: Colors.red,
                            onConfirmBtnTap: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.loading,
                                title: 'Loading',
                                text: 'Proses Hapus Kartu, Mohon Tunggu!',
                                barrierDismissible: false,
                              );
                              var res = await conn.deleteCard(
                                  accessToken!, widget.idCard);

                              Navigator.of(context, rootNavigator: true).pop();
                              if (mounted && res!.status) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: "Berhasil",
                                  text: "Kartu Dihapus!",
                                  barrierDismissible: false,
                                ).then((value) {
                                  widget.refreshData();
                                });
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Oops...',
                                  text: 'Terjadi kesalahan, silakan coba lagi!',
                                );
                              }
                            },
                          );
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Oops...',
                            text:
                                'Tidak Hapus Kartu, Karena Ada ${widget.transactionLength} Transaksi Terhubung!',
                          );
                        }
                      },
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color:
                        isActive ? Colors.indigo.shade500 : Colors.red.shade500,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: Text(isActive ? "Hidup" : "Mati",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
