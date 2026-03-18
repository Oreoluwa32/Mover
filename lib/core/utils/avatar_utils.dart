import 'package:flutter/material.dart';

class AvatarUtils {
  static String getNameInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    }
    
    String firstInitial = nameParts[0].substring(0, 1).toUpperCase();
    String lastInitial = nameParts[nameParts.length - 1].substring(0, 1).toUpperCase();
    
    return '$firstInitial$lastInitial';
  }

  static Color getAvatarColor(String? name) {
    if (name == null || name.isEmpty) return const Color(0XFF6A19D3);
    
    final List<Color> colors = [
      const Color(0XFF6A19D3), // Primary
      const Color(0XFF7E56D8), // deepPurple400
      const Color(0XFF8130F7), // deepPurpleA20001
      const Color(0XFF597ED7), // indigo400
      const Color(0XFF3C52B9), // indigo500
      const Color(0XFF77C055), // lightGreen500
      const Color(0XFFF4900C), // orange500
      const Color(0XFFEA4335), // red500
    ];
    
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    return colors[hash.abs() % colors.length];
  }
}
