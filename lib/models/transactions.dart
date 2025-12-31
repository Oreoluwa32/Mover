import 'customer.dart';

class Transactions {
  int? id;
  String? domain;
  String? status;
  String? reference;
  dynamic receiptNumber;
  int? amount;
  dynamic message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['domain'] = domain;
    data['status'] = status;
    data['reference'] = reference;
    data['receipt_number'] = receiptNumber;
    data['amount'] = amount;
    data['message'] = message;
    data['gateway_response'] = gatewayResponse;
    data['paid_at'] = paidAt;
    data['created_at'] = createdAt;
    data['channel'] = channel;
    data['currency'] = currency;
    data['fees'] = fees;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}
