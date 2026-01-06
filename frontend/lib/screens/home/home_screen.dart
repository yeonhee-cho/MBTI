import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/*
* lib/
* ├─── screens/
* │       └───── home_screen.dart (메인 홈 화면 : 조립하는 역할)
* ├─── widgets/
* │       └───── home/ (홈 화면 전용위젯 폴더 생성)
* │               ├───── guest_section.dart (로그인 전 화면)
* │               ├───── user_section.dart (로그인 후 화면 + 입력 로직)
* │               ├───── profile_section.dart (앱 바 프로필 메뉴)
*/

// 상태에 따른 화면 변화가 일어날 예정
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeScreen 내부에서 사용 할 변수 이름, 함수 이름 작성할 공간
  /*
  * 만약에 input 이나 textarea을 사용할 경우에는 사용자들이 작성한 값(value)를 읽고
  * 읽은 value 데이터를 가져오기 위해 기능 작성해야 함
  * -> dart 에서는 TextEditingController 객체를 미리 만들어 놓았음
  *
  * 사용 방법
  * 1. 컨트롤러 상태를 담을 변수 공간 설정 _ private 설정을 안 해도 됨
  * 2. TextField 에 연결
  * TextField(
  *     controller : _nameController 와 같은 형태로 내부에서 작성된 value 를 연결
  * )
  * 3. 값을 가져와서 확인하거나 사용하기
  * String name = _nameController.text;
  * */
  final TextEditingController _nameController = TextEditingController();

  String? _errorText;

  // 홈 화면 시작하자마자 실행할 기능들 세팅 ctrl + o
  // git init -> git 초기 세팅 처럼 init 초기 세팅
  // state 상태 변화 기능
  // initState() -> 위젯 화면을 보여줄 때 초기 상태 화면 변화하여 보여주겠다.
  // ex 화면에서 backend 데이터를 가져오겠다. 로그인 상태 복원하겠다.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
  }

  // 에러 메세지를 담을 변수 // ?가 들어간 것은 변수 공간에 null 값이 들어 갈 수 있다라는 것

  // 유효성 검사 함수
  // 기능 중에 일부라도 문법 상 문제가 생기면 기능 자체가 작동 중지
  bool _validateName() {
    String name = _nameController.text.trim();

    // 1. 빈 값 체크
    if (name.isEmpty) {
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }

    // 2. 글자 수 체크 (2글자 미만)
    if (name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }

    // 3. 한글 영문 이 외 특수문자나 숫자 포함 체크 여부(정규식)
    // 만약 숫자도 허용하려면 r'^[가-힣-a-zA-Z0-9]+$'로 변경
    // 만약 숫자도 허용하려면 r'^[가-힣a-zA-Z0-9]+$' - : 어디서부터 어디까지
    // 가-힣 가에서부터 힣까지 힣에서 a까지는 잘못된 문법 정규식 동작 안 함
    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '한글 또는 영문만 입력 가능합니다. \n(특수문자, 숫자 불가)';
      });
      return false;
    }

    // 통과 시 에러 메세지 비움
    setState(() {
      _errorText = null;
    });
    return true;
  }

  // UI 화면
  /*
  * 키보드를 화면에서 사용해야하는 경우
  * 화면이 가려지는 것을 방지하기 위해 스크롤 가능하게 처리
  * */
  void _handleLogout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("로그아웃"),
          content: Text("로그아웃 하시겠습니까?"),
          actions: [
            // Navigator.pop을 go_router 사용한 context 로 교체하기
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("취소")
            ),
            TextButton(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("로그아웃 되었습니다.")
                      )
                  );
                },
                child: Text("로그아웃", style: TextStyle(color: Colors.red),),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isLoggedIn = authProvider.isLoggedIn;
        final userName = authProvider.user?.userName;

        return Scaffold(
          appBar: AppBar(
            title: const Text("MBTI 유형 검사"),
            // const를 생략할 경우 매번 불러와서 무거워 질 수 있으나 빼도 상관 없음
            actions: [
              // 로그인 상태에 따라 버튼 표시
              if (isLoggedIn)
                PopupMenuButton<String>(
                  icon: Icon(Icons.account_circle),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _handleLogout();
                    } else if (value == 'history') {
                      context.go("/history", extra: userName);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('$userName님')),
                    PopupMenuItem(child: Text('내 기록 보기'), value: 'history'),
                    PopupMenuDivider(),
                    PopupMenuItem(
                        child: Text(
                            '로그아웃',
                            style: TextStyle(color: Colors.red),
                        ),

                        value: 'logout',
                    ),
                  ],
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.psychology, size: 100, color: Colors.blue),
                    SizedBox(height: 30),
                    Text(
                      '나의 성격을 알아보는 ${AppConstants.totalQuestions}가지 질문',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 40),
                    if(!isLoggedIn) ...[
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => context.go('/login'),
                          child: Text('로그인하기', style: TextStyle(fontSize: 20)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => context.go('/signup'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("회원가입하기"),
                        ),
                      ),
                    ] else ... [
                      SizedBox(height: 40),
                      /*
                      * 방법 1 번
                      * TextField 에 입력할 때 마다 표기
                      *
                      * 방법 2 번
                      * ElevatedButton을 클릭할 때 표기
                      *  */
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: '이름',
                            hintText: '이름을 입력하세요.',
                            border: OutlineInputBorder(),
                            errorText: _errorText,
                          ),
                          onChanged: (value) {
                            // 모든 상태 실시간 변경은 setState(() =>{}) 내부에 작성
                            // setState() 로 감싸지 않은 if-else 문은
                            // 변수 값만 변경 -> 변수 값은 변화하지만 화면 업데이트는 안 됨
                            // setState() 로 감싼 if-else 문은
                            // 화면 자동으로 업데이트 되도록 상태 변경
                            setState(() {
                              if (RegExp(r'[0-9]').hasMatch(value)) {
                                _errorText = '숫자는 입력할 수 없습니다.';
                              } else if (RegExp(
                                r'[^가-힣a-zA-Z]',
                              ).hasMatch(value)) {
                                _errorText = '한글과 영어만 입력 가능합니다.';
                              } else {
                                _errorText = null;
                              }
                            });
                          },
                          /*
                          _validateName() 을 onChanged 에서는 사용하지 않음
                          * 글자를 입력하면 무조건 에러 메세지를 비워라
                          * 1111을 입력하는 순간에도 계속 에러 메세지를 지워버리기 때문에
                          * 정상적으로 _errorText 작동하나 마치 작동하지 않는 것처럼 보임
                          onChanged:(value) {
                            if(_errorText != null) {
                              setState(() {
                                _errorText = null;
                              });
                            }
                          },
                          * */
                        ),
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            String name = _nameController.text.trim();

                            if (name.isEmpty) {
                              // 이름이 비어있을 경우 비어있음에 대한 안내 후 돌려보내기
                              return;
                            }

                            // 검사 화면으로 이동 (이름전달)
                            context.go('/test', extra: name);
                          },
                          child: Text('검사 시작하기', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      /*
                      * div 와 성격이 같은 SizeBox를 이용해서
                      * 이전 결과 보기 버튼 생성할 수 있다.
                      * 굳이 SizedBox 를 사용하여 버튼을 감쌀 필요는 없지만
                      * 상태 관리나 디자인을 위해서 SizedBox 로 감싼 다음 버튼을 작성하는 것도 방법이다.
                      * */
                      SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            print("버튼눌림");
                            // 이름 내부 한 번 더 상태 확인
                            if (_validateName()) {
                              print("검사 결과");
                              String name = _nameController.text.trim();
                              // 작성한 이름 유저의 mbti 결과 확인
                              print("기록으로 이동하는 주소 위치");
                              context.go("/history", extra: name);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                          ),
                          child: Text("이전 결과 보기"),
                        ),
                      ),
                    ],
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.go('/types'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: Text("MBTI 유형 보기"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
