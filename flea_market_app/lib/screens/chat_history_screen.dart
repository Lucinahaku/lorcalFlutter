import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット履歴'),
      ),
      body: Center(
        child: Text('チャット履歴画面です。'),
      ),
    );
  }
}
