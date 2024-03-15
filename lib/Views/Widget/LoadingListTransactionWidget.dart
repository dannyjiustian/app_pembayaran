import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'ListTransactionLoadingWidget.dart';

class LoadingListTransactionsWidget extends StatelessWidget {
  const LoadingListTransactionsWidget({
    super.key,
    required this.mediaQueryWidth,
  });

  final double mediaQueryWidth;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) =>
                ListTransactionLoadingWidget(mediaQueryWidth: mediaQueryWidth),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                )));
  }
}
