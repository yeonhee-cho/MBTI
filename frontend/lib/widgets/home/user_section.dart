import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText; // 에러 메세지를 담을 변수 // ?가 들어간 것은 변수 공간에 null 값이 들어 갈 수 있다라는 것

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

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?.userName; // ? -> 없으면 에러 뜨기 보다는 null 형태로 유지
    return Column(
      children: [
        // 000 님
        SizedBox(
          child: Text(
            '$userName님'
          ),
        ),
        SizedBox(
          child: Text(
            "내 근처 10km 다른 유저의 MBTI 확인하기"
          ),
        ),
        // SizedBox(height: 40),
        // SizedBox(height: 40),
        // SizedBox(
        //   width: 300,
        //   child: TextField(
        //     controller: _nameController,
        //     decoration: InputDecoration(
        //       labelText: '이름',
        //       hintText: '이름을 입력하세요.',
        //       border: OutlineInputBorder(),
        //       errorText: _errorText,
        //     ),
        //     onChanged: (value) {
        //       // 모든 상태 실시간 변경은 setState(() =>{}) 내부에 작성
        //       // setState() 로 감싸지 않은 if-else 문은
        //       // 변수 값만 변경 -> 변수 값은 변화하지만 화면 업데이트는 안 됨
        //       // setState() 로 감싼 if-else 문은
        //       // 화면 자동으로 업데이트 되도록 상태 변경
        //       setState(() {
        //         if (RegExp(r'[0-9]').hasMatch(value)) {
        //           _errorText = '숫자는 입력할 수 없습니다.';
        //         } else if (RegExp(
        //           r'[^가-힣a-zA-Z]',
        //         ).hasMatch(value)) {
        //           _errorText = '한글과 영어만 입력 가능합니다.';
        //         } else {
        //           _errorText = null;
        //         }
        //       });
        //     },
        //     /*
        //     _validateName() 을 onChanged 에서는 사용하지 않음
        //     * 글자를 입력하면 무조건 에러 메세지를 비워라
        //     * 1111을 입력하는 순간에도 계속 에러 메세지를 지워버리기 때문에
        //     * 정상적으로 _errorText 작동하나 마치 작동하지 않는 것처럼 보임
        //     onChanged:(value) {
        //       if(_errorText != null) {
        //         setState(() {
        //           _errorText = null;
        //         });
        //       }
        //     },
        //     * */
        //   ),
        // ),
        // SizedBox(height: 20),
        //
        // /*
        // * 방법 1 번
        // * TextField 에 입력할 때 마다 표기
        // *
        // * 방법 2 번
        // * ElevatedButton을 클릭할 때 표기
        // *  */
        //
        // /*
        // * div 와 성격이 같은 SizeBox를 이용해서
        // * 이전 결과 보기 버튼 생성할 수 있다.
        // * 굳이 SizedBox 를 사용하여 버튼을 감쌀 필요는 없지만
        // * 상태 관리나 디자인을 위해서 SizedBox 로 감싼 다음 버튼을 작성하는 것도 방법이다.
        // * */
        // SizedBox(height: 20),
        //
        // // 검사 시작하기 버튼은 게스트 모드, 유저모드 관계없이 누구나 볼 수 있어야 함
        // // 게스트는 유저 이름 입력하고 검사 시작할 수 있다.
        // // 유저는 로그인한 유저 이름으로 검사 시작할 수 있다.
        // SizedBox(
        //   width: 300,
        //   height: 50,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       String name = _nameController.text.trim();
        //
        //       if (name.isEmpty) {
        //         // 이름이 비어있을 경우 비어있음에 대한 안내 후 돌려보내기
        //         return;
        //       }
        //
        //       // 검사 화면으로 이동 (이름전달)
        //       context.go('/test', extra: name);
        //     },
        //     child: Text('검사 시작하기', style: TextStyle(fontSize: 16)),
        //   ),
        // ),
        // SizedBox(height: 20),
        // SizedBox(
        //   width: 300,
        //   height: 50,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       print("버튼눌림");
        //       // 이름 내부 한 번 더 상태 확인
        //       if (_validateName()) {
        //         print("검사 결과");
        //         String name = _nameController.text.trim();
        //         // 작성한 이름 유저의 mbti 결과 확인
        //         print("기록으로 이동하는 주소 위치");
        //         context.go("/history", extra: name);
        //       }
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.grey[300],
        //       foregroundColor: Colors.black87,
        //     ),
        //     child: Text("이전 결과 보기"),
        //   ),
        // ),
      ],
    );
  }
}