import 'customer.dart';

class Transactions {
  int? id;
  String? domain;
  String? status;
  String? reference;
  Null? receiptNumber;
  int? amount;
  Null? message;
  String? gatewayResponse;
  String? paidAt;
  String? createdAt;
  String? channel;
  String? currency;
  int? fees;
  Customer? customer;

  Transactions(
      {this.id,
      this.domain,
      this.status,
      this.reference,
      this.receiptNumber,
      this.amount,
      this.message,
      this.gatewayResponse,
      this.paidAt,
      this.createdAt,
      this.channel,
      this.currency,
      this.fees,
      this.customer, required String email});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    domain = json['domain'];
    status = json['status'];
    reference = json['reference'];
    receiptNumber = json['receipt_number'];
    amount = json['amount'];
    message = json['message'];
    gatewayResponse = json['gateway_response'];
    paidAt = json['paid_at'];
    createdAt = json['created_at'];
    channel = json['channel'];
    currency = json['currency'];
    fees = json['fees'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['domain'] = this.domain;
    data['status'] = this.status;
    data['reference'] = this.reference;
    data['receipt_number'] = this.receiptNumber;
    data['amount'] = this.amount;
    data['message'] = this.message;
    data['gateway_response'] = this.gatewayResponse;
    data['paid_at'] = this.paidAt;
    data['created_at'] = this.createdAt;
    data['channel'] = this.channel;
    data['currency'] = this.currency;
    data['fees'] = this.fees;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}
