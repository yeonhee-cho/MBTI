/*
 * Flutter / Dart 앱의 상수 정의 파일
 * MBTI 성격 유형 검사 앱에서 사용되는 각종 설정 값과 메세지를 중앙에서 관리하기 위한 구조
 * 실제 회사 : dev_api_constants / stage_api_constants / drod_api_constants
 *
 * 주요 구성 요소
 * ApiConstants - API 엔드 포인트 주소들, 앱 기본 설정
 *   baseUrl : 백엔드 서버 주소(로컬 / 에뮬레이터 / 실제 서버 옵셔 주석 처리하여 사용)
 *   API 경로들 : 질문 목록, 답변 제출, 결과 조회 등
 *
 * AppConstants - 앱 기본 설정
 *   앱 이름과 질문 개수 등 앱 전반에서 사용되는 설정
 *
 * MbtiDimensions - MBTI 4가지 척도
 *   EI(외향-내향), SN(감각-직관), TF(사고-감정), JP(판단-인식)
 *
 * ErrorMessages = 사용자에세 표시할 오류 메세지
 *   네트워크 오류, 서버 오류, 입력 오류 등 다양한 상황의 안내 메세지
 *
 * static const vs static final = 언제 값이 결정되는가의 차이
 *
 * static const
 * - 컴파일 시점에 값이 결정됨
 * - 값이 코드에 하드 코딩되어 있어야 한다.
 * - 메모리에 한 번만 저장하여 모든 인스턴스가 공유
 * - 더 효율적
 *
 * static final
 * - 런타임(실행시점)에 값이 결정됨
 * - 한 번 할당되면 변경 불가
 * - 계산된 값이나 함수 호출 결과도 가능
 * - 불필요하게 const 보다 무겁기 때문에 const 사용 권장하는 추세
 *
 * dart 은 컴파일러와 인터프리터 두 가지를 모두 지원하는 언어
 * flutter 앱에서는 컴파일로 실행을 주로 한다.(이유는 인터프리터보다 빠르니까!)
 *
 * - 상황에 따라 선택하여 사용할 수 있다. 컴파일에서 사용한다는 표현이 더 적합함!
 */
class ApiConstants {
  // final 대신 넣어줌
  // static final String baseUrl = 'http://localhost:8080/api/mbti';
  static const String baseUrl = 'http://localhost:8080/api/mbti';
  static const String submit = '/submit';
  static const String result = '/result';
  static const String results = '/results';
  static const String types = '/types';
  static const String health = '/health';
}

class AppConstants {
  static const String appName = 'MBTI 성격유형 검사';
  static const int totalQuestions = 12; // 전체 질문
  static const int questionsPerDimension = 3; // 차원당 질문 개수
/*
* 1. E/I 차원(외향/내향) 질문 3가지
* 2. S/N 차원(감각/직관) 질문 3가지
* 3. T/F 차원(사고/감정) 질문 3가지
* 4. J/P 차원(판단/인식) 질문 3가지
* */
}

class MbtiDimensions {
  static const String ei = 'EI';
  static const String sn = 'SN';
  static const String tf = 'TF';
  static const String jp = 'JP';
}

class ErrorMessages {
  static const String networkError = '네트워크 연결을 확인해주세요.';
  static const String serverError = '서버 오류가 발생했습니다.';
  static const String loadFailed = '데이터를 불러오는데 실패했습니다.';
  static const String submitFailed = '제출에 실패했습니다.';
  static const String emptyName = '이름을 입력해주세요.';
  static const String incompleteTest = '모든 질문에 답변해주세요.';
}