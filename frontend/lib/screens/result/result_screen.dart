import 'package:flutter/material.dart';

/*
 * 1. main 에 GoRoute 추가
 * path / result
 * extra 를 이용해서 결과 전달
 * ResultScreen(
 * userName : data['userName']!,
 * resultType: data['resultType']!
 * )
 */

class ResultScreen extends StatefulWidget {
  final String userName;
  final String resultType;

  const ResultScreen({super.key, required this.userName, required this.resultType});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ResultScreen is working'),
      ),
    );
  }
}