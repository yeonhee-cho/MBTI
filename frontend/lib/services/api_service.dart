import 'dart:convert';

import 'package:frontend/common/constants.dart';
import 'package:frontend/models/answer_model.dart';
import 'package:frontend/models/mbti_type_model.dart';
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
  // 상태 관리가 된 url 주소 호출
  static const String url = ApiConstants.baseUrl;

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));

    /*
     * http://localhost:8080/api/mbti/questions 로 접속했을 때 나오는 데이터
     * res.body = 백엔드에서 위 주소로 전달 받은 JSON 문자열 -> 주소로 가져오는 데이터는 한 줄로 가져온다.
     * ‘[{ “id” : 1,   “questionText” : “질문1”, “optionA” : “A”,  “optionB” : “B”}, { “id” : 1,   “questionText” : “질문1”, “optionA” : “A”,  “optionB” : “B”}, { “id” : 1,   “questionText” : “질문1”, “optionA” : “A”,  “optionB” : “B”}]’
     * 
     * json.decode() = 한 줄로 되어있는 JSON 문자열 데이터를 Dart 형식의 객체로 변환해서 사용
     * .map((json) => Question.fromJson(json)) = 변환을 할 때 각 데이터 하나씩 json이라는 변수 이름에 담아서 Question 객체로 변환 작업을 첫 데이터 부터 끝 데이터 까지 모두 수행
     * .toList() = map으로 출력된 결과를 List 목록 형태로 변환하여 사용
     */
    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 결과 제출하기 post
  /*
   * javaScript + java + c++ + sql
   *
   * Map<int, String> answers 내에는 소비자가 작성한 원본 데이터가 존재
   * Map<int, String> answers = {
   *    1:'A',
   *    2:'B',
   *    3:'A',
   *    ...
   * }
   *
   * answers.entries = Map을 MapEntry 리스트로 변환
   * 결과 = [
   *    MapEntry(key: 1, value ='A'),
   *    MapEntry(key: 2, value ='B'),
   *    MapEntry(key: 3, value ='A'),
   *    ...
   * ]
   *
   * .map((entry) { = 각 MapEntry를 TestAnswer로 변환
   *   return TestAnswer(
   *        questionId: entry.key,  // 1, 2, 3
   *        selectedOption: entry.value  // 'A', 'B', 'A'
   *   );
   * }).toList();  = 최종 결과로 List 형태로 변환
   *
   * MapEntry = Map 의 키 - 값 쌍을 나타내는 객체
   * entry의 entries 반복문 형태
   *
   * 현재 우리가 작성한 백엔드에서 위와 같은 형식을 유지하고 있기 때문에
   * 만약에 TestAnswer 와 같은 응답 전용 객체를 java에서 사용하지 않는다면 entries 작업까지 할 필요는 없음
   * 
   * Entry = 개체, DB 하나의 컬럼에 존재하는 데이터
   *
   * 사전 한 권은 Map
   * 사전의 각 항목은 Entry
   *
   * 책 사전 내부에 존재하는 예시 데이터
   * 키        값
   * apple -> 사과  = Entry 1개
   * banana -> 바나나  = Entry 1개
   * cherry -> 체리  = Entry 1개
   *
   * 총 Entry 개체는 3개
   *
   * Entries = entry 가 몇 개 있나 모든 Entry 항목 종합
   *           모든 키-값 쌍 들
   * 전화번호부 한 줄 :
   * 이름(key) : 홍길동
   * 전화번호(value) : 010-1234-5678
   * 
   * -> Entry 1개 = 객체 1개의 데이터
   */
  static Future<Result> submitTest(String userName, Map<int, String> answers) async {
    // 어플에서 선택한 답변의 결과를 API 형식으로 변환
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    // 어플에서 선택한 질문 번호와 질문에 대한 답변을 [{질문1, 답변}, {질문2, 답변}, {질문3, 답변}] 이런식으로 담는다.
    final res = await http.post(
        // http://localhost:8080/api/mbti/submit
        Uri.parse('$url${ApiConstants.submit}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson())
    );

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData= json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }
  
  // 사용자별 결과 조회 - 000 이름에 해당하는 모든 데이터 목록 조회
  /*
  * 사용자별 결과 조회
  * GET /api/mbti/results?userName={userName}
  * Dart 은 변수이름 뒤에 하위변수나 하위 기능이 존재하지 않을 경우
  * $변수이름 {} 없이 작성 가능
  * 변수이름.세부변수이름 변수이름.세부기능() 과 같이 존재할 경우
  * ${변수이름.세부변수이름}
  * ${변수이름.세부기능()} {}로 감싸서 작성
  */
  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.results}?userName=$userName'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json)=> Result.fromJson(json)).toList();
    } else {
      // constants 에서 지정한 에러 타입으로 교체 예정
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.types}'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList =json.decode(res.body);
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.types}$typeCode'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ID 로 결과 조회
  // GET /api/mbti/result/{id}
  // method = getResultById(int id)
  // http.get
  // Map<String, dynamic>
  static Future<Result> getResultById(int id) async {
      final res = await http.get(Uri.parse('$url${ApiConstants.result}/$id'));
      if(res.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(res.body);
        return Result.fromJson(jsonData);
      } else {
        throw Exception(ErrorMessages.loadFailed);
      }
  }

  // 결과 삭제
  // GET /api/mbti/result/{id}
  // method = deleteResult(int id)
  // http.delete
  // final res
  // Future 예상 결과로 백엔드에서 진행한 결과에 대한 return 없이 기능만 수행할 것
  // Result 아니고 void!!
  static Future<void> deleteResult(int id) async {
    final res = await http.delete(Uri.parse('$url${ApiConstants.result}/$id'));

    if(res.statusCode != 200) {
      throw Exception("삭제에 실패했습니다.");
    }
  }

  // Health Check = 백엔드 상태 관리용 api
  // GET /api/mbti/health
  // healthCheck
  // final res
  // 개발 회사 확인용 API
  static Future<Result> healthCheck(int id) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.result}/${ApiConstants.health}'));
    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.serverError);
    }
  }

/**
 * final res = http.Response 라는 타입으로 자동 지정
 * final http.Response res =
 *
 * final res  = 명시적 추론, 타입 명시를 하지 않아 Dart에서 자동으로 반환 타입 파악 필요
 * final String res  = 타입을 명확히 지정
 * final int res  = 타입을 명확히 지정
 * 
 * final a = 1; // int 로 자동 타입 확인
 * 개발자가 만든 자료형이나 클래스형 자료형은 필히 타입을 작성해주는 것이 좋음
 */
}

/*
 * Map<String, dynamic> jsonData= json.decode(res.body);
 * String = 키 명칭들은 문자열로 확정!
 * <String,         dynamic>
 *   "id"           1             숫자
 * "userName"       "여니"        문자열
 * "resultType"     "INFP"        문자열
 * "isActive"       true,         불리언
 * "createdAt"      null,         null
 * "scores"        [2,3,1,...]    List
 * 
 * dynamic 대신에 Object 사용하면 안돼요!!
 * 
 * Object 에는 null 불가능 = Dart Object 타입은 null 불가능, 컴파일에서는 연산 불가함 (2.1.2 부터 null 사용금지, dynamic 쓰기!)
 *                   하지만 java Object 타입은 null 가능!
 * 
 * dynamic 은 null 가능 = 컴파일에서는 우선 타입이 무엇인지 ???? 상태로 일단 만듬 -> 실행하면서 타입이 맞지 않으면 에러 발생
 */

class ModelApiService {}

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
  static Future<Map<String,dynamic>> submitTest(String userName, Map<int, String> answers) async {
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