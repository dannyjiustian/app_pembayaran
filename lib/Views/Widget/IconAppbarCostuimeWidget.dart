import 'package:flutter/material.dart';

class IconAppbarCustomWidget extends StatelessWidget {
  IconAppbarCustomWidget(
      {super.key, required this.iconType, required this.functionTap});

  final IconData iconType;
  final Function() functionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.grey.shade300),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: functionTap,
          child: Ink(
            child: Icon(
              iconType,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
