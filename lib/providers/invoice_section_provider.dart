import 'package:flutter/material.dart';
import 'package:invoice_generator_app/models/invoice_item_model.dart';

class InvoiceSectionProvider extends ChangeNotifier {
  double total = 0.0;
  double taxValue = 0.0;
  double subTotalValue = 0.0;
  final List<InvoiceItem> items = [
    InvoiceItem(
      description: "Brochure Design",
      quantity: 1,
      unit: "piece",
      price: 100.0,
      tax: 5,
      total: 95.0,
    ),
  ];

  changeDescription(value, index) {
    items[index].description = value;
    notifyListeners();
  }

  changeQuantity(value, index) {
    items[index].quantity = int.tryParse(value) ?? 0;
    calculateTotal(index);
    notifyListeners();
  }

  changeUnit(value, index) {
    items[index].unit = value;
    notifyListeners();
  }

  changePrice(value, index) {
    items[index].price = double.tryParse(value) ?? 0.0;
    calculateTotal(index);
    notifyListeners();
  }

  changeTax(value, index) {
    items[index].tax = double.tryParse(value) ?? 0.0;
    calculateTotal(index);
    notifyListeners();
  }

  calculateTotal(index) {
    items[index].total = (items[index].quantity * items[index].price) *
        (1 + items[index].tax / 100);
  }

  addItem() {
    final InvoiceItem item = InvoiceItem();
    items.add(item);
    notifyListeners();
  }

  deleteItem(index) {
    items.removeAt(index);
    notifyListeners();
  }

  calulateTotalForItems() {
    total = 0.0;
    taxValue = 0.0;
    subTotalValue = 0.0;
    for (int i = 0; i < items.length; i++) {
      total = total + items[i].total;
      taxValue += (items[i].quantity * items[i].price) * (items[i].tax / 100);
    }
    subTotalValue = total - taxValue;
    notifyListeners();
  }
}
