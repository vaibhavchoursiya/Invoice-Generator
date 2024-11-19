import 'package:flutter/material.dart';

class InvoiceInfoSectionProvider extends ChangeNotifier {
  final TextEditingController fromCompanyNameController =
      TextEditingController();
  final TextEditingController fromNameController = TextEditingController();
  final TextEditingController fromGSTINNameController = TextEditingController();
  final TextEditingController fromAddressController = TextEditingController();
  final TextEditingController fromCityController = TextEditingController();
  final TextEditingController fromStateController = TextEditingController();
  final TextEditingController fromEmailController = TextEditingController();

  final TextEditingController billToCompanyNameController =
      TextEditingController();
  final TextEditingController billToNameController = TextEditingController();
  final TextEditingController billToGSTINNameController =
      TextEditingController();
  final TextEditingController billToAddressController = TextEditingController();
  final TextEditingController billToCityController = TextEditingController();
  final TextEditingController billToStateController = TextEditingController();
  final TextEditingController billToEmailController = TextEditingController();

  @override
  void dispose() {
    fromCompanyNameController.dispose();
    fromNameController.dispose();
    fromAddressController.dispose();
    fromCityController.dispose();
    fromEmailController.dispose();
    fromGSTINNameController.dispose();
    fromStateController.dispose();

    billToCompanyNameController.dispose();
    billToNameController.dispose();
    billToAddressController.dispose();
    billToCityController.dispose();
    billToEmailController.dispose();
    billToGSTINNameController.dispose();
    billToStateController.dispose();

    super.dispose();
  }
}
