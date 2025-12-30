import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  /*
  * final에 비해서 const 가 가벼움
  * 단기적으로 값 변경하지 못 하도록 상수처리 할 때 = final
  * 장기적으로 전체 공유하는 상수 처리 값 = const
  *
  * const = 어플 전체적으로 사용되는 상수 명칭
  * final = 특정 기능이나 특정 화면에서만 부분적으로 사용되는 상수 명칭
  * */
  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용

  static Future<List<dynamic>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));

    if(res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('불러오기 실패');
    }
  }
}