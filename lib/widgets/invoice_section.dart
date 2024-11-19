import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_generator_app/app_theme.dart';
import 'package:invoice_generator_app/models/invoice_item_model.dart';
import 'package:invoice_generator_app/providers/invoice_section_provider.dart';
import 'package:invoice_generator_app/widgets/mtext_field.dart';
import 'package:provider/provider.dart';

class InvoiceSection extends StatefulWidget {
  final ScrollController scrollController;
  const InvoiceSection({super.key, required this.scrollController});

  @override
  State<InvoiceSection> createState() => _InvoiceSectionState();
}

class _InvoiceSectionState extends State<InvoiceSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.primary,
          padding: const EdgeInsets.all(8.0),
          child: invoiceSectionHeader(),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: context.watch<InvoiceSectionProvider>().items.length,
          itemBuilder: (context, index) {
            final item = context.read<InvoiceSectionProvider>().items[index];
            return itemRow(index, item);
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<InvoiceSectionProvider>().addItem();
            },
            label: const Text("add item"),
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Row itemRow(int index, InvoiceItem item) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: MTextFieldUnderLine(
              onChanged:
                  context.read<InvoiceSectionProvider>().changeDescription,
              hintText: item.description,
              index: index),
        ),
        Expanded(
          flex: 1,
          child: MTextFieldUnderLine(
              onChanged: context.read<InvoiceSectionProvider>().changeQuantity,
              hintText: item.quantity.toString(),
              index: index),
          // child: TextField(
          //   onChanged: (value) => context
          //       .read<InvoiceSectionProvider>()
          //       .changeQuantity(index, value),
          //   decoration: InputDecoration(
          //     hintText: item.quantity.toString(),
          //   ),
          // ),
        ),
        Expanded(
          flex: 1,
          child: MTextFieldUnderLine(
              onChanged: context.read<InvoiceSectionProvider>().changeUnit,
              hintText: item.unit,
              index: index),
        ),
        Expanded(
          flex: 1,
          child: MTextFieldUnderLine(
              onChanged: context.read<InvoiceSectionProvider>().changePrice,
              hintText: item.price.toStringAsFixed(2),
              index: index),
        ),
        Expanded(
          flex: 1,
          child: MTextFieldUnderLine(
              onChanged: context.read<InvoiceSectionProvider>().changeTax,
              hintText: item.tax.toStringAsFixed(2),
              index: index),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              context.read<InvoiceSectionProvider>().deleteItem(index);
            },
            child: Container(
              color: Colors.redAccent,
              child: Text(
                item.total.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppTheme.light,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row invoiceSectionHeader() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            textAlign: TextAlign.center,
            "Description",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, color: AppTheme.light),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            textAlign: TextAlign.center,
            "Qty",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, color: AppTheme.light),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            textAlign: TextAlign.center,
            "Unit",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, color: AppTheme.light),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            textAlign: TextAlign.center,
            "Price",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, color: AppTheme.light),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            textAlign: TextAlign.center,
            "Tax",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, color: AppTheme.light),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            textAlign: TextAlign.center,
            "Total",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, color: AppTheme.light),
          ),
        ),
      ],
    );
  }
}
