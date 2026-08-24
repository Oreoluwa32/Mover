import 'package:flutter/material.dart';

import '../../widgets/rive_mover_marker.dart';

/// Preview screen for the animated Rive-based mover marker. Lets us
/// verify the artboard, transport-mode switching, moving/stopped
/// state, and heading rotation on a real device before wiring the
/// widget into the map overlay.
///
/// Open by navigating to `/debug/rive-marker` (see AppRoutes) or push
/// this screen directly.
class RiveMarkerPreviewScreen extends StatefulWidget {
  const RiveMarkerPreviewScreen({super.key});

  @override
  State<RiveMarkerPreviewScreen> createState() =>
      _RiveMarkerPreviewScreenState();
}

class _RiveMarkerPreviewScreenState extends State<RiveMarkerPreviewScreen> {
  MoverTransportMode _mode = MoverTransportMode.car;
  bool _moving = true;
  double _headingDegrees = 0;
  double _size = 72;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEAE0),
      appBar: AppBar(
        title: const Text('Rive marker preview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: RiveMoverMarker(
                mode: _mode,
                isMoving: _moving,
                headingRadians: _headingDegrees * 3.1415926535 / 180,
                size: _size,
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (final m in MoverTransportMode.values)
                      ChoiceChip(
                        label: Text(m.name),
                        selected: _mode == m,
                        onSelected: (_) => setState(() => _mode = m),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Moving'),
                    Switch(
                      value: _moving,
                      onChanged: (v) => setState(() => _moving = v),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Heading: ${_headingDegrees.round()}°'),
                          Slider(
                            min: 0,
                            max: 360,
                            value: _headingDegrees,
                            onChanged: (v) =>
                                setState(() => _headingDegrees = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Size: ${_size.round()}dp'),
                          Slider(
                            min: 32,
                            max: 160,
                            value: _size,
                            onChanged: (v) => setState(() => _size = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
