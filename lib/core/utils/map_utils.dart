import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    String assetName, [
    Size size = const Size(48, 48),
  ]) async {
    try {
      final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);
      
      final double width = size.width;
      final double height = size.height;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);
      
      // Calculate scale to fit the desired size
      final double scaleX = width / pictureInfo.size.width;
      final double scaleY = height / pictureInfo.size.height;
      
      canvas.scale(scaleX, scaleY);
      canvas.drawPicture(pictureInfo.picture);

      final image = await recorder.endRecording().toImage(
        width.toInt(),
        height.toInt(),
      );
      
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        return BitmapDescriptor.defaultMarker;
      }

      return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
    } catch (e) {
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<BitmapDescriptor> bitmapDescriptorWithBeam({
    int width = 150,
  }) async {
    try {
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);
      
      final double center = width / 2.0;
      
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
      beamPath.lineTo(center - (width * 0.45), 0);
      beamPath.lineTo(center + (width * 0.45), 0);
      beamPath.close();
      
      canvas.drawPath(beamPath, beamPaint);

      // 2. Draw the Dot (Blue dot with white border and shadow)
      final double whiteRadius = width * 0.18; // Slightly bigger
      final double blueRadius = width * 0.12;
      
      // Draw Shadow
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
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

      final ui.Image finalImage = await recorder.endRecording().toImage(width, width);
      final ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return BitmapDescriptor.defaultMarker;
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    } catch (e) {
      return BitmapDescriptor.defaultMarker;
    }
  }
}
