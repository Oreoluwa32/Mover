import 'package:app_links/app_links.dart';
import '../routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  final AppLinks _appLinks = AppLinks();
  BuildContext? _context;
  bool _isInitialized = false;

  DeepLinkService._internal();

  factory DeepLinkService() {
    return _instance;
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void init() {
    if (_isInitialized) {
      return; // Prevent duplicate initialization
    }
    _isInitialized = true;

    // Handle initial deep link (app started via deep link)
    _appLinks.getInitialLink().then((link) {
      if (link != null) {
        developer.log('Initial deep link received: $link');
        _handleDeepLink(link);
      }
    }).catchError((err) {
      developer.log('Error getting initial deep link: $err');
    });

    // Listen for incoming deep links (app already running)
    _appLinks.uriLinkStream.listen(
      (link) {
        developer.log('Deep link stream received: $link');
        _handleDeepLink(link);
      },
      onError: (err) {
        developer.log('Error handling deep link stream: $err');
      },
    );
  }

  void _handleDeepLink(Uri link) {
    if (_context == null) {
      developer.log('Context not available for deep link handling');
      return;
    }

    developer.log('Processing deep link: ${link.toString()}');
    final route = AppRoutes.onDeepLinkRoute(link.toString());
    if (route != null) {
      // Use pushAndRemoveUntil to prevent navigation stack issues
      Navigator.of(_context!).pushAndRemoveUntil(
        route,
        (Route<dynamic> route) => route.isFirst,
      );
      developer.log('Deep link route navigation successful');
    } else {
      developer.log('No route found for deep link: ${link.toString()}');
    }
  }
}