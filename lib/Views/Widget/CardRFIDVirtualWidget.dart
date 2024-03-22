import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../Function/cutString.dart';
import '../../Function/formatToRupiah.dart';

class CardRFIDVirtualWidget extends StatelessWidget {
  const CardRFIDVirtualWidget({
    super.key,
    required this.mediaQueryWidth,
    required this.saldo,
    this.walletAddress,
  });

  final String? walletAddress;
  final double mediaQueryWidth;
  final int saldo;

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
                  child: const Icon(
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
                        formatToRupiah(saldo),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ]),
                walletAddress != null
                    ? Text(
                        cutString(walletAddress!),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    : SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
