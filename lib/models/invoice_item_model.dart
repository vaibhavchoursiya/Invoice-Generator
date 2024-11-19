class InvoiceItem {
  String description;
  int quantity;
  String unit;
  double price;
  double tax;
  double total;

  InvoiceItem({
    this.description = "Flat Design",
    this.quantity = 0,
    this.unit = "piece",
    this.price = 0.0,
    this.tax = 0.0,
    this.total = 0.0,
  });
}
