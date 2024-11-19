import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InvoiceHeaderProvider extends ChangeNotifier {
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController invoiceDateController = TextEditingController();

  File? file;

  Future<void> filePicker() async {
    FilePickerResult? filePickerResull = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (filePickerResull != null) {
      file = File(filePickerResull.files.single.path!);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    invoiceNumberController.dispose();
    invoiceDateController.dispose();
    super.dispose();
  }
}
