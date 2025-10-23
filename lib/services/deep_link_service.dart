import 'package:app_links/app_links.dart';
import '../routes/app_routes.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  final AppLinks _appLinks = AppLinks();
  BuildContext? _context;

  DeepLinkService._internal();

  factory DeepLinkService() {
    return _instance;
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void init() {
    // Handle initial deep link
    _appLinks.getInitialLink().then((link) {
      if (link != null) {
        _handleDeepLink(link);
      }
    });

    // Listen for incoming deep links
    _appLinks.uriLinkStream.listen(
      (link) {
        _handleDeepLink(link);
      },
      onError: (err) {
        print('Error handling deep link: $err');
      },
    );
  }

  void _handleDeepLink(Uri link) {
    if (_context == null) {
      print('Context not available for deep link handling');
      return;
    }

    final route = AppRoutes.onDeepLinkRoute(link.toString());
    if (route != null) {
      Navigator.of(_context!).push(route);
    }
  }
}