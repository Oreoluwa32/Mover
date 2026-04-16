import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_export.dart';

class TaskInteractionHelper {
  static String resolveMatchId(
    Map<String, dynamic> requestData, {
    Map<String, dynamic>? args,
  }) {
    final fromArgs = args?['matchId']?.toString().trim() ?? '';
    if (fromArgs.isNotEmpty) {
      return fromArgs;
    }

    final fromRequestData = requestData['_match_id']?.toString().trim() ?? '';
    if (fromRequestData.isNotEmpty) {
      return fromRequestData;
    }

    final match = Map<String, dynamic>.from(
      requestData['_match'] as Map? ?? const <String, dynamic>{},
    );
    return match['id']?.toString().trim() ?? '';
  }

  static String resolveCounterpartyName(
    Map<String, dynamic> requestData, {
    required bool isMoverSide,
    String fallback = 'Participant',
  }) {
    if (isMoverSide) {
      final requester = Map<String, dynamic>.from(
        requestData['requester'] as Map? ?? const <String, dynamic>{},
      );
      return _resolveNameFromUserMap(requester, fallback: fallback);
    }

    final match = Map<String, dynamic>.from(
      requestData['_match'] as Map? ?? const <String, dynamic>{},
    );
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ??
          requestData['_travel_plan'] as Map? ??
          const <String, dynamic>{},
    );
    final createdBy = Map<String, dynamic>.from(
      travelPlan['created_by'] as Map? ?? const <String, dynamic>{},
    );
    return _resolveNameFromUserMap(createdBy, fallback: fallback);
  }

  static String resolveCounterpartyPhone(
    Map<String, dynamic> requestData, {
    required bool isMoverSide,
  }) {
    if (isMoverSide) {
      final requester = Map<String, dynamic>.from(
        requestData['requester'] as Map? ?? const <String, dynamic>{},
      );
      return requester['phone_number']?.toString().trim() ?? '';
    }

    final match = Map<String, dynamic>.from(
      requestData['_match'] as Map? ?? const <String, dynamic>{},
    );
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ??
          requestData['_travel_plan'] as Map? ??
          const <String, dynamic>{},
    );
    final createdBy = Map<String, dynamic>.from(
      travelPlan['created_by'] as Map? ?? const <String, dynamic>{},
    );
    return createdBy['phone_number']?.toString().trim() ?? '';
  }

  static Future<void> callParticipant(
    Map<String, dynamic> requestData, {
    required bool isMoverSide,
  }) async {
    final phoneNumber = resolveCounterpartyPhone(
      requestData,
      isMoverSide: isMoverSide,
    );
    if (phoneNumber.isEmpty) {
      Fluttertoast.showToast(msg: 'Phone number is not available yet.');
      return;
    }

    final sanitized = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: sanitized);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: 'Unable to open the dialer right now.');
    }
  }

  static Future<void> openTaskChat(
    Map<String, dynamic> requestData, {
    required bool isMoverSide,
    Map<String, dynamic>? args,
  }) async {
    final matchId = resolveMatchId(requestData, args: args);
    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Task information is missing.');
      return;
    }

    await NavigatorService.pushNamed(
      AppRoutes.taskChatScreen,
      arguments: {
        'matchId': matchId,
        'participantName': resolveCounterpartyName(
          requestData,
          isMoverSide: isMoverSide,
          fallback: isMoverSide ? 'Customer' : 'Mover',
        ),
      },
    );
  }

  static Future<void> openTaskReport(
    Map<String, dynamic> requestData, {
    required bool isMoverSide,
    required String requestType,
    Map<String, dynamic>? args,
  }) async {
    final matchId = resolveMatchId(requestData, args: args);
    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Task information is missing.');
      return;
    }

    await NavigatorService.pushNamed(
      AppRoutes.rideCancelScreenOne,
      arguments: {
        'matchId': matchId,
        'requestType': requestType,
        'mode': 'report',
        'source': isMoverSide ? 'mover_task' : 'requester_task',
      },
    );
  }

  static String _resolveNameFromUserMap(
    Map<String, dynamic> user, {
    required String fallback,
  }) {
    final fullName = user['full_name']?.toString().trim() ?? '';
    if (fullName.isNotEmpty) {
      return fullName;
    }

    final firstName = user['first_name']?.toString() ?? '';
    final lastName = user['last_name']?.toString() ?? '';
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) {
      return combined;
    }

    final email = user['email']?.toString().trim() ?? '';
    if (email.isNotEmpty) {
      return email;
    }

    return fallback;
  }
}
