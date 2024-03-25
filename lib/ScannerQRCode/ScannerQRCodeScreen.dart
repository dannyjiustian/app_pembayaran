import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';

class ScannerQRCodeScreen extends StatefulWidget {
  const ScannerQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerQRCodeScreenState();
}

class _ScannerQRCodeScreenState extends State<ScannerQRCodeScreen> {
  Barcode? result;
  QRViewController? controller;
  IconData icon = Iconsax.flash_slash5;
  bool checkValidData = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool isHexWithLessThan12Digits(String code) {
    // Define a regular expression pattern to match a hexadecimal string with exactly 12 characters
    RegExp regex = RegExp(r'^[0-9a-fA-F]{12}$');
    // Check if the code matches the pattern
    return regex.hasMatch(code);
  }

  // Method to handle the scanned result
  void handleScanResult(BuildContext context) {
    Vibration.vibrate(duration: 250, amplitude: 32);
    controller?.pauseCamera();
    if (result != null &&
        describeEnum(result!.format) == "qrcode" &&
        isHexWithLessThan12Digits(result!.code!)) {
      Navigator.pop(context, result!.code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serial Number Tidak Valid!, Start Lagi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                _buildQrView(context),
                Positioned(
                  left: 20,
                  top: 40,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              icon: const Icon(
                                Iconsax.arrow_left_2,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 50,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              icon: Icon(
                                icon,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () async {
                                await controller?.toggleFlash();
                                await controller?.getFlashStatus().then(
                                    (value) => (value == true)
                                        ? icon = Iconsax.flash_15
                                        : icon = Iconsax.flash_slash5);
                                setState(() {});
                              }),
                        ),
                        !checkValidData
                            ? Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: IconButton(
                                        icon: const Icon(
                                          Iconsax.play,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        onPressed: () async {
                                          controller?.resumeCamera();
                                          setState(() {
                                            checkValidData = true;
                                          });
                                        }),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        checkValidData = isHexWithLessThan12Digits(result!.code!);
      });
      handleScanResult(context);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need Camera Permission!')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
