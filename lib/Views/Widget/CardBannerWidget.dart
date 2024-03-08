import 'package:flutter/material.dart';

class CardBannerWidget extends StatelessWidget {
  const CardBannerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.blue.shade100,
        image: const DecorationImage(
          image: NetworkImage(
              "https://images.tokopedia.net/img/cache/1208/NsjrJu/2024/3/5/71ceb9ec-a589-4faa-b0b4-769956548964.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
