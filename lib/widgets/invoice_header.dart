import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_generator_app/app_theme.dart';
import 'package:invoice_generator_app/providers/invoice_header_provider.dart';
import 'package:invoice_generator_app/widgets/mtext_field.dart';
import 'package:provider/provider.dart';
import 'package:widgets_easier/widgets_easier.dart';

class InvoiceHeader extends StatelessWidget {
  final VoidCallback onTap;
  const InvoiceHeader({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final file = context
        .select<InvoiceHeaderProvider, File?>((provider) => provider.file);
    return Row(
      children: [
        LogoPicker(onTap: onTap, file: file),
        const Spacer(),
        SizedBox(
          width: 250.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MtextField(
                hintText: "Invoice number",
                align: TextAlign.right,
                onChanged: null,
                controller: context
                    .read<InvoiceHeaderProvider>()
                    .invoiceNumberController,
              ),
              const SizedBox(
                height: 15.0,
              ),
              MtextField(
                hintText: "Date",
                align: TextAlign.right,
                onChanged: null,
                controller:
                    context.read<InvoiceHeaderProvider>().invoiceDateController,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class LogoPicker extends StatelessWidget {
  const LogoPicker({
    super.key,
    required this.onTap,
    required this.file,
  });

  final VoidCallback onTap;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: const ShapeDecoration(
              color: Color.fromARGB(97, 151, 147, 147),
              shape: DashedBorder(
                color: AppTheme.light,
                radius: 5.0,
                width: 1.2,
              ),
            ),
            child: (file == null)
                ? const Center(
                    child: Icon(
                      Icons.add,
                      color: AppTheme.primary,
                    ),
                  )
                : Image.file(
                    File(file!.path),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          "upload image",
          style: GoogleFonts.roboto(
              color: AppTheme.light.withOpacity(0.4),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
