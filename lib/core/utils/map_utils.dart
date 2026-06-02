import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  // Marker bitmaps are rasterized at this multiple of their logical width
  // so they stay sharp on phones up to 4x DPR. The Maps SDK then
  // down-samples them at display time instead of stretching a tiny source.
  static const double _markerOversample = 4.0;

  /// Rasterize an SVG asset to PNG bytes sized for a marker of the given
  /// logical size. The result is ready to feed to either
  /// `BitmapDescriptor.bytes` (plain Maps) or `registerBitmapImage`
  /// (Google Navigation SDK) - both accept a logical width separately,
  /// so the over-sampled bytes give a sharp marker without stretching.
  static Future<Uint8List?> rasterizeSvgForMarker(
    String assetName, {
    Size logicalSize = const Size(40, 40),
    double oversample = _markerOversample,
  }) async {
    try {
      final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

      final int physicalWidth = (logicalSize.width * oversample).round();
      final int physicalHeight = (logicalSize.height * oversample).round();

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);

      final double scaleX = physicalWidth / pictureInfo.size.width;
      final double scaleY = physicalHeight / pictureInfo.size.height;
      canvas.scale(scaleX, scaleY);
      canvas.drawPicture(pictureInfo.picture);

      final image = await recorder.endRecording().toImage(
            physicalWidth,
            physicalHeight,
          );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    String assetName, [
    Size size = const Size(48, 48),
  ]) async {
    final bytes = await rasterizeSvgForMarker(assetName, logicalSize: size);
    if (bytes == null) {
      return BitmapDescriptor.defaultMarker;
    }
    return BitmapDescriptor.bytes(bytes, imagePixelRatio: _markerOversample);
  }

  /// Render the "live location" beam-and-dot bitmap. ``logicalWidth`` is
  /// the on-screen size in dp; the result is oversampled so it stays
  /// sharp on high-DPR devices.
  static Future<Uint8List?> getBeamBytes({
    int logicalWidth = 60,
    double oversample = _markerOversample,
  }) async {
    try {
      final int physicalWidth = (logicalWidth * oversample).round();
      final double widthF = physicalWidth.toDouble();
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);

      final double center = widthF / 2.0;

      // 1. Draw the beam (view range)
      final Paint beamPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(center, center),
          Offset(center, 0),
          [
            const Color(0xFF4285F4).withValues(alpha: 0.3),
            const Color(0xFF4285F4).withValues(alpha: 0.0),
          ],
        );

      final Path beamPath = Path();
      beamPath.moveTo(center, center);
      // Create a triangle/cone shape for the view range (approx 60 degrees)
      beamPath.lineTo(center - (widthF * 0.45), 0);
      beamPath.lineTo(center + (widthF * 0.45), 0);
      beamPath.close();

      canvas.drawPath(beamPath, beamPaint);

      // 2. Draw the Dot (Blue dot with white border and shadow)
      final double whiteRadius = widthF * 0.18; // Slightly bigger
      final double blueRadius = widthF * 0.12;

      // Draw Shadow
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * oversample);
      canvas.drawCircle(Offset(center, center), whiteRadius, shadowPaint);

      // Draw White Border
      final Paint whitePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(center, center), whiteRadius, whitePaint);

      // Draw Blue Dot
      final Paint bluePaint = Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(center, center), blueRadius, bluePaint);

      final ui.Image finalImage =
          await recorder.endRecording().toImage(physicalWidth, physicalWidth);
      final ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  static Future<BitmapDescriptor> bitmapDescriptorWithBeam({
    int logicalWidth = 60,
  }) async {
    final bytes = await getBeamBytes(logicalWidth: logicalWidth);
    if (bytes == null) return BitmapDescriptor.defaultMarker;
    return BitmapDescriptor.bytes(bytes, imagePixelRatio: _markerOversample);
  }

  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
