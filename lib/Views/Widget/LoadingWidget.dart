import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CircularProgressIndicator(),
          ),
          Text(
            "Loading...",
            style:
                GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
