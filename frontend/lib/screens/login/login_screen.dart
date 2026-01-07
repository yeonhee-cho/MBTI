import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/*
* 로그인 한 유저 이름이 테스트로 넘어가는지 확인
* signup 스크린 생성 후 main router 추가 필요 -> ok
* */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  /* 2-1: TextEditingController 선언 */
  // - TextField의 입력값을 제어하고 읽어오기 위한 컨트롤러
  // - final로 선언하여 불변성 유지
  final TextEditingController _nameController = TextEditingController();


  /* 2-2: 에러 메시지 상태 변수 선언 */
  // - 유효성 검사 실패 시 표시할 에러 메시지
  // - String? 타입으로 선언 (null 가능)
  // - 초기값은 null
  String? _errorText;


  /* 2-3: 로딩 상태 변수 선언 */
  // - API 호출 시 로딩 표시를 위한 변수 (선택사항)
  // - bool 타입으로 선언
  // - 초기값은 false
  bool _isLoading = false;

  /* 3: 유효성 검사 함수 구현 */
  // 함수명: _validateName
  // 반환타입: bool (검증 성공 시 true, 실패 시 false)
  bool _validateName() {
    /* 3-1: 입력값 가져오기 및 공백 제거 */
    // - _nameController.text로 입력값 가져오기
    // - trim() 메서드로 앞뒤 공백 제거
    String name = _nameController.text.trim();


    /* 3-2: 빈 값 검사 */
    // - isEmpty 속성으로 빈 문자열 체크
    // - 조건: name.isEmpty
    // - 실패 시 _errorText에 "이름을 입력해주세요." 설정
    // - setState() 사용하여 UI 업데이트
    // - return false로 검증 실패 반환
    if(name.isEmpty) {
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }



    /* 3-3: 최소 길이 검사 */
    // - length 속성으로 문자열 길이 확인
    // - 조건: name.length < 2
    // - 실패 시 _errorText에 "이름은 최소 2글자 이상이어야 합니다." 설정
    // - setState() 사용
    // - return false
    if(name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }


    /* 3-4: 문자 유형 검사 (정규표현식 사용) */
    // - RegExp를 사용하여 한글 또는 영문만 허용
    // - 패턴: r'^[가-힣a-zA-Z]+$'
    //   ^ : 문자열 시작
    //   [가-힣] : 한글 (가~힣)
    //   [a-zA-Z] : 영문 대소문자
    //   + : 1개 이상
    //   $ : 문자열 끝
    // - hasMatch() 메서드로 패턴 일치 확인
    // - 조건: !RegExp(패턴).hasMatch(name) - 부정으로 체크
    // - 실패 시 _errorText에 "한글 또는 영문만 입력 가능합니다\n(특수문자, 숫자 불가)." 설정
    if(!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        // 에러 메시지 설정
        _errorText = '한글 또는 영문만 입력 가능합니다. \n(특수문자, 숫자 불가)';
      });
      return false;
    }

    /* 3-5: 검증 성공 처리 */
    // - 모든 검사를 통과하면 _errorText를 null로 설정
    // - setState() 사용
    // - return true로 검증 성공 반환
    setState(() {
      _errorText = null;
    });
    return true;

  }

  Future<void> _handleLogin() async {
    if(!_validateName()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String name = _nameController.text.trim();
      // 1번 로그인 기능 작성
      final user = await ApiService.login(name);

      if(mounted){
        await context.read<AuthProvider>().login(user);

        // 2번 ScaffoldMessenger.of content ${user.userName}님, 환영합니다.
        ScaffoldMessenger.of(context).showSnackBar(
          // 구글에서 만든 디자인과 디자인 세부 설정이 작성되어있는 SnackBar.dart 클래스 파일
          // SnackBar를 만들 때 필수로 사용했으면 하는 속성
          // 선택적으로 사용했으면 하는 속성
          // content 라는 속성은 필수로 사용했으면 좋겠다는 속성
          // 이 속성에는 클라이언트들이 어떤 바인지 확인할 수 있는 텍스트나 아이콘이 있었으면 좋겠다.
          // Text()의 경우에도 Google에서 예쁘게 중간은 가는 디자인을 설정한 Text.dart 파일
          // 어느 정도 디자인을 할 수 있는 상급 개발자가 되고 나면 Google 에서 제공하는 디자인을 사용하는 것이 아니라
          // 회사 내부 규정대로 만들어 놓은 회사이름_Text() / DarkThemeText.dart 와 같은 파일을 만들어 사용할 수 있으므로
          // content: 개발자가 사용하고자하는 UI 기반 클래스 작성해라
            SnackBar(
                content: Text("${user.userName}님, 환영합니다."),
                duration:Duration(seconds: 2)
                // 구글 meterial 에서 만든 ui이 디자인이 되어있는 객체 사용!
            ),
        );
        // 로그인 후 이동하고자 하는 화면 이동
        context.go("/");
      }
    } catch(e) {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
          ),
        );
      }
    }
  }

  /* 4: build 메서드 구현 - 기본 Scaffold 구조 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* 4-1: AppBar 구현 */
      // - leading: 뒤로가기 IconButton
      appBar: AppBar(
        title: Text('로그인'),
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(Icons.arrow_back)
        )
      ),
      /* 4-2: body 영역 - SingleChildScrollView 구현 */
      // - 키보드가 올라올 때 스크롤 가능하도록 SingleChildScrollView 사용
      body: SingleChildScrollView(
        child: Center(
          child : Container(

            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),

          /* 4-3: Column으로 세로 배치 */
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* 5: 각 위젯 구현 */
                /* 5-1: 사용자 아이콘 추가 */
                Icon(Icons.person, size: 100, color: Colors.blue),
                /* 5-2: 간격 추가 */
                SizedBox(height: 30),

                /* 5-3: 안내 문구 Text 위젯 */
                Text(
                    'MBTI 검사를 위해\n로그인해주세요',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                ),
                /* 5-4: 간격 추가 */
                SizedBox(height: 40),

                /* 5-5: TextField 위젯 구현*/
                // controller: _nameController 연결
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    /* 5-5-1: decoration 설정 */
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력하세요.',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    /* 5-5-2: onChanged 이벤트 - 실시간 검증 */
                    // - 입력값이 변경될 때마다 호출
                    // - value 매개변수로 현재 입력값 전달받음
                    onChanged:(value) {
                      setState(() {
                        /* 5-5-2-1: 숫자 포함 검사 */
                        // - RegExp(r'[0-9]')로 숫자 검출
                        // - hasMatch(value)로 확인
                        // - 포함 시 _errorText = '숫자는 입력할 수 없습니다.'
                        if(RegExp(r'[0-9]').hasMatch(value)) {
                          _errorText = '숫자는 입력할 수 없습니다.';
                        }
                        /* 5-5-2-2: 한글/영문 외 문자 검사 */
                        // - RegExp(r'[^가-힣a-zA-Z]')로 한글/영문 외 문자 검출
                        //   [^ ] : 대괄호 안 문자를 제외한 모든 문자
                        // - 포함 시 _errorText = '한글과 영어만 입력 가능합니다.'
                        else if(RegExp(r'[^가-힣a-zA-Z]').hasMatch(value)){
                          _errorText = '한글과 영어만 입력 가능합니다.';
                        }
                        /* 5-5-2-3: 정상 입력 시 에러 제거 */
                        // - 위 조건들에 해당하지 않으면 _errorText = null
                        else {
                          _errorText = null;
                        }
                      });
                    },
                  ),
                ),
                /* 5-6: 간격 추가 */
                SizedBox(height: 30),


                /* 5-7: 로그인 버튼 구현 */
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      /* 5-7-1: onPressed 이벤트 */
                      // - _validateName() 함수 호출하여 검증
                      // - 검증 성공(true) 시 화면 이동 처리
                      onPressed: 
                        _isLoading ? null : _handleLogin,
                        //   () {
                        // if(_validateName()) {
                        //   /* 5-7-1-1: 입력값 가져오기 */
                        //   String name = _nameController.text.trim();
                        //   /* 5-7-1-2: 화면 이동 */
                        //   // - extra 파라미터로 이름 전달
                        //   context.go('/test', extra: name);
                        // }
                      // },
                      /* 5-7-2: 버튼 스타일 설정 */
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white
                      ),
                      /* 5-7-3: 버튼 텍스트 */
                      // - '로그인하기'
                      child: Text(
                          '로그인하기',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ),
                
                SizedBox(height: 20),
                Row(
                  /*
                  * 가운데 정렬 상태
                  * 계정이 없으신가요? -> Text() 
                  * 
                  * TextButton 이용해서 회원가입하기 완성
                  * */
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    Text('계정이 없으신가요?'),
                    TextButton(
                      onPressed: _isLoading ? null : () => context.go('/signup'),
                      child: Text('회원가입하기'),
                    ),
                  ],
                )
              ],
            ),
        ),)
      ),
    );
  }
}
