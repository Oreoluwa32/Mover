class DeliveryConfirmationCode {
  static String buildPickupPayload(String requestId) {
    return requestId.trim();
  }

  static String buildPickupPin(String requestId) {
    return _buildPin(buildPickupPayload(requestId));
  }

  static String buildDeliveryPayload(String requestId) {
    final normalized = requestId.trim();
    return normalized.isEmpty ? normalized : '$normalized-delivered';
  }

  static String buildDeliveryPin(String requestId) {
    return _buildPin(buildDeliveryPayload(requestId));
  }

  static String buildPayloadForStage(
    String requestId, {
    required bool isDeliveryStage,
  }) {
    return isDeliveryStage
        ? buildDeliveryPayload(requestId)
        : buildPickupPayload(requestId);
  }

  static String buildPinForStage(
    String requestId, {
    required bool isDeliveryStage,
  }) {
    return isDeliveryStage
        ? buildDeliveryPin(requestId)
        : buildPickupPin(requestId);
  }

  static bool matchesExpectedQrValue(
    String scannedValue,
    String requestId, {
    required bool isDeliveryStage,
  }) {
    return scannedValue.trim() ==
        buildPayloadForStage(
          requestId,
          isDeliveryStage: isDeliveryStage,
        );
  }

  static String _buildPin(String sourceId) {
    final digits = sourceId.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 6) {
      return digits.substring(0, 6);
    }

    final seed = sourceId.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return (100000 + (seed % 900000)).toString();
  }
}
