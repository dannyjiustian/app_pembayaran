import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final numericRegex = RegExp(r'\D');
    final unformatted = newValue.text.replaceAll(numericRegex, '');

    // Remove leading zeros
    final trimmedValue = unformatted.replaceFirst(RegExp('^0+'), '');

    final formatted = StringBuffer();
    for (int i = 0; i < trimmedValue.length; i++) {
      if (i != 0 && (trimmedValue.length - i) % 3 == 0) {
        formatted.write('.');
      }
      formatted.write(trimmedValue[i]);
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class TextFieldInputWidget extends StatelessWidget {
  const TextFieldInputWidget(
      {super.key,
      this.nameController,
      required this.label,
      required this.obscureCondition,
      required this.keyboardNext,
      required this.keyboard,
      this.enabledField = true,
      this.keyboardType = false,
      this.formatRupiah = false,
      this.typeInput});

  final String label;
  final bool obscureCondition, keyboardNext, keyboard;
  final bool? enabledField, keyboardType, formatRupiah;
  final TextEditingController? nameController;
  final TextInputType? typeInput;

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters =
        formatRupiah == true ? [NumberInputFormatter()] : [];
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
          keyboardType: (!keyboard)
              ? TextInputType.emailAddress
              : ((keyboardType == true) ? typeInput : TextInputType.text),
          obscureText: obscureCondition,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "${label}",
            errorStyle: TextStyle(height: 0),
          ),
          inputFormatters: inputFormatters,
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
