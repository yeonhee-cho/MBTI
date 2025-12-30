import 'package:flutter/material.dart';
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
class ResultScreen extends StatelessWidget {
  final String userName;
  final String resultType;

  const ResultScreen({
    super.key,
    required this.userName,
    required this.resultType
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검사 결과'),
        automaticallyImplyLeading: false,  // 뒤로가기 버튼 숨김
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 축하 아이콘
              Icon(
                  Icons.celebration,
                  size: 100,
                  color: Colors.amber
              ),
              SizedBox(height: 30),

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
                      '${userName}님의 MBTI는 '
                    ),
                    SizedBox(height: 20),

                    // MBTI 결과 (큰 글씨로)
                    Text(
                      '${resultType}',
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