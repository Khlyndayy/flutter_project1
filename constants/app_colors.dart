import 'package:flutter/material.dart';

/// 🎨 FRESH FOOD COLOR PALETTE
/// Theme: Ẩm thực tươi mới, ấm áp
class AppColors {
  // ===== BACKGROUND COLORS =====
  static const Color backgroundLight = Color(0xFFFFFBF0); // Cream nhạt
  static const Color backgroundDark = Color(0xFFF5F0E8); // Beige nhạt (đổi tên từ backgroundGradient)
  
  // ===== PRIMARY COLORS (Orange - Cam ấm) =====
  static const Color primary = Color(0xFFFF8C42); // Cam ấm
  static const Color primaryLight = Color(0xFFFFA54F); // Cam sáng
  static const Color primaryDark = Color(0xFFE67E22); // Cam đậm
  
  // ===== TEXT COLORS =====
  static const Color textPrimary = Color(0xFF2D5016); // Xanh lá đậm
  static const Color textSecondary = Color(0xFF6B8E23); // Xanh olive
  static const Color textWhite = Colors.white;
  
  // ===== ACCENT COLORS =====
  static const Color accent = Color(0xFFE74C3C); // Đỏ cà chua
  static const Color accentGreen = Color(0xFF27AE60); // Xanh lá tươi
  static const Color accentYellow = Color(0xFFF39C12); // Vàng ấm
  
  // ===== CARD & SURFACE COLORS =====
  static const Color cardBackground = Color(0xFFFFFAF0); // Ivory
  static const Color cardBorder = Color(0xFFFFE5D0); // Cam nhạt
  static const Color cardShadow = Color(0x26FF8C42); // Shadow cam
  
  // ===== TAG & BADGE COLORS =====
  static const Color tagBackground = Color(0xFFFFF8DC); // Kem
  static const Color tagBorder = Color(0xFFE8D5A0); // Vàng gold
  
  // ===== STATUS COLORS =====
  static const Color success = Color(0xFF27AE60); // Xanh success
  static const Color error = Color(0xFFE74C3C); // Đỏ error
  static const Color warning = Color(0xFFF39C12); // Vàng warning
  
  // ===== GRADIENTS =====
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> backgroundGradient = [backgroundLight, backgroundDark]; // FIX: dùng backgroundDark
  static const List<Color> accentGradient = [accent, primaryDark];
  
  // ===== HELPER METHODS =====
  static LinearGradient getPrimaryGradient({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(begin: begin, end: end, colors: primaryGradient);
  }
  
  static LinearGradient getBackgroundGradient({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(begin: begin, end: end, colors: backgroundGradient);
  }
  
  static BoxShadow getCardShadow({
    double blurRadius = 20,
    Offset offset = const Offset(0, 6),
  }) {
    return BoxShadow(color: cardShadow, blurRadius: blurRadius, offset: offset);
  }
}

/// 🖼️ APP ASSETS - Logo & Images
class AppAssets {
  // ⚠️ QUAN TRỌNG: Thay đổi đường dẫn này thành URL logo của bạn
  static const String logo = 'https://your-logo-url.com/logo.png';
  
  // Hoặc nếu dùng asset local:
  // static const String logo = 'assets/images/logo.png';
  // (Nhớ thêm vào pubspec.yaml: assets: - assets/images/)
}