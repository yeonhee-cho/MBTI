/*
import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/map/map_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/signup/signup_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_types_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. 카카오 자바스크립트 키 초기화
  // 키 데이터는 .env 처럼 관리 할 것!
  AuthRepository.initialize(appKey: '5a5eea03d3f705ab4b794451dfad5796');

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path:'/',
        builder: (context, state) => const HomeScreen()
    ),

    // 2. 지도 경로 스크린 추가 map
    GoRoute(
        path:'/map',
        builder: (context, state) => const MapScreen()
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
          // final data = state.extra as Map<String, dynamic>;
          final result = state.extra as Result;
          return ResultScreen(result: result);
          /*
          return ResultScreen(
              userName : data['userName']!,
              resultType: data['resultType']!,
              eScore: data['eScore']!,
              iScore: data['iScore']!,
              sScore: data['sScore']!,
              nScore: data['nScore']!,
              tScore: data['tScore']!,
              fScore: data['fScore']!,
              jScore: data['jScore']!,
              pScore: data['pScore']!
          );
          */
        }
    ),
    // 기록
    GoRoute(
        path:'/history',
        builder: (context, state) {
          final userName = state.extra as String; // 변경이 되지 않게 상수화 처리
          // return ResultDetailScreen(userName : state.extra as String)
          return ResultDetailScreen(userName : userName);
        }
    ),
    // 회원가입
    GoRoute(
        path:'/signup',
        builder: (context, state) => SignupScreen()
    ),
    // 타입
    GoRoute(
        path:'/types',
        builder: (context, state) => MbtiTypesScreen()
    ),
    // 로그인
    GoRoute(
        path:'/login',
        builder: (context, state) => LoginScreen()
    ),
    // 회원가입
    GoRoute(
        path:'/signup',
        builder: (context, state) => SignupScreen()
    ),
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // google 에서 제공라는 기본 커스텀 css 를 사용하며
    // 특정 경로를 개발자가 하나하나 설정하겠다.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        // 경로 설정에 대한 것은 : _router 라는 변수 이름을 참고해서 사용하거라
        routerConfig: _router,
      )
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
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tosspayments_webview_flutter/tosspayments_webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
void main() {
  runApp(WebViewExample());
}
class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://flutter.dev',
    );
  }
}