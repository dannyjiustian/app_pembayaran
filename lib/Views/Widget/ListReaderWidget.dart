import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Function/cutString.dart';
import '../../Models/UpdateReader/UpdateReaderString.dart';
import 'IconAppbarCostuimeWidget.dart';

class ListReaderWidget extends StatefulWidget {
  ListReaderWidget({
    super.key,
    required this.idHardware,
    required this.nameReader,
    required this.isActive,
    required this.snReader,
    required this.updatedAt,
  });

  final String idHardware, nameReader, snReader, updatedAt;
  final bool isActive;

  @override
  State<ListReaderWidget> createState() => _ListReaderWidgetState();
}

String? accessToken;

class _ListReaderWidgetState extends State<ListReaderWidget> {
  Connection conn = Connection();

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  @override
  void initState() {
    super.initState();
    checkLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.blue.shade100),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cutString(widget.nameReader,
                                cut: 20, change: "..."),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            widget.isActive ? "Nyala" : "Mati",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconAppbarCustomWidget(
                            iconType: Icons.power_settings_new,
                            backgroundColor: Colors.indigo.shade500,
                            iconColor: Colors.white,
                            functionTap: () async {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title: "Kamu Yakin?",
                                text: "Matikan Reader",
                                cancelBtnText: 'Tidak',
                                confirmBtnText: 'Iya',
                                customAsset: 'assets/img/gif/questions.gif',
                                confirmBtnColor: Colors.indigo.shade500,
                                onConfirmBtnTap: () async {
                                  UpdateReaderString data = UpdateReaderString(
                                      is_active:
                                          widget.isActive ? "false" : "true");
                                  var res = await conn.updateReader(
                                      accessToken!,
                                      widget.idHardware,
                                      data.toJson());
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if (mounted && res!.status) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      title: "Berhasil",
                                      text: "Status diubah",
                                      barrierDismissible: false,
                                    ).then((value) {
                                      // Navigator.of(context).pop();
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
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconAppbarCustomWidget(
                            iconType: Iconsax.trash,
                            backgroundColor: Colors.indigo.shade500,
                            iconColor: Colors.white,
                            functionTap: () async {},
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
    );
  }
}
