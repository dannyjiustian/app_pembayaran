import 'package:app_pembayaran/Views/DetailTransaksi/DetailTransaksiScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Function/formatDateOnly.dart';
import '../../Function/formatToRupiah.dart';

class CardListTransactionWidget extends StatelessWidget {
  const CardListTransactionWidget({
    super.key,
    required this.mediaQueryWidth,
    required this.type,
    required this.totalPayment,
    required this.updatedAt,
    required this.idTransaction,
    required this.status,
    required this.navigatorKey,
    required this.role,
    this.refreshToken,
    this.refreshCallback,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final double mediaQueryWidth;
  final int type, totalPayment;
  final String updatedAt, idTransaction, status, role;
  final VoidCallback? refreshToken, refreshCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailTransaksiScreen(
                navigatorKey: navigatorKey,
                idTransaction: idTransaction,
                status: status,
                refreshToken: refreshToken,
                refreshCallback: refreshCallback)));
      },
      child: Container(
        width: mediaQueryWidth,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
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
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      width: 48,
                      height: 48,
                      child: SvgPicture.asset(
                        "assets/img/svg/${status == "Selesai" ? "success" : status == "Batal" ? "error" : "process"}.svg",
                      ),
                    ),
                  ),
                  const SizedBox(
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
                              type == 0
                                  ? "Pembayaran"
                                  : type == 1
                                      ? "Top Up"
                                      : type == 2
                                          ? "Penarikan Dana"
                                          : "",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text(
                              formatDateOnly(updatedAt),
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatToRupiah(totalPayment, type: type),
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text(
                              type == 0
                                  ? role == "1"
                                      ? "Uang Keluar"
                                      : "Uang Masuk"
                                  : (type == 1)
                                      ? "Uang Masuk"
                                      : type == 2
                                          ? "Uang Keluar"
                                          : "",
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
      ),
    );
  }
}
