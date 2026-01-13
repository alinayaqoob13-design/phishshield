// import 'package:flutter/material.dart';

// class AppColors {
//   // Primary Colors - Deep Blue with Modern Touch
//   static const Color primary = Color(0xFF0F62FE); // IBM Blue
//   static const Color primaryDark = Color(0xFF0043CE);
//   static const Color primaryLight = Color(0xFF4589FF);
//   static const Color primaryContainer = Color(0xFFD0E2FF);

//   // Secondary Colors - Vibrant Purple
//   static const Color secondary = Color(0xFF8A3FFC); // Purple
//   static const Color secondaryLight = Color(0xFFA56EFF);
//   static const Color secondaryDark = Color(0xFF6929C4);
//   static const Color secondaryContainer = Color(0xFFE8DAFF);

//   // Tertiary Colors - Cyan Accent
//   static const Color tertiary = Color(0xFF1192E8);
//   static const Color tertiaryLight = Color(0xFF33B1FF);
//   static const Color tertiaryContainer = Color(0xFFBAE6FF);

//   // Status Colors - Enhanced
//   static const Color success = Color(0xFF24A148); // Emerald
//   static const Color successLight = Color(0xFFA7F0BA);
//   static const Color successDark = Color(0xFF0E6027);
//   static const Color successContainer = Color(0xFFDEFBE6);

//   static const Color danger = Color(0xFFDA1E28); // Vibrant Red
//   static const Color dangerLight = Color(0xFFFFB3B8);
//   static const Color dangerDark = Color(0xFF750E13);
//   static const Color dangerContainer = Color(0xFFFFD7D9);

//   static const Color warning = Color(0xFFF1C21B); // Gold
//   static const Color warningLight = Color(0xFFFDDC69);
//   static const Color warningDark = Color(0xFF8E6A00);
//   static const Color warningContainer = Color(0xFFFCF4D6);

//   static const Color info = Color(0xFF4589FF);
//   static const Color infoLight = Color(0xFFA6C8FF);
//   static const Color infoContainer = Color(0xFFD0E2FF);

//   // Neutral Colors - Premium Gray Scale
//   static const Color background = Color(0xFFF4F4F4);
//   static const Color backgroundAlt = Color(0xFFFFFFFF);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color surfaceVariant = Color(0xFFF2F4F8);
//   static const Color surfaceElevated = Color(0xFFFFFFFF);

//   static const Color textPrimary = Color(0xFF161616);
//   static const Color textSecondary = Color(0xFF525252);
//   static const Color textTertiary = Color(0xFF8D8D8D);
//   static const Color textDisabled = Color(0xFFC6C6C6);
//   static const Color textOnPrimary = Color(0xFFFFFFFF);

//   static const Color border = Color(0xFFE0E0E0);
//   static const Color borderLight = Color(0xFFF4F4F4);
//   static const Color borderStrong = Color(0xFF8D8D8D);
//   static const Color divider = Color(0xFFE0E0E0);

//   // Chart Colors - Data Visualization
//   static const Color chartBlue = Color(0xFF4589FF);
//   static const Color chartPurple = Color(0xFF8A3FFC);
//   static const Color chartCyan = Color(0xFF1192E8);
//   static const Color chartTeal = Color(0xFF009D9A);
//   static const Color chartMagenta = Color(0xFFEE5396);
//   static const Color chartOrange = Color(0xFFFF832B);
//   static const Color chartYellow = Color(0xFFF1C21B);

//   // Gradient Colors - Enhanced
//   static const Gradient primaryGradient = LinearGradient(
//     colors: [Color(0xFF0F62FE), Color(0xFF8A3FFC)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const Gradient successGradient = LinearGradient(
//     colors: [Color(0xFF24A148), Color(0xFF198038)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const Gradient dangerGradient = LinearGradient(
//     colors: [Color(0xFFDA1E28), Color(0xFFFA4D56)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const Gradient warningGradient = LinearGradient(
//     colors: [Color(0xFFF1C21B), Color(0xFFFF832B)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const Gradient infoGradient = LinearGradient(
//     colors: [Color(0xFF4589FF), Color(0xFF1192E8)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const Gradient shimmerGradient = LinearGradient(
//     colors: [Color(0xFFE0E0E0), Color(0xFFF4F4F4), Color(0xFFE0E0E0)],
//     stops: [0.0, 0.5, 1.0],
//     begin: Alignment(-1.0, 0.0),
//     end: Alignment(1.0, 0.0),
//   );

//   // Glassmorphism
//   static const Color glassBackground = Color(0x80FFFFFF);
//   static const Color glassBorder = Color(0x40FFFFFF);

//   // Shadow Colors
//   static const Color shadowLight = Color(0x0A000000);
//   static const Color shadowMedium = Color(0x14000000);
//   static const Color shadowStrong = Color(0x29000000);
//   static const Color shadowPrimary = Color(0x330F62FE);

