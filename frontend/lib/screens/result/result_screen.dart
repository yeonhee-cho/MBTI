import 'package:flutter/material.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/widgets/score_bar.dart';
import 'package:go_router/go_router.dart';

/*
 * 1. main 에 GoRoute 추가
 * path / result
 * extra 를 이용해서 결과 전달
 * ResultScreen(
 * userName : data['userName']!,
 * resultType: data['resultType']!
 * )
 */

// result 스크린에서 채팅을 하거나, 숫자값을 추가하거나 실질적으로 화면 자체에서 변경되는 데이터가 없으므로
// StateLessWidget 으로 작성이 가능하다.
// SingleChildScrollView 가 있는 순간 화면은 움직이는 화면이기 때문에 less 사용 불가

// TODO 로딩 중 화면 메세지 없이 import 하여 개발자가 원하는 본인 방식대로 추가
// ErrorView 추가 errorMessage = "검사 기록을 불러오는데 실패했습니다"
class ResultScreen extends StatefulWidget {
  final Result result;

  const ResultScreen({
    super.key,
    required this.result
  });

  /*
  final String userName;
  final String resultType;
  final int eScore;
  final int iScore;
  final int sScore;
  final int nScore;
  final int tScore;
  final int fScore;
  final int jScore;
  final int pScore;

  const ResultScreen({
    super.key,
    required this.userName,
    required this.resultType,
    required this.eScore,
    required this.iScore,
    required this.sScore,
    required this.nScore,
    required this.tScore,
    required this.fScore,
    required this.jScore,
    required this.pScore,
  });
  */
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검사 결과'),
        automaticallyImplyLeading: false,  // 뒤로가기 버튼 숨김
      ),
      body: Center(
        /*SingleChildScrollView -> ListView*/
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 축하 아이콘
              Icon(
                  Icons.celebration,
                  size: 20,
                  color: Colors.amber
              ),
              // "검사 완료" 제목
              Text(
                  '검사 완료',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 40),

              // 결과 박스
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.blue,
                      width: 2
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.result.userName}님의 MBTI는 '
                    ),
                    SizedBox(height: 20),

                    // MBTI 결과 (큰 글씨로)
                    Text(
                      '${widget.result.resultType}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    SizedBox(height: 10),

                    // '입니다' 텍스트
                    Text('입니다'),
                  ],
                ),
              ),
              SizedBox(height: 60),
              /*
              패딩 상하좌우 20
              글자색상 회색[50]
              모서리둥글기 15
              실선 회색 300
              Column crossAxiosAligment start 로 주기
              */
              Container(
                padding: EdgeInsets.all(20),
                decoration:BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[300]!
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('상세 점수'),
                    SizedBox(height: 16),
                    ScoreBar(
                      label1: 'E (외향)',
                      label2: 'I (내향)',
                      score1: widget.result.eScore,
                      score2: widget.result.iScore,
                    ),
                    ScoreBar(
                      label1: 'S (직관)',
                      label2: 'N (감각)',
                      score1: widget.result.sScore,
                      score2: widget.result.nScore,
                    ),
                    ScoreBar(
                      label1: 'T (사고)',
                      label2: 'F (감정)',
                      score1: widget.result.tScore,
                      score2: widget.result.fScore,
                    ),
                    ScoreBar(
                      label1: 'J (판단)',
                      label2: 'P (인식)',
                      score1: widget.result.jScore,
                      score2: widget.result.pScore,
                    ),
                  ],
                ),
              ),

              // 처음으로 버튼
              SizedBox(
                width: 300,
                height: 50,
                child :ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: Text('처음으로')
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}