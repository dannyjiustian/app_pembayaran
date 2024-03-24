import 'package:app_pembayaran/Function/formatDateOnly.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/Connection.dart';
import '../../Function/cutString.dart';
import '../../Models/UpdateReader/UpdateReaderString.dart';
import 'IconAppbarCostuimeWidget.dart';
import 'TextFieldInputWidget.dart';

class ListReaderWidget extends StatefulWidget {
  ListReaderWidget({
    super.key,
    required this.idHardware,
    required this.nameReader,
    required this.isActive,
    required this.snReader,
    required this.createdAt,
    required this.updatedAt,
    required this.transactionLength,
    required this.refreshData,
  });

  final String idHardware, nameReader, snReader, createdAt, updatedAt;
  final bool isActive;
  final int transactionLength;
  final VoidCallback? refreshData;

  @override
  State<ListReaderWidget> createState() => _ListReaderWidgetState();
}

String? accessToken;

class _ListReaderWidgetState extends State<ListReaderWidget> {
  Connection conn = Connection();
  bool isActive = false;
  String? readerNameTmp;

  final readerName = TextEditingController();

  Future checkLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString('accessToken');
  }

  @override
  void initState() {
    super.initState();
    checkLocalStorage();
    isActive = widget.isActive;
    readerNameTmp = widget.nameReader;
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
                            cutString(readerNameTmp!, cut: 15, change: "..."),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            isActive ? "Nyala" : "Mati",
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
                            iconType: Iconsax.info_circle,
                            backgroundColor: Colors.indigo.shade500,
                            iconColor: Colors.white,
                            functionTap: () async {
                              readerName.text = readerNameTmp!;
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.custom,
                                barrierDismissible: true,
                                confirmBtnText: 'Simpan Perubahan',
                                customAsset: 'assets/img/gif/questions.gif',
                                widget: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Serial Number",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            )),
                                        Text(widget.snReader,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Status Reader",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            )),
                                        Text(isActive ? "Nyala" : "Mati",
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
                                        Text(
                                            "${widget.transactionLength} Transaksi",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFieldInputWidget(
                                      nameController: readerName,
                                      label: "Nama Reader",
                                      obscureCondition: false,
                                      keyboardNext: true,
                                      keyboard: false,
                                    ),
                                  ],
                                ),
                                onConfirmBtnTap: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if (readerName.text == readerNameTmp) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      title: 'Oops...',
                                      text: 'Tidak ada perubahan data!',
                                    );
                                    return;
                                  }
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.loading,
                                    title: 'Loading',
                                    text: 'Proses Update Reader, Mohon Tunggu!',
                                    barrierDismissible: false,
                                  );
                                  UpdateReaderString data = UpdateReaderString(
                                      is_active: isActive.toString(),
                                      name: readerName.text);
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
                                      text: "Nama Reader diubah",
                                      barrierDismissible: false,
                                    ).then((value) {
                                      setState(() {
                                        readerNameTmp = res!.data!.name;
                                      });
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
                            iconType: Icons.power_settings_new,
                            backgroundColor: Colors.indigo.shade500,
                            iconColor: Colors.white,
                            functionTap: () async {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title: "Kamu Yakin?",
                                text:
                                    "${isActive ? "Matikan" : "Hidukan"} Reader",
                                cancelBtnText: 'Tidak',
                                confirmBtnText: 'Iya',
                                customAsset: 'assets/img/gif/questions.gif',
                                confirmBtnColor: Colors.indigo.shade500,
                                onConfirmBtnTap: () async {
                                  UpdateReaderString data = UpdateReaderString(
                                      is_active: isActive ? "false" : "true");
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
                                      setState(() {
                                        isActive = res!.data!.is_active;
                                      });
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
                            functionTap: () async {
                              if (widget.transactionLength < 1) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  title: "Kamu Yakin?",
                                  text: "Menghapus Reader",
                                  cancelBtnText: 'Tidak',
                                  confirmBtnText: 'Iya',
                                  customAsset: 'assets/img/gif/delete.gif',
                                  confirmBtnColor: Colors.red,
                                  onConfirmBtnTap: () async {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.loading,
                                      title: 'Loading',
                                      text:
                                          'Proses Hapus Reader, Mohon Tunggu!',
                                      barrierDismissible: false,
                                    );
                                    var res = await conn.deleteHardware(
                                        accessToken!, widget.idHardware);

                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    if (mounted && res!.status) {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        title: "Berhasil",
                                        text: "Reader Dihapus!",
                                        barrierDismissible: false,
                                      ).then((value) {
                                        widget.refreshData!();
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
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Oops...',
                                  text:
                                      'Tidak Hapus Reader, Karena Ada ${widget.transactionLength} Transaksi Terhubung!',
                                );
                              }
                            },
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
