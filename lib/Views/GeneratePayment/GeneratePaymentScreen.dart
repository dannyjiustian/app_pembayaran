import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../MQTT/MQTT.dart';
import '../../Models/CreateTransaction/CreateTransaction.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../../Models/MQTTResponse/MQTTResponse.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class GeneratePaymentScreen extends StatefulWidget {
  GeneratePaymentScreen(
      {super.key,
      required this.idOutlet,
      required this.refreshToken,
      required this.typeAction});

  final String idOutlet;
  final VoidCallback refreshToken;
  final int typeAction;

  @override
  State<GeneratePaymentScreen> createState() => _GeneratePaymentScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _GeneratePaymentScreenState extends State<GeneratePaymentScreen> {
  Connection conn = Connection();
  MQTTClientWrapper mqttClient = MQTTClientWrapper();
  bool disconnectMqtt = false;
  final _formKey = GlobalKey<FormState>();

  final amount = TextEditingController();
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        try {
          mqttClient.client.disconnect();
        } catch (e) {}
        widget.refreshToken();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconAppbarCustomWidget(
                    iconType: Iconsax.arrow_left_2,
                    functionTap: () async {
                      try {
                        mqttClient.client.disconnect();
                      } catch (e) {}
                      widget.refreshToken();
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
            Lottie.asset(
                'assets/img/lottie/${widget.typeAction == 1 ? "shopping" : "topup"}.json',
                width: widget.typeAction == 1 ? 300 : 200),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  height: bodyHeight * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldInputWidget(
                        nameController: amount,
                        label:
                            "Jumlah ${widget.typeAction == 1 ? "Pembayaran" : "Top Up"}",
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
                      ButtonWidget(
                        buttonText:
                            "Proses ${widget.typeAction == 1 ? "Pembayaran" : "Top Up"}",
                        colorSetBody: Colors.blue,
                        colorSetText: Colors.white,
                        functionTap: () async {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState!.validate()) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.loading,
                              title: 'Loading',
                              text: 'Proses Pembuatan Transaksi!',
                              barrierDismissible: false,
                            );
                            CreateTransaction data = CreateTransaction(
                                id_user: jwtData!.id_user,
                                id_outlet: widget.idOutlet,
                                type: widget.typeAction == 1 ? "0" : "1",
                                total_payment: amount.text.replaceAll(".", ""));
                            var res = await conn.createTransaction(
                                accessToken!, data.toJson());
                            Navigator.of(context, rootNavigator: true).pop();
                            if (res!.status) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.loading,
                                title: 'Loading',
                                text: 'Koneksi Ke Reader!, Mohon Tunggu!',
                                barrierDismissible: false,
                              );
                              await mqttClient.prepareMqttClient(
                                  res!.data!.id_transaction, (String message) {
                                Map<String, dynamic> data = (json
                                    .decode(message) as Map<String, dynamic>);
                                MQTTResponse dataMqttRes =
                                    MQTTResponse.fromJson(data);
                                if (dataMqttRes.status) {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    mqttClient.client.disconnect();
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    title: "Berhasil",
                                    text:
                                        "Transaksi Selesai, Silakan Cek Dihistory!",
                                    barrierDismissible: false,
                                  ).then((value) {
                                    amount.text = "";
                                    checkLocalStorage();
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: dataMqttRes.message ==
                                            "Hardware Not Found"
                                        ? 'Status Reader Sedang Mati / Tidak Terdaftar!'
                                        : dataMqttRes.message ==
                                                "Card Not Found"
                                            ? 'Kartu Tidak Terdaftar!'
                                            : 'Saldo Kartu Kurang!',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              });
                              Navigator.of(context, rootNavigator: true).pop();
                              alertWaitingReaderOrCancel(context, res);
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Terjadi kesalahan, silakan coba lagi!',
                              );
                            }
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: 'Harap isi input field yang diperlukan!',
                            );
                          }
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const SuccessScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void alertWaitingReaderOrCancel(BuildContext context, res) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Menunggu Tapping Kartu di Reader!',
      barrierDismissible: false,
      showCancelBtn: true,
      cancelBtnText: "Batalkan Transaksi",
      onCancelBtnTap: () async {
        Navigator.of(context, rootNavigator: true).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          title: "Kamu Yakin?",
          text: "Transaksi akan dibatalkan",
          cancelBtnText: 'Tidak',
          confirmBtnText: 'Iya',
          customAsset: 'assets/img/gif/delete.gif',
          confirmBtnColor: Colors.red,
          barrierDismissible: false,
          onConfirmBtnTap: () async {
            Navigator.of(context, rootNavigator: true).pop();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              title: 'Loading',
              text: 'Proses Batalkan Transaksi, Mohon Tunggu!',
              barrierDismissible: false,
            );
            var res1 = await conn.cancelTransaction(
                accessToken!, res!.data!.id_transaction);
            Navigator.of(context, rootNavigator: true).pop();
            if (mounted && res1!.status) {
              mqttClient.client.disconnect();
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: "Berhasil",
                text: "Transaksi Dibatalkan",
                barrierDismissible: false,
              ).then((value) {
                amount.text = "";
                checkLocalStorage();
              });
            } else {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'Oops...',
                text: 'Terjadi kesalahan, silakan coba lagi!',
                barrierDismissible: false,
              ).then((value) {
                alertWaitingReaderOrCancel(context, res);
              });
            }
          },
          onCancelBtnTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            alertWaitingReaderOrCancel(context, res);
          },
        );
      },
    );
  }
}
