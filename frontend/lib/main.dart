import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/common/env_config.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/map/map_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/signup/signup_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_types_screen.dart';
import 'package:frontend/services/network_service.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 별 .env 파일 로드
  // 개발 : .env.development
  // 배포 : .env.product
  // 로컬 : .env.local
  //      .env.load(파일이름: "프로젝트에 존재하는 파일이름");
  await dotenv.load(fileName: ".env.development");

  /*
  * 자료형 ?
  *   공간 배부가 텅텅 비어있는데, undefined 호출하여 에러를 발생하는 것이 아니라
  *   null = 비어있음 처리로 에러 발생시키지 않는 안전 타입
  *   ex) String? 변경 가능한 데이터를 보관할 수 있는 공간 명칭;
  *
  * 공간명칭!
  *   NULL 단언 연산자 이 공간은 절대로 null 이 아님을 보장하는 표기
  *   개발자가 null 이 아니라고 강제 선언
  *   위험한 연산자 이지만 현재는 사용할 것
  *   // null 이면 빈 문자열 반환하는 방법이 있어요
  *   static String get kakaoMAPKey => dotenv.env['KAKAO_MAP_KEY'] ?? '';
  *
  *   빈 값이나 강제 대체값 처리 보다는 가져와야 하는 키를 무사히 불러올 수 있도록 로직 작성
  *
  *
  * ?? null이면 기본값 name ?? '기본프로필이미지.png'
  * ?. null이면 null 반환 name?.length 이름이 비어있으면 null
  * */
  // 개발 중 상황 확인을 위해 환경 정보 출력
  if(EnvConfig.isDevelopment) EnvConfig.printEnvInfo();
  AuthRepository.initialize(appKey: dotenv.env['KAKAO_MAP_KEY']!);

  runApp(const MyApp()); // 항상 넣기!!
  // WidgetsFlutterBinding.ensureInitialized();
  // // 1. 카카오 자바스크립트 키 초기화
  // // 키 데이터는 .env 처럼 관리 할 것!
  // AuthRepository.initialize(appKey: '5a5eea03d3f705ab4b794451dfad5796');
  //
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

// StatelessWidget -> StatefulWidget, mounted 도 ful 내에서만 가능
// context -> 최상위에서 사용하지 않음 -> HomeScreen으로 이동하여 사용하는 것이 맞음
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // google 에서 제공라는 기본 커스텀 css 를 사용하며
    // 특정 경로를 개발자가 하나하나 설정하겠다.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child:
      Consumer<ThemeProvider> (
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            // 경로 설정에 대한 것은 : _router 라는 변수 이름을 참고해서 사용하거라
            routerConfig: _router,

            themeMode: themeProvider.themeMode,
            // 라이트 모드 디자인
            theme: ThemeData(
              brightness: Brightness.light,
              // ThemeData와 같이 색상 팔레트를 설정하는 속성에는
              // 개발자가 작성한 변수명칭의 색상을 사용할 수 없음
              // Material 에서 만든 색상만 가능
              primarySwatch: Colors.blue,
              // primarySwatch: AppColors.primary, //
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              )
            ),

            // 다크 모드 디자인
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.indigo,
                scaffoldBackgroundColor: Colors.grey[900],
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.grey[850],
                  foregroundColor: Colors.white,
                )
            ),
          );
        }
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
/*
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

 */