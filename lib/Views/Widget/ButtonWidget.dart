import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.buttonText,
      required this.colorSetBody,
      required this.colorSetText,
      required this.functionTap});
  final String buttonText;
  final Color colorSetBody, colorSetText;
  final Function() functionTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: functionTap,
      child: Ink(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
              color: colorSetBody, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              "${buttonText}",
              style: GoogleFonts.poppins(
                  color: colorSetText, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}