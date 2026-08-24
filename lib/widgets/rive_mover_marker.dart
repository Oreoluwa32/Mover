import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rive/rive.dart';

/// Transport mode the marker should render.
enum MoverTransportMode { car, bike, walker, truck }

/// Widget that renders an animated Rive artboard for a mover, meant to be
/// overlaid on top of a Google Map at the mover's screen coordinate. It
/// swaps artboards by [MoverTransportMode] and drives an `isMoving` bool
/// input on the artboard's state machine to switch between idle and
/// moving animations.
///
/// If the underlying `.riv` asset is missing (e.g. before designs land),
/// a placeholder chip renders in its place so the plumbing keeps working.
class RiveMoverMarker extends StatefulWidget {
  const RiveMoverMarker({
    super.key,
    required this.mode,
    required this.isMoving,
    this.headingRadians = 0.0,
    this.size = 56.0,
  });

  final MoverTransportMode mode;
  final bool isMoving;

  /// Rotation applied to the marker in radians. Use the mover's bearing
  /// (converted from degrees) so the vehicle points in the direction of
  /// travel.
  final double headingRadians;

  final double size;

  @override
  State<RiveMoverMarker> createState() => _RiveMoverMarkerState();
}

class _RiveMoverMarkerState extends State<RiveMoverMarker> {
  static const _stateMachineName = 'Mover';
  static const _movingInputName = 'isMoving';

  Artboard? _artboard;
  SMIBool? _movingInput;
  bool _assetMissing = false;

  @override
  void initState() {
    super.initState();
    _loadArtboard();
  }

  @override
  void didUpdateWidget(covariant RiveMoverMarker old) {
    super.didUpdateWidget(old);
    if (old.mode != widget.mode) {
      _loadArtboard();
    } else if (old.isMoving != widget.isMoving) {
      _movingInput?.value = widget.isMoving;
    }
  }

  Future<void> _loadArtboard() async {
    final assetPath = _assetForMode(widget.mode);
    try {
      // Probe rootBundle so a missing asset is a normal path instead of
      // a thrown Rive parse error we then have to swallow.
      await rootBundle.load(assetPath);
    } catch (_) {
      if (mounted) setState(() => _assetMissing = true);
      return;
    }

    try {
      final file = await RiveFile.asset(assetPath);
      final artboard = file.mainArtboard.instance();
      final controller =
          StateMachineController.fromArtboard(artboard, _stateMachineName);
      if (controller != null) {
        artboard.addController(controller);
        _movingInput =
            controller.findInput<bool>(_movingInputName) as SMIBool?;
        _movingInput?.value = widget.isMoving;
      }
      if (!mounted) return;
      setState(() {
        _artboard = artboard;
        _assetMissing = false;
      });
    } catch (_) {
      if (mounted) setState(() => _assetMissing = true);
    }
  }

  String _assetForMode(MoverTransportMode mode) {
    switch (mode) {
      case MoverTransportMode.car:
        return 'assets/rive/mover_car.riv';
      case MoverTransportMode.bike:
        return 'assets/rive/mover_bike.riv';
      case MoverTransportMode.walker:
        return 'assets/rive/mover_walker.riv';
      case MoverTransportMode.truck:
        return 'assets/rive/mover_truck.riv';
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _artboard != null
        ? Rive(artboard: _artboard!, fit: BoxFit.contain)
        : _PlaceholderMarker(
            mode: widget.mode,
            isMoving: widget.isMoving,
            missing: _assetMissing,
          );

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Transform.rotate(
        angle: widget.headingRadians,
        child: child,
      ),
    );
  }
}

class _PlaceholderMarker extends StatelessWidget {
  const _PlaceholderMarker({
    required this.mode,
    required this.isMoving,
    required this.missing,
  });

  final MoverTransportMode mode;
  final bool isMoving;
  final bool missing;

  IconData get _icon {
    switch (mode) {
      case MoverTransportMode.car:
        return Icons.directions_car;
      case MoverTransportMode.bike:
        return Icons.pedal_bike;
      case MoverTransportMode.walker:
        return Icons.directions_walk;
      case MoverTransportMode.truck:
        return Icons.local_shipping;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isMoving ? Colors.deepPurple : Colors.grey.shade600,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(_icon, color: Colors.white, size: 26),
    );
  }
}
