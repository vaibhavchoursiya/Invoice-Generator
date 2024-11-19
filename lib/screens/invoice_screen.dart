import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_generator_app/app_theme.dart';
import 'package:invoice_generator_app/providers/invoice_header_provider.dart';
import 'package:invoice_generator_app/providers/invoice_info_section_provider.dart';
import 'package:invoice_generator_app/providers/invoice_section_provider.dart';
import 'package:invoice_generator_app/widgets/invoice_company_info.dart';
import 'package:invoice_generator_app/widgets/invoice_header.dart';
import 'package:invoice_generator_app/widgets/invoice_section.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final total = context
        .select<InvoiceSectionProvider, double>((provider) => provider.total);
    final subTotalValue = context.select<InvoiceSectionProvider, double>(
        (provider) => provider.subTotalValue);
    final taxValue = context.select<InvoiceSectionProvider, double>(
        (provider) => provider.taxValue);

    return Scaffold(
      backgroundColor: AppTheme.dark,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        centerTitle: true,
        title: Text(
          "Invoice generator",
          style: GoogleFonts.aDLaMDisplay(
            color: AppTheme.light,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            size.width * 0.10,
            size.width * 0.03,
            size.width * 0.10,
            size.width * 0.03,
          ),
          child: Column(
            children: [
              InvoiceHeader(
                onTap: context.read<InvoiceHeaderProvider>().filePicker,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: InvoiceCompanyInfo(
                        label: "From",
                        whois: "Your",
                        companyName: context
                            .read<InvoiceInfoSectionProvider>()
                            .fromCompanyNameController,
                        name: context
                            .read<InvoiceInfoSectionProvider>()
                            .fromNameController,
                        gstin: context
                            .read<InvoiceInfoSectionProvider>()
                            .fromGSTINNameController,
                        address: context
                            .read<InvoiceInfoSectionProvider>()
                            .fromAddressController,
                        city: context
                            .read<InvoiceInfoSectionProvider>()
                            .fromCityController,
                        state: context
                            .read<InvoiceInfoSectionProvider>()
                            .fromStateController,
                        email: context
                            .read<InvoiceInfoSectionProvider>()
                            .fromEmailController),
                  ),
                  // SizedBox(
                  //   width: size.width * 0.07,
                  // ),
                  const Spacer(),
                  Expanded(
                    child: InvoiceCompanyInfo(
                        label: "Bill To",
                        companyName: context
                            .read<InvoiceInfoSectionProvider>()
                            .billToCompanyNameController,
                        name: context
                            .read<InvoiceInfoSectionProvider>()
                            .billToNameController,
                        gstin: context
                            .read<InvoiceInfoSectionProvider>()
                            .billToGSTINNameController,
                        address: context
                            .read<InvoiceInfoSectionProvider>()
                            .billToAddressController,
                        city: context
                            .read<InvoiceInfoSectionProvider>()
                            .billToCityController,
                        state: context
                            .read<InvoiceInfoSectionProvider>()
                            .billToStateController,
                        email: context
                            .read<InvoiceInfoSectionProvider>()
                            .billToEmailController),
                  ),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              InvoiceSection(
                scrollController: scrollController,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SubTotal: ${subTotalValue.toStringAsFixed(2)}",
                        style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 106, 196, 152),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Tax: ${taxValue.toStringAsFixed(2)}",
                        style: GoogleFonts.roboto(
                            color: Colors.red,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Total:$total",
                        style: GoogleFonts.roboto(
                            color: AppTheme.light,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.light),
                          onPressed: () {
                            context
                                .read<InvoiceSectionProvider>()
                                .calulateTotalForItems();
                          },
                          child: Text(
                            "Total",
                            style: GoogleFonts.roboto(fontSize: 25.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  generatePDF(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.light,
                    foregroundColor: AppTheme.dark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                label: Text(
                  "PDF",
                  style: GoogleFonts.aDLaMDisplay(),
                ),
                icon: const Icon(Icons.picture_as_pdf),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future generatePDF(BuildContext context) async {
    final invoiceHeaderProvider = context.read<InvoiceHeaderProvider>();
    final invoiceInfoSectionProvider =
        context.read<InvoiceInfoSectionProvider>();
    final invoiceSectionProvider = context.read<InvoiceSectionProvider>();
    if (invoiceHeaderProvider.file == null) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Image is Required")));
    }
    final image = pw.MemoryImage(
      File(invoiceHeaderProvider.file!.path).readAsBytesSync(),
    );
    final invoiceNumber = invoiceHeaderProvider.invoiceNumberController.text;

    final invoiceDate = invoiceHeaderProvider.invoiceDateController.text;

    final fromComapyName = invoiceInfoSectionProvider.fromCompanyNameController;
    final fromName = invoiceInfoSectionProvider.fromNameController;
    final fromGSTIN = invoiceInfoSectionProvider.fromGSTINNameController;
    final fromAddress = invoiceInfoSectionProvider.fromAddressController;
    final fromCity = invoiceInfoSectionProvider.fromCityController;
    final fromState = invoiceInfoSectionProvider.fromStateController;
    final fromEmail = invoiceInfoSectionProvider.fromEmailController;

    final billToComapyName =
        invoiceInfoSectionProvider.billToCompanyNameController;
    final billToName = invoiceInfoSectionProvider.billToNameController;
    final billToGSTIN = invoiceInfoSectionProvider.billToGSTINNameController;
    final billToAddress = invoiceInfoSectionProvider.billToAddressController;
    final billToCity = invoiceInfoSectionProvider.billToCityController;
    final billToState = invoiceInfoSectionProvider.billToStateController;
    final billToEmail = invoiceInfoSectionProvider.billToEmailController;

    final Directory document = await getApplicationDocumentsDirectory();
    final font = await PdfGoogleFonts.latoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                image,
                width: 100,
                height: 100,
              ),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Invoice Number: $invoiceNumber",
                        style: pw.TextStyle(
                          font: font,
                        )),
                    pw.SizedBox(height: 2.0),
                    pw.Text("Date: $invoiceDate",
                        style: pw.TextStyle(
                          font: font,
                        )),
                  ]),
            ],
          ),
          pw.SizedBox(height: 30.0),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "From",
                        style: pw.TextStyle(
                          font: fontBold,
                        ),
                      ),
                      pw.Text(
                        "Company name: ${fromComapyName.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Name: ${fromName.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "GSTIN: ${fromGSTIN.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Address: ${fromAddress.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "City: ${fromCity.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "State: ${fromState.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Email: ${fromEmail.text}",
                        style: pw.TextStyle(font: font),
                      ),
                    ]),
              ),
              pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Bill To",
                        style: pw.TextStyle(
                            font: fontBold, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "Client's company: ${billToComapyName.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Client's Name: ${billToName.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Client's GSTIN: ${billToGSTIN.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Client's Address: ${billToAddress.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "City: ${billToCity.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "State: ${billToState.text}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Email: ${billToEmail.text}",
                        style: pw.TextStyle(font: font),
                      ),
                    ]),
              ),
            ],
          ),
          pw.SizedBox(height: 20.0),
          pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.black,
                width: 2.0,
              ),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Description',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Qty',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Unit',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Price',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Tax',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Total',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ]),
                ...List.generate(invoiceSectionProvider.items.length, (index) {
                  final item = invoiceSectionProvider.items[index];
                  return pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        item.description,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        item.quantity.toString(),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        item.unit,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        item.price.toStringAsFixed(2),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        item.tax.toStringAsFixed(2),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        item.total.toStringAsFixed(2),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ]);
                })
              ]),
          pw.SizedBox(height: 20.0),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10.0),
                color: PdfColors.blueAccent,
                child: pw.Text(
                  "Total: ${invoiceSectionProvider.total}",
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 24.0,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ],
          ),
        ];
      },
    ));

    String documentPath = document.path;
    File file = File("$documentPath/invoice$invoiceNumber.pdf");

    Uint8List pdfData = await pdf.save();

    await file.writeAsBytes(pdfData);

    await OpenFile.open(file.path);
  }
}
