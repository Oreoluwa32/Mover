class MonnifyAuthResponse {
  String? paymentUrl;
  String? accessCode;
  String? reference;

  MonnifyAuthResponse(
      {this.paymentUrl, this.accessCode, this.reference});

  MonnifyAuthResponse.fromJson(Map<String, dynamic> json) {
    paymentUrl = json['paymentUrl'] ?? json['payment_url'];
    accessCode = json['accessCode'] ?? json['access_code'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentUrl'] = paymentUrl;
    data['accessCode'] = accessCode;
    data['reference'] = reference;
    return data;
  }
}
