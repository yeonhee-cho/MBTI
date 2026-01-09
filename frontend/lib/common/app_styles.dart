// 어플 전체에서 사용할 색상들의 정의
import 'dart:ui';

import 'package:flutter/material.dart';

/*
* 일반적인 웹 디자인에서 사용하는 색상코드
* rgb(rgb(255,255,255), rgba(rgba(0,0,0,0.9)), 
* hex(#fffff)
* 
* 플러터에서 색상을 표기하는 방법
* 방법 1 : hex 색상에 0xFF 붙이기 가장 일반적으로 많이 사용
* 0xFF는 불투명도
* Color(0xFF64B5F6)
*       0xFF         64B5F6
*       완전 보이게   hex 색상 표기
* 
* 방법 2 : fromARGB
* Color.fromARGB(255,100,181,246)
*                Alpha
*                투명도
*
* 방법 3 : fromRGB0 = rgb, rgba 와 비슷한 형태
* Color.fromARGB(100,181,246, 1.0)
*                             투명도를 0.0 ~ 1.0 사이
*
* 0xFF = 255 = 100% 불투명 (완전히 보임)
* 0xCC = 204 = 80% 불투명
* 0x99 = 153 = 60% 불투명
* 0x66 = 102 = 40% 불투명
* 0x33 =  51 = 20% 불투명
* 0x00 =   0 = 0% 투명 (완전히 안 보임)
*
* 밝기 조절
* Colors.blue[50]  // 매우 밝은 파란색
* Colors.blue[500] // 기본 파란색
* Colors.blue[900] // 매우 어두운 파란색
* */
class AppColors {
  // Primary Colors
  static const Color primary = Colors.blue;
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);


  // Secondary Colors
  static const Color secondary = Colors.green;
  static const Color accent = Colors.amber;

  // Text Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color background = Colors.white;
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFAFAFA);

  // Status Colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;

  // Grey Scale
  static final Color grey50 = Colors.grey[50]!;
  static final Color grey100 = Colors.grey[100]!;
  static final Color grey200 = Colors.grey[200]!;
  static final Color grey300 = Colors.grey[300]!;
  static final Color grey600 = Colors.grey[600]!;
  static final Color grey700 = Colors.grey[700]!;
}

/// 앱 전체에서 사용할 텍스트 스타일 정의
class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle body1 = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle body3 = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  // Special Text Styles
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // MBTI 관련 특수 스타일
  static const TextStyle mbtiType = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle mbtiTypeSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle scoreText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

/// 앱 전체에서 사용할 간격(Spacing) 정의
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 50.0;
}

/// 앱 전체에서 사용할 BorderRadius 정의
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double circle = 999.0;

  // BorderRadius 객체
  static BorderRadius get smallRadius => BorderRadius.circular(sm);
  static BorderRadius get mediumRadius => BorderRadius.circular(md);
  static BorderRadius get largeRadius => BorderRadius.circular(lg);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(xl);
  static BorderRadius get circleRadius => BorderRadius.circular(circle);
}

/// 앱 전체에서 사용할 아이콘 크기 정의
class AppIconSize {
  static const double xs = 16.0;
  static const double sm = 20.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
  static const double xxl = 64.0;
  static const double xxxl = 80.0;
  static const double huge = 100.0;
}

/// 앱 전체에서 사용할 버튼 스타일 정의
class AppButtonStyles {
  // Primary 버튼
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textWhite,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.mediumRadius,
    ),
  );

  // Secondary 버튼
  static ButtonStyle secondary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.textWhite,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.mediumRadius,
    ),
  );

  // Outline 버튼
  static ButtonStyle outline = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.primary,
    side: BorderSide(color: AppColors.primary, width: 2),
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.mediumRadius,
    ),
  );

  // Grey 버튼
  static ButtonStyle grey = ElevatedButton.styleFrom(
    backgroundColor: AppColors.grey300,
    foregroundColor: AppColors.textPrimary,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.mediumRadius,
    ),
  );

  // Danger 버튼
  static ButtonStyle danger = ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: AppColors.textWhite,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.mediumRadius,
    ),
  );
}

// 앱 전체에서 사용할 Card 스타일 정의
class AppCardStyles {
  static BoxDecoration standard = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: AppRadius.mediumRadius,
    border: Border.all(color: AppColors.grey300),
  );

  static BoxDecoration elevated = BoxDecoration(
    color: AppColors.background,
    borderRadius: AppRadius.mediumRadius,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration result = BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppRadius.largeRadius,
    border: Border.all(color: AppColors.primary, width: 2),
  );
}

// 앱 전체에서 사용할 InputDecoration 정의
class AppInputStyles {
  static InputDecoration standard({
    String? labelText,
    String? hintText,
    String? errorText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: OutlineInputBorder(
        borderRadius: AppRadius.smallRadius,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
    );
  }
}

// 앱 전체에서 사용할 그림자 효과 정의
class AppShadows {
  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}

// 자주 사용하는 SizedBox 정의
class AppSizedBox {
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h10 = SizedBox(height: 10);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h20 = SizedBox(height: 20);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h30 = SizedBox(height: 30);
  static const SizedBox h40 = SizedBox(height: 40);
  static const SizedBox h50 = SizedBox(height: 50);
  static const SizedBox h60 = SizedBox(height: 60);

  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w20 = SizedBox(width: 20);
  static const SizedBox w24 = SizedBox(width: 24);
}

// 자주 사용하는 EdgeInsets 정의
class AppPadding {
  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets all4 = EdgeInsets.all(4);
  static const EdgeInsets all8 = EdgeInsets.all(8);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all20 = EdgeInsets.all(20);
  static const EdgeInsets all24 = EdgeInsets.all(24);

  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets vertical20 = EdgeInsets.symmetric(vertical: 20);

  static const EdgeInsets symmetric16 = EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  static const EdgeInsets symmetric20 = EdgeInsets.symmetric(horizontal: 20, vertical: 20);
  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: 20, vertical: 50);
}