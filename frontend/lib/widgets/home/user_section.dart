import 'package:flutter/material.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('UserSection is working'),
      ),
    );
  }
}