//   // Interactive States
//   static const Color hover = Color(0xFFE8E8E8);
//   static const Color pressed = Color(0xFFD1D1D1);
//   static const Color focus = Color(0xFF0F62FE);
//   static const Color selected = Color(0xFFE0E2FF);

//   // Overlay
//   static const Color overlay = Color(0x66000000);
//   static const Color scrim = Color(0x99000000);
// }





import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Deep Blue with Modern Touch (Dark Mode Optimized)
  static const Color primary = Color(0xFF4589FF); // Brighter Blue for dark
  static const Color primaryDark = Color(0xFF0F62FE);
  static const Color primaryLight = Color(0xFF78A9FF);
  static const Color primaryContainer = Color(0xFF001D6C);

  // Secondary Colors - Vibrant Purple
  static const Color secondary = Color(0xFFA56EFF); // Brighter Purple
  static const Color secondaryLight = Color(0xFFBE95FF);
  static const Color secondaryDark = Color(0xFF8A3FFC);
  static const Color secondaryContainer = Color(0xFF31135E);

  // Tertiary Colors - Cyan Accent
  static const Color tertiary = Color(0xFF33B1FF);
  static const Color tertiaryLight = Color(0xFF82CFFF);
  static const Color tertiaryContainer = Color(0xFF003A6D);

  // Status Colors - Enhanced for Dark Mode
  static const Color success = Color(0xFF42BE65); // Brighter Emerald
  static const Color successLight = Color(0xFF6FDC8C);
  static const Color successDark = Color(0xFF24A148);
  static const Color successContainer = Color(0xFF044317);

  static const Color danger = Color(0xFFFA4D56); // Brighter Red
  static const Color dangerLight = Color(0xFFFF8389);
  static const Color dangerDark = Color(0xFFDA1E28);
  static const Color dangerContainer = Color(0xFF520408);

  static const Color warning = Color(0xFFF1C21B); // Gold (same)
  static const Color warningLight = Color(0xFFFDDC69);
  static const Color warningDark = Color(0xFFD6A100);
  static const Color warningContainer = Color(0xFF3E3000);

  static const Color info = Color(0xFF4589FF);
  static const Color infoLight = Color(0xFF78A9FF);
  static const Color infoContainer = Color(0xFF001D6C);

  // Neutral Colors - Dark Theme
  static const Color background = Color(0xFF121212); // Dark Background
  static const Color backgroundAlt = Color(0xFF1E1E1E);
  static const Color surface = Color(0xFF1E1E1E); // Card/Surface color
  static const Color surfaceVariant = Color(0xFF262626);
  static const Color surfaceElevated = Color(0xFF2A2A2A);

  static const Color textPrimary = Color(0xFFF4F4F4); // Light text
  static const Color textSecondary = Color(0xFFC6C6C6);
  static const Color textTertiary = Color(0xFF8D8D8D);
  static const Color textDisabled = Color(0xFF525252);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color border = Color(0xFF393939); // Darker borders
  static const Color borderLight = Color(0xFF2A2A2A);
  static const Color borderStrong = Color(0xFF525252);
  static const Color divider = Color(0xFF393939);

  // Chart Colors - Data Visualization (Brighter for dark)
  static const Color chartBlue = Color(0xFF4589FF);
  static const Color chartPurple = Color(0xFFA56EFF);
  static const Color chartCyan = Color(0xFF33B1FF);
  static const Color chartTeal = Color(0xFF08BDBA);
  static const Color chartMagenta = Color(0xFFFF7EB6);
  static const Color chartOrange = Color(0xFFFF832B);
  static const Color chartYellow = Color(0xFFF1C21B);

  // Gradient Colors - Enhanced for Dark
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4589FF), Color(0xFFA56EFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient successGradient = LinearGradient(
    colors: [Color(0xFF42BE65), Color(0xFF24A148)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFA4D56), Color(0xFFFF8389)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient warningGradient = LinearGradient(
    colors: [Color(0xFFF1C21B), Color(0xFFFF832B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient infoGradient = LinearGradient(
    colors: [Color(0xFF4589FF), Color(0xFF33B1FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient shimmerGradient = LinearGradient(
    colors: [Color(0xFF262626), Color(0xFF393939), Color(0xFF262626)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
  );

  // Glassmorphism - Dark Mode
  static const Color glassBackground = Color(0x40262626);
  static const Color glassBorder = Color(0x40525252);

  // Shadow Colors - Dark Mode
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowStrong = Color(0x4D000000);
  static const Color shadowPrimary = Color(0x404589FF);

  // Interactive States - Dark Mode
  static const Color hover = Color(0xFF2A2A2A);
  static const Color pressed = Color(0xFF393939);
  static const Color focus = Color(0xFF4589FF);
  static const Color selected = Color(0xFF1E3A8A);

  // Overlay
  static const Color overlay = Color(0x99000000);
  static const Color scrim = Color(0xCC000000);
}
