// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'app_colors.dart';

// class AppTheme {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,

//       // Color Scheme
//       colorScheme: ColorScheme.light(
//         primary: AppColors.primary,
//         primaryContainer: AppColors.primaryLight,
//         secondary: AppColors.secondary,
//         secondaryContainer: AppColors.secondaryLight,
//         surface: AppColors.surface,
//         error: AppColors.danger,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onSurface: AppColors.textPrimary,
//         onError: Colors.white,
//       ),

//       // Scaffold
//       scaffoldBackgroundColor: AppColors.background,

//       // AppBar Theme
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         foregroundColor: AppColors.textPrimary,
//         surfaceTintColor: Colors.transparent,
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         titleTextStyle: TextStyle(
//           color: AppColors.textPrimary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           letterSpacing: -0.5,
//         ),
//       ),

//       // Card Theme
//       cardTheme: CardThemeData(
//         elevation: 0,
//         color: AppColors.surface,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(color: AppColors.border, width: 1),
//         ),
//         margin: EdgeInsets.zero,
//       ),

//       // Elevated Button Theme
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           disabledBackgroundColor: AppColors.textDisabled,
//           disabledForegroundColor: Colors.white,
//           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           textStyle: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),

//       // Text Button Theme
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//         ),
//       ),

//       // Input Decoration Theme
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.surface,
//         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.danger),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.danger, width: 2),
//         ),
//         labelStyle: TextStyle(
//           color: AppColors.textSecondary,
//           fontSize: 15,
//           fontWeight: FontWeight.w500,
//         ),
//         hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 15),
//         errorStyle: TextStyle(color: AppColors.danger, fontSize: 13),
//       ),

//       // Chip Theme
//       chipTheme: ChipThemeData(
//         backgroundColor: AppColors.surfaceVariant,
//         selectedColor: AppColors.primary,
//         disabledColor: AppColors.textDisabled,
//         labelStyle: TextStyle(
//           color: AppColors.textPrimary,
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),

//       // Bottom Navigation Bar Theme
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: AppColors.surface,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: AppColors.textTertiary,
//         selectedIconTheme: IconThemeData(size: 28),
//         unselectedIconTheme: IconThemeData(size: 26),
//         selectedLabelStyle: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//         unselectedLabelStyle: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         type: BottomNavigationBarType.fixed,
//         elevation: 8,
//       ),

//       // Dialog Theme
//       dialogTheme: DialogThemeData(
//         backgroundColor: AppColors.surface,
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         titleTextStyle: TextStyle(
//           color: AppColors.textPrimary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//         contentTextStyle: TextStyle(
//           color: AppColors.textSecondary,
//           fontSize: 15,
//           height: 1.5,
//         ),
//       ),

//       // Divider Theme
//       dividerTheme: DividerThemeData(
//         color: AppColors.divider,
//         thickness: 1,
//         space: 1,
//       ),

//       // Icon Theme
//       iconTheme: IconThemeData(color: AppColors.textSecondary, size: 24),

//       // Text Theme
//       textTheme: TextTheme(
//         displayLarge: TextStyle(
//           fontSize: 32,
//           fontWeight: FontWeight.w700,
//           color: AppColors.textPrimary,
//           letterSpacing: -1,
//         ),
//         displayMedium: TextStyle(
//           fontSize: 28,
//           fontWeight: FontWeight.w700,
//           color: AppColors.textPrimary,
//           letterSpacing: -0.5,
//         ),
//         displaySmall: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         headlineLarge: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         headlineMedium: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         headlineSmall: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         titleLarge: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         titleMedium: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         titleSmall: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         bodyLarge: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//           color: AppColors.textPrimary,
//           height: 1.5,
//         ),
//         bodyMedium: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w400,
//           color: AppColors.textSecondary,
//           height: 1.5,
//         ),
//         bodySmall: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w400,
//           color: AppColors.textTertiary,
//           height: 1.5,
//         ),
//         labelLarge: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         labelMedium: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textSecondary,
//         ),
//         labelSmall: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textTertiary,
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textDisabled,
          disabledForegroundColor: AppColors.textTertiary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.danger, width: 2),
        ),
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 15),
        errorStyle: TextStyle(color: AppColors.danger, fontSize: 13),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.textDisabled,
        labelStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 26),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
          height: 1.5,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: AppColors.textSecondary, size: 24),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
