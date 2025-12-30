import 'package:flutter/material.dart';

class ResultDetailScreen extends StatefulWidget {
  const ResultDetailScreen({super.key});

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ResultDetailScreen is working'),
      ),
    );
  }
}