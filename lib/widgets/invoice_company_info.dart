import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_generator_app/app_theme.dart';
import 'package:invoice_generator_app/widgets/mtext_field.dart';

class InvoiceCompanyInfo extends StatelessWidget {
  final String whois;
  final TextEditingController companyName;
  final TextEditingController name;
  final TextEditingController gstin;
  final TextEditingController address;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController email;

  final String label;
  const InvoiceCompanyInfo(
      {super.key,
      this.whois = "Client's",
      required this.companyName,
      required this.name,
      required this.gstin,
      required this.address,
      required this.city,
      required this.state,
      required this.email,
      required this.label});

  @override
  Widget build(BuildContext context) {
    final align = (whois == "Client's") ? TextAlign.right : TextAlign.left;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: GoogleFonts.aDLaMDisplay(
            fontWeight: FontWeight.bold,
            // fontSize: 24.0,
            color: AppTheme.light,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        MtextField(
          align: align,
          controller: companyName,
          hintText: "$whois Company",
          onChanged: null,
        ),
        const SizedBox(
          height: 15.0,
        ),
        MtextField(
          align: align,
          controller: name,
          hintText: "$whois Name",
          onChanged: null,
        ),
        const SizedBox(
          height: 15.0,
        ),
        MtextField(
          align: align,
          controller: gstin,
          hintText: "$whois Company GSTIN",
          onChanged: null,
        ),
        const SizedBox(
          height: 15.0,
        ),
        MtextField(
          align: align,
          controller: address,
          hintText: "$whois Address",
          onChanged: null,
        ),
        const SizedBox(
          height: 15.0,
        ),
        MtextField(
          align: align,
          controller: city,
          hintText: "City",
          onChanged: null,
        ),
        const SizedBox(
          height: 15.0,
        ),
        MtextField(
          align: align,
          controller: state,
          hintText: "State",
          onChanged: null,
        ),
        const SizedBox(
          height: 15.0,
        ),
        MtextField(
          align: align,
          controller: email,
          hintText: "Email",
          onChanged: null,
        ),
      ],
    );
  }
}
