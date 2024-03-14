import 'package:flutter/material.dart';

class CardAlertCustomWidget extends StatelessWidget {
  const CardAlertCustomWidget(
      {super.key, required this.bodyHeight, required this.bodyScreen});

  final double bodyHeight;
  final Widget bodyScreen;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)), //this right here
      child: Stack(children: [
        Container(
          height: bodyHeight,
          margin: EdgeInsets.only(top: 13.0, right: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: bodyScreen,
          ),
        ),
        Positioned(
          right: 0.0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.close,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
