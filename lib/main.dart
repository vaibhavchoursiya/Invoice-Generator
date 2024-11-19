import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator_app/providers/invoice_header_provider.dart';
import 'package:invoice_generator_app/providers/invoice_info_section_provider.dart';
import 'package:invoice_generator_app/providers/invoice_section_provider.dart';
import 'package:invoice_generator_app/routes.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Admin Dashboard');
    setWindowMinSize(const Size(800, 600));
    setWindowMaxSize(Size.infinite);
  }
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
