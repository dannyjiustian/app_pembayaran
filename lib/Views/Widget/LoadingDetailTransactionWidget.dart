import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'BlankContainerWidget.dart';

class LoadingDetailTransactionWidget extends StatelessWidget {
  const LoadingDetailTransactionWidget({
    super.key,
    required this.mediaQueryWidth,
  });

  final double mediaQueryWidth;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Column(children: [
          const SizedBox(height: 30),
          const BlankContainerWidget(borderRadius: 10, width: 150, height: 150),
          const SizedBox(height: 20),
          const BlankContainerWidget(width: 150, height: 25),
          const SizedBox(height: 10),
          const BlankContainerWidget(width: 250, height: 15),
          const SizedBox(height: 10),
          const BlankContainerWidget(width: 100, height: 35),
          const SizedBox(height: 20),
          BlankContainerWidget(width: mediaQueryWidth, height: 15),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 70, height: 15),
                BlankContainerWidget(width: 50, height: 15),
              ]),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 50, height: 15),
                BlankContainerWidget(width: 75, height: 15),
              ]),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 40, height: 15),
                BlankContainerWidget(width: 60, height: 15),
              ]),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 30, height: 15),
                BlankContainerWidget(width: 80, height: 15),
              ]),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 45, height: 15),
                BlankContainerWidget(width: 60, height: 15),
              ]),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 30, height: 15),
                BlankContainerWidget(width: 50, height: 15),
              ]),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 25, height: 15),
                BlankContainerWidget(width: 40, height: 15),
              ]),
          const SizedBox(height: 10),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlankContainerWidget(width: 40, height: 15),
                BlankContainerWidget(width: 70, height: 15),
              ]),
          const SizedBox(height: 10),
          BlankContainerWidget(width: mediaQueryWidth, height: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlankContainerWidget(
                    borderRadius: 10, width: mediaQueryWidth, height: 50),
              ],
            ),
          ),
        ]));
  }
}
