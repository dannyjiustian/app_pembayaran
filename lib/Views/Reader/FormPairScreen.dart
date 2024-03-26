import 'dart:io';

import 'package:async/async.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Models/CreateRaader/CreateReader.dart';
import '../../Models/JWT/JWTDecode.dart';
import '../../ScannerQRCode/ScannerQRCodeScreen.dart';
import '../SuccessScreen/SuccessScreen.dart';
import '../Widget/AlertWidget.dart';
import '../Widget/ButtonWidget.dart';
import '../Widget/IconAppbarCostuimeWidget.dart';
import '../Widget/LoadingWidget.dart';
import '../Widget/TextFieldInputWidget.dart';

class FormPairScreen extends StatefulWidget {
  FormPairScreen({super.key, this.refreshToken, this.refreshCallback});

  final VoidCallback? refreshToken, refreshCallback;

  @override
  State<FormPairScreen> createState() => _FormPairScreenState();
}

JWTDecode? jwtData;
String? accessToken;

class _FormPairScreenState extends State<FormPairScreen> {
  Connection conn = Connection();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final provisioner = Provisioner.espTouch();
  final info = NetworkInfo();
  final _formKey = GlobalKey<FormState>();
  CancelableOperation? cancelDelayAndSmartConfig;
  bool _loadESPTouch = false, _loading = false;
  String ssid = "", bssid = "";
  var permissionStatus;

  final serialNumberController = TextEditingController();
  final wifiController = TextEditingController();
  final passwordController = TextEditingController();

  Future<PermissionStatus> checkPermissionLocation() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
      PermissionWithService locationPermission = Permission.locationWhenInUse;

      permissionStatus = await locationPermission.status;
      if (build.version.sdkInt >= 28) {
        if (permissionStatus == PermissionStatus.denied ||
            permissionStatus == PermissionStatus.permanentlyDenied) {
          permissionStatus = await locationPermission.request();
        }
      }
    }
    return permissionStatus; // Return permissionStatus value
  }

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  Future<void> ScannerQRCodeScreenPush(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerQRCodeScreen()),
    );
    if (!mounted) return;
    serialNumberController.text = result ?? "";
  }

  Future getWiFiInfo() async {
    ssid = await info.getWifiName() as String;
    bssid = await info.getWifiBSSID() as String;
  }

  Future setDelayConfigESP() async {
    await Future.delayed(const Duration(seconds: 30));
  }

  @override
  void initState() {
    super.initState();
    checkPermissionLocation().then((status) {
      setState(() {
        permissionStatus =
            status; // Update permissionStatus with the returned value
      });
    });
    getWiFiInfo().then((value) {
      ssid = ssid.split('"')[1];
      wifiController.text = ssid;

      provisioner.listen((response) {
        _loadESPTouch = true;
        cancelDelayAndSmartConfig?.cancel();
      });
    });
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
              child: (permissionStatus == PermissionStatus.granted)
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/img/svg/pairing.svg",
                            width: 150,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: bodyHeight * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Waktunya Pairing Reader Baru Nih",
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Isi semua data yang diperlukan!",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Container(
                              height: bodyHeight * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFieldInputWidget(
                                    nameController: serialNumberController,
                                    label: "Serial Number Reader",
                                    obscureCondition: false,
                                    keyboardNext: true,
                                    keyboard: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFieldInputWidget(
                                    nameController: wifiController,
                                    label: "Nama WiFi",
                                    obscureCondition: false,
                                    keyboardNext: true,
                                    keyboard: false,
                                    enabledField: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFieldInputWidget(
                                    nameController: passwordController,
                                    label: "Password WiFi",
                                    obscureCondition: true,
                                    keyboardNext: false,
                                    keyboard: true,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ButtonWidget(
                                      buttonText: "Scan QR Code Serial Number",
                                      colorSetBody: Colors.indigo,
                                      colorSetText: Colors.white,
                                      functionTap: () =>
                                          {ScannerQRCodeScreenPush(context)}),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ButtonWidget(
                                    buttonText: "Pairing",
                                    colorSetBody: Colors.blue,
                                    colorSetText: Colors.white,
                                    functionTap: () async {
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.loading,
                                          title: 'Loading',
                                          text:
                                              'Proses Pairing Hardware dan Simpan Data, Mohon Tunggu!',
                                          barrierDismissible: false,
                                        );
                                        try {
                                          await provisioner.start(
                                              ProvisioningRequest.fromStrings(
                                                  ssid: ssid,
                                                  bssid: bssid,
                                                  password:
                                                      passwordController.text));
                                          cancelDelayAndSmartConfig =
                                              CancelableOperation.fromFuture(
                                            setDelayConfigESP(),
                                            onCancel: () => provisioner.stop(),
                                          );
                                          await setDelayConfigESP();
                                        } catch (e) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          AlertWidget(
                                                  mediaQueryWidth,
                                                  Iconsax.close_square,
                                                  Colors.red.shade300,
                                                  "Error SmartConfig",
                                                  "${e}")
                                              .show(context);
                                        }
                                        provisioner.stop();
                                        if (_loadESPTouch) {
                                          CreateReader data = CreateReader(
                                              id_user: jwtData!.id_user,
                                              name: "New Reader",
                                              sn_sensor:
                                                  serialNumberController.text,
                                              is_active: "false");
                                          var res = await conn.createHardware(
                                              accessToken!, data.toJson());
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          if (res!.status) {
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              title: "Berhasil",
                                              text:
                                                  "Perangkat Berhasil Ditambahkan!",
                                              barrierDismissible: false,
                                            ).then((value) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SuccessScreen(
                                                          refreshCallback: widget
                                                              .refreshCallback,
                                                          refreshToken: widget
                                                              .refreshToken,
                                                          typeDetect: 4,
                                                        )),
                                              );
                                            });
                                          } else {
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              title: 'Oops...',
                                              text:
                                                  'Terjadi kesalahan, silakan coba lagi!',
                                            );
                                          }
                                        } else {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.error,
                                            title: 'Oops...',
                                            text:
                                                'Tidak bisa pairing dikarenakan tidak ada reader terdeteksi!',
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
                          Container(
                            height: bodyHeight * 0.1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  "*Harap memasukkan Serial Number Reader yang benar!, Pastikan juga WiFi yang digunakan berfrekuenzi 2.4GHz serta juga telah terkoneksi dengan ponsel, [JANGAN UBAH NAMA WIFI SUDAH AUTO DETECT!]",
                                  style: GoogleFonts.poppins(fontSize: 11),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/img/lottie/device_error.json'),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Belum Memberikan Akses Lokasi untuk Mendapatkan Nama Wifi!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Apabila masih belum bisa memberikan akses, silakan lakukan secara manual!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _loading
                            ? const LoadingWidget()
                            : ButtonWidget(
                                buttonText: "Coba Lagi",
                                colorSetBody: Colors.blue.shade100,
                                colorSetText: Colors.black,
                                functionTap: () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  await checkPermissionLocation()
                                      .then((status) {
                                    setState(() {
                                      permissionStatus =
                                          status; // Update permissionStatus with the returned value
                                    });
                                  });
                                  setState(() {
                                    _loading = false;
                                  });
                                }),
                      ],
                    )),
        ]),
      ),
    );
  }
}
