import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileMenu extends StatelessWidget {
  final String? userName;
  final VoidCallback onLogout;

  const ProfileMenu({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.account_circle),
      onSelected: (value) {
        if (value == 'logout') {
          onLogout();
        } else if (value == 'history') {
          context.go("/history", extra: userName);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(child: Text('$userName님')),
        PopupMenuItem(child: Text('내 기록 보기'), value: 'history'),
        PopupMenuDivider(),
        PopupMenuItem(
          child: Text(
            '로그아웃',
            style: TextStyle(color: Colors.red),
          ),

          value: 'logout',
        ),
      ],
    );
  }
}