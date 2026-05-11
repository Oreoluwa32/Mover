import 'package:flutter/material.dart';
import 'package:movr/services/device_memory_service.dart';
import '../core/utils/app_toast.dart';
import '../widgets/movr_loading_indicator.dart';

class AuthRouteGuard extends StatefulWidget {
  const AuthRouteGuard({
    super.key,
    required this.child,
    required this.redirectRoute,
  });

  final Widget child;
  final String redirectRoute;

  @override
  State<AuthRouteGuard> createState() => _AuthRouteGuardState();
}

class _AuthRouteGuardState extends State<AuthRouteGuard> {
  bool _isChecking = true;
  bool _isAuthorized = false;
  bool _redirectQueued = false;

  @override
  void initState() {
    super.initState();
    _verifySession();
  }

  Future<void> _verifySession() async {
    final deviceMemory = DeviceMemoryService();
    await deviceMemory.init();
    final hasActiveSession = await deviceMemory.syncSessionState();
    if (!mounted) {
      return;
    }

    if (!hasActiveSession) {
      setState(() {
        _isChecking = false;
        _isAuthorized = false;
      });
      _queueRedirect();
      return;
    }

    setState(() {
      _isChecking = false;
      _isAuthorized = true;
    });
  }

  void _queueRedirect() {
    if (_redirectQueued) {
      return;
    }
    _redirectQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      AppToast.info('Please sign in to continue.');
      Navigator.of(context).pushNamedAndRemoveUntil(
        widget.redirectRoute,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: MovrLoadingIndicator(),
        ),
      );
    }

    if (!_isAuthorized) {
      return const Scaffold(
        body: SizedBox.expand(),
      );
    }

    return widget.child;
  }
}
