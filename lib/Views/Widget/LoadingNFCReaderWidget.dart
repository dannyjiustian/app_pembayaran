import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'BlankContainerWidget.dart';

class LoadingNFCReaderWidget extends StatelessWidget {
  const LoadingNFCReaderWidget({
    super.key,
    required this.mediaQueryWidth,
  });

  final double mediaQueryWidth;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 30),
          const BlankContainerWidget(borderRadius: 10, width: 150, height: 150),
          const SizedBox(height: 20),
          const BlankContainerWidget(width: 150, height: 25),
          const SizedBox(height: 10),
          const BlankContainerWidget(width: 250, height: 25),
          const SizedBox(height: 10),
          const BlankContainerWidget(width: 100, height: 35),
        ]));
  }
}
