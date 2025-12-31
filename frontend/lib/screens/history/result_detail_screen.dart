import 'package:flutter/material.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:go_router/go_router.dart';

/*
 * less 로 변경하기
 */

class ResultDetailScreen extends StatefulWidget {
  /*
     GoRoute(
        path:'/history',
        builder: (context, state) {
          final userName = state.extra as String; // 변경이 되지 않게 상수화 처리
          // return ResultDetailScreen(userName : state.extra as String)
          return ResultDetailScreen(userName : userName);
        }
      )
      /history라는 명칭으로 ResultDetailScreen widget 화면을 보려할 때,
      메인에서 작성한 명칭의 유저 MBTI 확인하고자 하나,
      const ResultDetailScreen({super.key}); 와 같이 작성할 경우에는
      기본 생성자이며, 매개변수 데이터를 전달받는 생성자가 아니기 때문에
      main.dart 에서 작성한 사용자 이름을 전달받지 못 하는 상황이 발생

      자바랑 다르게 생성자를 기본 생성자, 매개변수 생성자 다수의 생성자를 만들 경우
      반드시 생성자마다 명칭을 다르게 설정하며
      보통은 클래스이름.기본생성자({super.key});
            클래스이름.매개변수생성자({super.key, required this 전달받아_사용할_변수이름});
   */
  final String userName;
  const ResultDetailScreen({super.key, required this.userName});

  @override // 화면상태와 화면에서 상태 변경을 위한 위젯을 구분하여 만든 후 사용
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  // 변수 선언이나 기능 선언을 주로 작성
  List<Result> results = []; // results 선언
  bool isLoading = true;
  
  // ctrl + o initState
  @override // 기본적으로 초기상태를 생성하며, 추가적으로 호출할 기능도 함께 작성 재사용
  void initState() {
    super.initState();
    loadResults();
  }
  
  // 변수 사용 가능, 선언도 가능하지만 되도록이면 화면에 해당하는 ui 작성
  // 상태 변경이 필요한 변수 사용

  // 유저 이름에 따른 결과
  void loadResults() async { // loadResult's' 인 이유는 결과가 여러개일 수 있기 때문 홍길동이여럿일 수도 있으니까
    // apiservice 에서 만든 기능 호출하여 백엔드 결과를 가져오는 기능

    try {
      // data 는 지역변수, {}를 탈출할 경우 변수의 의미가 소멸되어 사용할 수 없음
      final data = await ApiService.getResultsByUserName(widget.userName); // ResultDetailScreen extends StatefulWidget에서 선언한 userName
      setState(() {
        // results는 전역변수로 Widget build 에 접근할 수 있는 변수 공간
        results = data; // 위에서 선언해준 results 값에 data 넣어줌
        // data 대신 아래를 넣어도 똑같지만 상태 변화로 인해 생기는 문제를 방지하고자 넣기
        // await ApiService.getResultsByUserName(widget.userName);

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("결과를 불러오지 못했습니다."))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 검사 기록'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
      // ListView.builder 는 itemCount가 없으면
      // 내부 목록 리스트를 몇 개 만들어야하는지 예상할 수 없으므로
      // RangeError 발생
      :results.isEmpty
        ? Center(
            child: Text(
                '검사 기록이 없습니다.',
                style: TextStyle(fontSize: 18),
            ),
          )
          :ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final r = results[index];
                return Card(
                  child: ListTile(
                    // 숙소 메인이미지
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        r.resultType,
                        style: TextStyle(color:Colors.white),
                      ),
                    ),
                    // 숙소 이름
                    title: Text(
                      r.resultType,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    // 예약 상세 정보
                    subtitle: Text(
                      'E:${r.eScore} I:${r.iScore} S:${r.sScore} N:${r.nScore}\nT:${r.tScore} F:${r.fScore} J:${r.jScore} P:${r.pScore}'
                    ),
                    // 상세정보 단순히 클릭하면 보인다는 아이콘 형태의 모형
                    trailing: Icon(Icons.arrow_forward),
                    // 한 줄의 어떤 곳을 선택하더라도 세부 정보를 확인할 수 있는 모달창 띄우기
                    // 예약 세부 내용이 담긴 모달창
                    onTap: () {
                      showDialog(
                          context: context, 
                          builder: (context) => AlertDialog(
                            title: Text(r.resultType),
                            content: Text('${r.typeName ?? r.resultType} \n\n ${r.description ?? "정보 없음"}'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text('닫기'))
                            ],
                          )
                      );
                    },
                  ),
                );
              }
          )
    );
  }
}

/*
개발자가 하나하나 직접적으로 목록을 작성해야할 경우 사용
-> 목차 목록 리스트 네비게이션 리스트

ListView(
  children: [
    Text('ABCD'),
    Text('EFGH'),
    Text('IJKL'),
  ],
)
개발자가 DB에서 데이터를 동적으로 가져올 때는
ListView.builder(
    itemCount : 총 개수,
    itemBuilder : (context, index) {
        return Text('항목 $index')
    }
)

RangeError (index): Invalid value: Only valid value is 0: 1
검사 기록이 비어있는지 확인

// ListView.builder는 itemCount 가 없으면
// 내부 목록 리스트를 몇 개 만들어야하는지 예상할 수 없으므로
// RangeError 발생

검사 기록이 0개 일 때 발생할 것
isEmpty 인 경우도 해결 UI 를 넣어줘야 한다.

RangeError (index): Index out of range: index should be less than 2: 2
인덱스 번호 확인? 이것도 itemCount 넣어주니까 없어지긴 했음
 */