import 'package:flutter/material.dart';

class CardRFIDVirtualLoadingWidget extends StatelessWidget {
  const CardRFIDVirtualLoadingWidget({
    super.key,
    required this.mediaQueryWidth,
  });

  final double mediaQueryWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaQueryWidth,
      child: Card(
          elevation: 10,
          color: Colors.grey.shade300,
          shadowColor: Colors.black12,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                )
              ],
            ),
          )),
    );
  }
}
