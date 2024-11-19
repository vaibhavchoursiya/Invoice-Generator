import 'package:flutter/material.dart';
import 'package:invoice_generator_app/providers/invoice_header_provider.dart';
import 'package:invoice_generator_app/providers/invoice_info_section_provider.dart';
import 'package:invoice_generator_app/providers/invoice_section_provider.dart';
import 'package:invoice_generator_app/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InvoiceHeaderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InvoiceInfoSectionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InvoiceSectionProvider(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
