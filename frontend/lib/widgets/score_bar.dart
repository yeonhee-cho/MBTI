import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final String label1; // 변수 이름만 우선 선언
  final String label2;
  final int score1;
  final int score2;

  const ScoreBar({
    super.key,
    required this.label1,
    required this.label2,
    required this.score1,
    required this.score2
  });

  @override
  Widget build(BuildContext context) {
    int total = score1 + score2;
    double ratio1 = total > 0 ? score1 / total : 0.5;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label1: $score1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$label2: $score2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadiusDirectional.circular(8),
                child: LinearProgressIndicator(
                  value: ratio1,
                  minHeight: 20,
                  backgroundColor: Colors.orange[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}