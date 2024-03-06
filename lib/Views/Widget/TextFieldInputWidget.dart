import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldInputWidget extends StatelessWidget {
  const TextFieldInputWidget(
      {super.key,
      this.nameController,
      required this.label,
      required this.obscureCondition,
      required this.keyboardNext,
      required this.keyboard,
      this.enabledField = true});

  final String label;
  final bool obscureCondition, keyboardNext, keyboard;
  final bool? enabledField;
  final TextEditingController? nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          enabled: enabledField,
          controller: nameController,
          textInputAction:
              (keyboardNext) ? TextInputAction.next : TextInputAction.done,
          style: GoogleFonts.poppins(fontSize: 13),
          keyboardType:
              (!keyboard) ? TextInputType.emailAddress : TextInputType.text,
          obscureText: obscureCondition,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "${label}",
            errorStyle: TextStyle(height: 0),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "";
            }
          },
        ),
      ),
    );
  }
}
