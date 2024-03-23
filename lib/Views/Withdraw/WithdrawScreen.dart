import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Function/formatDateFullLimit.dart';
import '../../Function/formatToRupiah.dart';
import '../../Models/CreateTransaction/CreateTransaction.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../SuccessScreen/SuccessScreen.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/LoadingWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class WithdrawScreen extends StatefulWidget {
  WithdrawScreen({
    super.key,
    required this.balance,
    required this.idOutlet,
    required this.updatedAt,
    required this.typeDetect,
    this.refreshToken,
  });

  final int typeDetect, balance;
  final VoidCallback? refreshToken;
  final String updatedAt, idOutlet;

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _WithdrawScreenState extends State<WithdrawScreen> {
  Connection conn = Connection();
  final _formKey = GlobalKey<FormState>();

  final amount = TextEditingController();

  bool _loading = false;

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  @override
  void initState() {
    super.initState();
    checkLocalStorage().then((value) {
      setState(() {
        jwtData =
            JWTDecode.fromJson(JWT.decode(accessToken.toString()).payload);
      });
    });
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
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 180,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Saldo",
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Terakhir Perbaharui",
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: Colors.black),
                                ),
                                Text(
                                  formatDateFullLimit(widget.updatedAt),
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ]),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: SizedBox(
                height: bodyHeight * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldInputWidget(
                      nameController: amount,
                      label: "Jumlah Penarikan",
                      obscureCondition: false,
                      keyboardNext: false,
                      keyboard: true,
                      keyboardType: true,
                      typeInput: TextInputType.number,
                      formatRupiah: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _loading
                        ? const LoadingWidget()
                        : ButtonWidget(
                            buttonText: "Tarik Saldo",
                            colorSetBody: Colors.blue,
                            colorSetText: Colors.white,
                            functionTap: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                int amountValue =
                                    int.parse(amount.text.replaceAll(".", ""));
                                if (widget.balance <= amountValue) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: 'Oops...',
                                    text: 'Jumlah Penarikan Melebihi Saldo!',
                                  );
                                  return;
                                }
                                setState(() {
                                  _loading = true;
                                });

                                CreateTransaction data = CreateTransaction(
                                    id_user: jwtData!.id_user,
                                    type: "2",
                                    total_payment:
                                        amount.text.replaceAll(".", ""),
                                    status: "Selesai");
                                var res1 = await conn.createTransaction(
                                    accessToken!, data.toJson());

                                int amountNew = widget.balance - amountValue;
                                var res2 = await conn.updateOutlet(accessToken!,
                                    widget.idOutlet, amountNew.toString());

                                setState(() {
                                  _loading = false;
                                });
                                if (res1.status && res2.status) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SuccessScreen(
                                              refreshToken: widget.refreshToken,
                                              typeDetect: widget.typeDetect,
                                            )),
                                  );
                                }
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Oops...',
                                  text:
                                      'Harap isi input field yang diperlukan!',
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
