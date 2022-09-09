enum IncomeSpendingType { income, spending }

class AccountBookData {
  String doc;
  String type;
  String date;
  String store;
  String item;
  String payment;
  int amount;
  String detail;

  AccountBookData(
    this.doc,
    this.type,
    this.date,
    this.store,
    this.item,
    this.payment,
    this.amount,
    this.detail,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "doc": doc,
      "type": type,
      "date": date,
      "store": store,
      "item": item,
      "payment": payment,
      "amount": amount,
      "detail": detail,
    };
  }
}
