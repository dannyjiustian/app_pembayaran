import 'package:flutter/material.dart';

class CardBannerWidget extends StatefulWidget {
  CardBannerWidget({
    super.key,
    required this.imageFile,
  });

  final String imageFile;

  @override
  State<CardBannerWidget> createState() => _CardBannerWidgetState();
}

class _CardBannerWidgetState extends State<CardBannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.shade100,
        image: DecorationImage(
          image: AssetImage(widget.imageFile),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
