import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_generator_app/app_theme.dart';

class MtextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function? onChanged;
  final TextAlign align;
  const MtextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.light.withOpacity(0.7),
        width: 1.1,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );

    final focusBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.primary.withOpacity(0.7),
        width: 1.1,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );

    final style = GoogleFonts.aDLaMDisplay(
      fontWeight: FontWeight.w400,
      color: AppTheme.light.withOpacity(0.7),
      fontSize: 12.2,
    );
    return SizedBox(
      width: 280.0,
      height: 40.0,
      child: TextField(
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        textAlign: align,
        controller: controller,
        style: style,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: style,
          enabledBorder: border,
          errorBorder: border,
          focusedBorder: focusBorder,
          focusedErrorBorder: focusBorder,
          border: border,
        ),
      ),
    );
  }
}

class MTextFieldUnderLine extends StatelessWidget {
  final Function onChanged;
  final int index;
  final String hintText;
  const MTextFieldUnderLine(
      {super.key,
      required this.onChanged,
      required this.hintText,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.aDLaMDisplay(
      fontWeight: FontWeight.w400,
      color: AppTheme.light.withOpacity(0.7),
      fontSize: 12.2,
    );

    return TextField(
      textAlign: TextAlign.center,
      minLines: 1,
      maxLines: null,
      style: style,
      onChanged: (value) {
        onChanged(value, index);
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: style,
      ),
    );
  }
}
