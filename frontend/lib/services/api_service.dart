import 'dart:convert';

import 'package:frontend/models/answer_model.dart';
import 'package:frontend/models/question_model.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/models/test_request_model.dart';
import 'package:http/http.dart' as http;

  /*
  * final에 비해서 const 가 가벼움
  * 단기적으로 값 변경하지 못 하도록 상수처리 할 때 = final
  * 장기적으로 전체 공유하는 상수 처리 값 = const
  *
  * const = 어플 전체적으로 사용되는 상수 명칭
  * final = 특정 기능이나 특정 화면에서만 부분적으로 사용되는 상수 명칭
  * */
// models 에 작성한 자료형 변수 이름을 활용하여 데이터 타입을 지정하는 것
class ApiService {
  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용

  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));

    if(res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('불러오기 실패');
    }
  }

  // 결과 제출하기 post
  static Future<Result> submitTest(String userName, Map<int, String> answers) async {
    // 어플에서 선택한 답변의 결과를 API 형식으로 변환
    List<TestAnswer> answerList =answers.entries.map((entry) {
      return TestAnswer(questionId: entry.key, selectedOption: entry.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    // 어플에서 선택한 질문 번호와 질문에 대한 답변을 [{질문1, 답변}, {질문2, 답변}, {질문3, 답변}] 이런식으로 담는다.
    final res = await http.post(
        Uri.parse('$url/submit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson())
    );

    if(res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('제출 실패');
    }
  }
}

class DynamicApiService {
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

  // 결과 제출하기 post
  static Future<Map<String, dynamic>> submitTest(String userName, Map<int, String> answers) async {
    // 어플에서 선택한 답변의 결과를 API 형식으로 변환
    List<Map<String, dynamic>> answerList = [];
    // 어플에서 선택한 질문 번호와 질문에 대한 답변을 [{질문1, 답변}, {질문2, 답변}, {질문3, 답변}] 이런식으로 담는다.
    answers.forEach((questionId, option) {
      answerList.add({
        'questionId' : questionId,
        'selectedOption' : option
      });
    });

    final res = await http.post(
      Uri.parse('$url/submit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userName': userName,
        'answers' : answerList
      })
    );

    if(res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('제출 실패');
    }
  }
}