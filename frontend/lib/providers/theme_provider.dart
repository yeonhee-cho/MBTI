import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 보통 클래스가 아니라 모두에세 나를 알려야하는 클래스임을 표기
// 내가 화이트면 모두 화이트로 공지하여 교체해 라는 클래스
class ThemeProvider with ChangeNotifier {
  // setter getter 에서 getter
  /*
  private ThemeMode themeMode;

  public ThemeMode getThemeMode() {
    _themeMode
  }
  */
  // 원본을 유지하며
  ThemeMode _themeMode = ThemeMode.system; // 어플 시스템 테마 속성을 _themeMode 담아서 관리
  // 복제본으로 데이터 get 가져와 사용
  // setter getter 에서 getter dart() {} 의미없이 쓰지말고 -> 끝내버리자 문법
  ThemeMode get themeMode => _themeMode;

  // 현재 다크모드인지 확인하는 getter
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    // 생성되자마자 초기로 저장된 테마 불러오기
    _loadTheme();
  }

  // 테마 변경
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // UI 업데이트 전체 적용
  }
  // 저장된 테마 불러오기

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');

    // 저장된 값이 없으면 시스템 설정 유지, 있으면 해당 값 적용
    if(isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners(); // 모두에세 공지하여 적용하겠다.
    }
  }
}