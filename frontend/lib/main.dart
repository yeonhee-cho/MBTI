import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path:'/',
        builder: (context, state) => const HomeScreen()
    ),

    // 검사 화면
    GoRoute(
      path:'/test',
      builder: (context, state) {
        final userName = state.extra as String; // 잠시 사용할 이름인데 문자열이에요
        /*
        * 생성된 객체를 사용할 수는 있으나, 매개변수는 존재하지 않은 상태
        * 단순히 화면만 보여주는 형태
        * const TestScreen({super.key});
        *
        * */
        return TestScreen(userName: userName);
      }
    ),

    // 결과 화면
    GoRoute(
        path:'/result',
        builder: (context, state) {
          final data = state.extra as Map<String, String>;
          return ResultScreen(userName : data['userName']!,resultType: data['resultType']!);
        }
    )
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // google 에서 제공라는 기본 커스텀 css 를 사용하며
    // 특정 경로를 개발자가 하나하나 설정하겠다.
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // 경로 설정에 대한 것은 : _router 라는 변수 이름을 참고해서 사용하거라
      routerConfig: _router,
      /* 추후 라이트 테마 다크 테마
      * theme
      * darkTheme
      * themeMode
      * home 을 사용할 때는 go_router 와 같이
      * 기본 메인 위치를 지정하지 않고, home 을 기준으로
      * 경로 이동 없이 작성할 때 사용!
      * home: const HomeScreen(0,
      * */
      /*
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      */
      // home: const HomeScreen(),
    );
  }
}
