import 'package:flutter/material.dart';

class ListTransactionLoadingWidget extends StatelessWidget {
  const ListTransactionLoadingWidget({
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
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                )
              ],
            ),
          )),
    );
  }
}
