import 'package:flutter/material.dart';
import 'package:frontend/models/question_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/error_view.dart';
import 'package:frontend/widgets/loading_view.dart';
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
  List<Question> questions = []; // 백엔드에서 가져 온 질문들이 들어갈 배열 목록 세팅

  int currentQuestion = 0; // 보통 0부터 시작하기 때문에 0으로 설정
  Map<int, String> answers = {}; // 답변 저장 {질문 번호 : 'A' or 'B'}
  bool isLoading = true;
  String? errorMessage;

  // ctrl + o
  @override
  void initState() {
    super.initState();
    // 화면이 보이자마자 세팅을 할 것인데 백엔드 데이터 질문 가져오기
    loadQuestions();
  } // 백엔드 데이터를 가지고 올 동안 잠시 대기하는 로딩 중

  // 질문 백엔드에서 불러오는 기능
  void loadQuestions() async {
    try {
      final data = await ApiService.getQuestions();
      setState(() {
        questions = data;
        isLoading = false;
        errorMessage = null; // 데이터 무사히 들고 왔으면 null 처리
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage='질문을 불러오는데 실패했습니다.';
      });
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
      answers[questions[currentQuestion].id] = option; // 답변 저장

      // DB에 존재하는 총 길이의 -1 까지의 수보다 작으면
      // index 는 0부터 존재하기 때문에 총 길이의 -1까지가 DB 데이터
      if(currentQuestion < questions.length -1) {
        currentQuestion++;// 다음 질문으로 넘어가고
      } else {
        submitTest();
        // 결과 화면으로 이동처리
        // _showResult();
        // 잠시 결과 화면을 보여주는 함수 호출
        // screens 에 /result/result_screen 명칭으로
        // 폴더와 파일 생성 후, main router 설정해준다음
        // context.go('/result'); 로 이동 처리
        // main 에서는 builder 에 answers 결과까지 함께 전달
      }
    });
  }

  // 결과를 백엔드에 저장하기
  void submitTest() async {
    try {
      final result = await ApiService.submitTest(widget.userName, answers);

      // mounted : 화면이 존재한다면과 같은 기능
      /*
      if(mounted) {
        context.go("/result", extra: {
          'userName' : widget.userName,
          'resultType' : result.resultType,
          'eScore': result.eScore,
          'iScore': result.iScore,
          'sScore': result.sScore,
          'nScore': result.nScore,
          'tScore': result.tScore,
          'fScore': result.fScore,
          'jScore': result.jScore,
          'pScore': result.pScore,
        });
      }
      */
      if(mounted) {
        context.go("/result", extra:result);
      }

      /*
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('검사 완료'),
            content: Text(
              '${widget.userName}님은 ${result['resultType']} 입니다.'
            ),
            actions: [
              TextButton(
                  onPressed: () => context.go("/"),
                  child: Text('처음으로')
              )
            ],
          )
      );
       */
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제출 실패했습니다."))
      );
    }
  }

  // 결과 화면을 Go_Router 설정할 수도 있고,
  // 함수 호출을 이용하여 임시적으로 결과에 대한 창을 띄울 수 있다.
  // _showResult = private 형태로 외부에서 사용할 수 없는 함수
  void _showResult(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog (
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
    // 백엔드에서 데이터를 가져오는 중인 경우 로딩 화면
    if(isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('불러오는 중...')),
        body: LoadingView(message: '질문을 불러오는 중입니다.'),
      );
    }

    if(errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text("오류 발생")),
        // 현재 페이지에서 작성되어있는 에러 메세지를 전달
        // 클라이언트가 다시 시도 버튼을 클릭하면 loadQuestions 을 전달? TODO
        body: ErrorView(message: errorMessage!, onRetry: loadQuestions),
      );
    }

    // 임시로 2문제만 있으므로 인덱스 처리를 잠시 하는 것이고 
    // 나중에는 삭제할 코드들
    int questionIndex = currentQuestion - 1;

    if(questionIndex >= questions.length) {
      questionIndex = questions.length - 1;
    }

    // 백엔드에서 가져 온 데이터 중에서 현재 질문에 해당하는 데이터를
    // q 변수 이름에 담기
    // var q = questions[currentQuestion];
    Question q = questions[currentQuestion];

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
              '질문 ${currentQuestion + 1} / ${questions.length}',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // 진행바
            // currentQuestion / 12 = 처음 시작을 하고 있기 때문에 진행 중인 표기
            // minHeight : 10 = 최소 유지해야하는 프로그래스바의 세로 크기
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
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
              q.questionText,
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
                  child: Text(q.optionA,
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
                  child: Text(q.optionB,
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