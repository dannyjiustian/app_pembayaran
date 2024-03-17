import 'package:flutter/material.dart';

class BlankContainerWidget extends StatelessWidget {
  const BlankContainerWidget({
    super.key,
    this.borderRadius = 50,
    required this.height,
    required this.width,
  });

  final double borderRadius, height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.grey.shade300),
      width: width,
      height: height,
    );
  }
}