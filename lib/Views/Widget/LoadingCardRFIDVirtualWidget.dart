import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'CardRFIDVirtualLoadingWidget.dart';

class LoadingCardRFIDVirtualWidget extends StatelessWidget {
  const LoadingCardRFIDVirtualWidget({
    super.key,
    required this.mediaQueryWidth,
  });

  final double mediaQueryWidth;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: CardRFIDVirtualLoadingWidget(mediaQueryWidth: mediaQueryWidth),
    );
  }
}
