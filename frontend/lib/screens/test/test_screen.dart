import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestScreen extends StatefulWidget {
  final String userName;
  const TestScreen({super.key, required this.userName});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // 변수 선언
  // 데이터 선언
  // 기능 선언
  // 현재 질문 번호(1~12)
  int currentQuestion = 1;
  Map<int, String> answer = {}; // 답변 저장 {질문 번호 : 'A' or 'B'}

  // 나중에 API로 교체
  final List<Map<String, String>> questions = [
    {
      'text': '친구들과 노는 것이 좋다',
      'optionA': '매우 그렇다 (E)',
      'optionB': '혼자 있는 것이 좋다 (I)',
    },
    {
      'text': '계획을 세우는 것을 좋아한다',
      'optionA': '계획적이다 (J)',
      'optionB': '즉흥적이다 (P)',
    }
  ];
  
  // selectAnswer(String option) 
  // 선택할 답변 저장
  // 다음 질문으로 넘어가고 
  // 12문제가 끝나면 결과 화면 이동
  
  // void showResult(){}
  // 결과 확인
  // 검사 완료 검사 결과 처음으로 이동하는 로직 작성

  // ui
  @override
  Widget build(BuildContext context) {
    // 임시로 2문제만 있으므로 인덱스 처리를 잠시 하는 것이고 
    // 나중에는 삭제할 코드들
    int questionIndex = currentQuestion - 1;
    if(questionIndex >= questions.length) {
      questionIndex = questions.length - 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 검사'),
        leading: IconButton(onPressed: () => context.go('/'),
            icon: Icon(Icons.arrow_back)),
      ),
      body:
      Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 진행도
            // ${변수이름.내부속성이름}
            // $변수이름단독하나
            Text(
              '질문 $currentQuestion / 12',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // 진행바
            // currentQuestion / 12 = 처음 시작을 하고 있기 때문에 진행 중인 표기
            // minHeight : 10 = 최소 유지해야하는 프로그래스바의 세로 크기
            LinearProgressIndicator(
              value: currentQuestion / 12,
              minHeight: 10,
            ),
            SizedBox(height: 20),

            // 질문
            Text(
              /**
               * 만약에 데이터가 없을 경우에는 질문 없음 이라는 표기를 Text 내부에 사용
               * questions[questionIndex]['text'] ?? '질문 없음',
               *
               * questions[questionIndex]['text']!,
               * -> data 가 null 이 아니고 반드시 존재한다 라는 표기를 작성
               *
               * questions[questionIndex]['text'] as String,
               */
              questions[questionIndex]['text'] ?? '질문 없음',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(onPressed: ()=> context.go('/selectAnswer로 추후 교체'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                  child: Text(questions[questionIndex]['optionA']!,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  onPressed: () => context.go('/selectAnswer로 추후 교체') ,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                  ),
                  child: Text(questions[questionIndex]['optionB']!,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}