import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  // this.message 는 선택적으로 사용 가능한 생성자
  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          if(message != null) ...[
           SizedBox(height: 24),
           Text(
             message!,
             style: TextStyle(
               fontSize: 18,
               color: Colors.grey[600]
             ),
           )
          ]
        ],
      ),
    );
  }
}