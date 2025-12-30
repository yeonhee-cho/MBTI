import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
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
  List<dynamic> questions = []; // 백엔드에서 가져 온 질문들이 들어갈 배열 목록 세팅

  int currentQuestion = 0; // 보통 0부터 시작하기 때문에 0으로 설정
  Map<int, String> answers = {}; // 답변 저장 {질문 번호 : 'A' or 'B'}
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // 화면이 보이자마자 세팅을 할 것인데 백엔드 데이터 질문 가져오기
    // 질문을 백엔드에서 불러오는 기능
    loadQuestions();
  } // 백엔드 데이터를 가지고 올 동안 잠시 대기하는 로딩 중

  void loadQuestions() async {
    try {
      final data = await ApiService.getQuestions();
      setState(() {
        questions = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = true;
    }
  }

  /*
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
  */

  void selectAnswer(String option) {
    setState(() {
      answers[currentQuestion] = option; // 답변 저장
      
      if(currentQuestion < 12) {
        currentQuestion++;// 다음 질문으로 넘어가고
      } else {
        // 결과 화면으로 이동처리
        _showResult();
        // 잠시 결과 화면을 보여주는 함수 호출
        // screens 에 /result/result_screen 명칭으로
        // 폴더와 파일 생성 후, main router 설정해준다음
        // context.go('/result'); 로 이동 처리
        // main 에서는 builder 에 answers 결과까지 함께 전달
      }
    });
  }

  // 결과 화면을 Go_Router 설정할 수도 있고,
  // 함수 호출을 이용하여 임시적으로 결과에 대한 창을 띄울 수 있다.
  // _showResult = private 형태로 외부에서 사용할 수 없는 함수
  void _showResult(){
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text('검사완료'),
          content: Text(
            '${widget.userName}님의 답변 : \n ${answers.toString()}'
          ),
          actions: [
            TextButton(
                onPressed: () {
                  context.go('/'); // 처음으로
                },
                child: Text('처음으로')
            )
          ],
        )
    );
  }
  
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
              child: ElevatedButton(
                  onPressed: () => selectAnswer('A'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                  child: Text(questions[questionIndex]['optionA']!,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  )
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  onPressed: () => selectAnswer('B') ,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                  ),
                  child: Text(questions[questionIndex]['optionB']!,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}