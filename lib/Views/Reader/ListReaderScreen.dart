import 'package:app_pembayaran/Views/Reader/FormPairScreen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../Widget/IconAppbarCostuimeWidget.dart';

class ListReaderScreen extends StatefulWidget {
  const ListReaderScreen({super.key});

  @override
  State<ListReaderScreen> createState() => _ListReaderScreenState();
}

class _ListReaderScreenState extends State<ListReaderScreen> {
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
    return MaterialApp(
      title: "List Reader",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
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
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 3),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FormPairScreen()));
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        strokeWidth: 2,
                        dashPattern: const [6, 3, 6, 3],
                        color: Colors.grey.shade500,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            height: 130,
                            width: mediaQueryWidth - 50,
                            color: Colors.blue.shade50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Iconsax.add_square,
                                  size: 50,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Tambah Reader Baru",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      itemCount: 10,
                      itemBuilder: (context, index) => const ListReaderWidget(),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          )),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class ListReaderWidget extends StatelessWidget {
  const ListReaderWidget({
    super.key,
  });

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
                            "Reader 1234567890",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            "Nyala",
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
                            functionTap: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconAppbarCustomWidget(
                            iconType: Iconsax.trash,
                            functionTap: () async {
                              Navigator.of(context).pop();
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
