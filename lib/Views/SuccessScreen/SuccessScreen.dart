import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Widget/ButtonWidget.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.typeDetect,
    this.refreshToken,
  });

  final int typeDetect;
  final VoidCallback? refreshToken;

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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        refreshToken!();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: appBar,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 60),
                  height: bodyHeight * 0.5,
                  child: Lottie.asset('assets/img/lottie/success.json'),
                ),
                Container(
                    height: bodyHeight * 0.3,
                    child: Column(
                      children: [
                        Text(
                          "Selamat Telah Melakukan ${typeDetect == 1 ? "Top Up!" : typeDetect == 2 ? "Daftar Kartu!" : typeDetect == 3 ? "Penarikan Dana" : "lain"}",
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          typeDetect == 1
                              ? "Saldo berhasil ditambahkan keakunmu, silakan kembali ke home untuk mengeceknya!"
                              : typeDetect == 2
                                  ? "Kartu Baru berhasil didaftarkan ke akun kamu!"
                                  : typeDetect == 3
                                      ? "Penarikan Dana telah berhasil!"
                                      : "lainnya",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          typeDetect == 1
                              ? "Untuk Melihat detail transaksi dapat ke menuu history."
                              : typeDetect == 2
                                  ? "Kembali ke Home untuk melihat kartu!"
                                  : typeDetect == 3
                                      ? "Saldo telah terpotong, lihat di home!"
                                      : "lainnya",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                Container(
                  height: bodyHeight * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonWidget(
                        buttonText: "Kembali",
                        colorSetBody: Colors.blue,
                        colorSetText: Colors.white,
                        functionTap: () {
                          refreshToken!();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
