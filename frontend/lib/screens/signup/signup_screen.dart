import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 이름을 입력하는 필드 제어를 위한 컨트롤러 
  final TextEditingController _nameController = TextEditingController();
  
  // 유효성 검사 에러 메세지 저장
  String? _errorText;
  
  // 회원 가입 진행 중 상태 관리
  bool _isLoading = false;

  // 빈 값 체크
  bool _validateName() {
    String name = _nameController.text.trim();

    // 1. 빈 값 체크
    if(name.isEmpty){
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }

    //최소 글자 후 체크(2글자 이상)
    if(name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }

    // 3. 한글/영문만 허용(특수문자, 숫자 불가)
    if(!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '글 또는 영문만 입력 가능합니다.\n(특수문자, 숫자 불가)';
      });
      return false;
    }

    setState(() {
      _errorText = null;
    });
    return true;
  }
  
  void _handleSignup(){
    // 백엔드 회원가입 API 호출
    // 성공 -> 자동 로그인과 함께 검사 화면 이동
    // 실패 에러메세지 로딩해지

    // 1. 유효성 검사
    // 2. 로딩 상태 true로 변경
    // 3. ApiService.login(name) 호출
    // 4. 성공 시: SnackBar 표시 + 검사 화면으로 이동
    // 5. 실패 시: 에러 SnackBar 표시 + 로딩 해제
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
        leading: IconButton(
            onPressed: () => context.go("/"),
            icon: Icon(Icons.arrow_back),
        ),
      ),
      // SingleChildScrollView(child:Center(child:Container(child:Column(children[회원가입에 필요한 UI]))
      body: SingleChildScrollView(
        child : Center(
          child: Container( // Container 가 오면 가로 세로 padding 속성 사용
            padding : EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 회원가입에 필요한 UI
                Icon(Icons.person, size: 100, color: Colors.green),
                SizedBox(height: 30),
                Text(
                  'MBTI 검사를 위해\n회원가입해주세요',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력하세요.',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged:(value) {
                      setState(() {
                        if(RegExp(r'[0-9]').hasMatch(value)) {
                          _errorText = '숫자는 입력할 수 없습니다.';
                        } else if(RegExp(r'[^가-힣a-zA-Z]').hasMatch(value)){
                          _errorText = '한글과 영어만 입력 가능합니다.';
                        } else {
                          _errorText = null;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if(_validateName()) {
                          String name = _nameController.text.trim();
                          context.go('/test', extra: name);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            '회원가입하기',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('이미 계정이 있으신가요?'),
                    TextButton(
                      onPressed: _isLoading ? null : () => context.go('/login'),
                      child: Text('로그인하기'),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }

  /// 위젯 제거 시 리소스 해제
  /// TextEditingController 메모리 누수 방지
  @override
  void dispose() {
    // TextEditingController 해제
    // 힌트: _nameController.dispose();
    super.dispose();
  }
}