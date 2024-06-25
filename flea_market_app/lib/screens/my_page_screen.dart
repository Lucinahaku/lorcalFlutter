import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_view_screen.dart';
import 'profile_edit_screen.dart';
import 'personal_info_view_screen.dart';
import 'sales_management_screen.dart';
import 'purchase_history_screen.dart';
import 'chat_history_screen.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('プロフィール閲覧'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileViewScreen()),
              );
            },
          ),
          ListTile(
            title: Text('プロフィール更新'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileEditScreen()),
              );
            },
          ),
          ListTile(
            title: Text('個人情報確認'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PersonalInfoViewScreen()),
              );
            },
          ),
          ListTile(
            title: Text('売り上げ管理'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SalesManagementScreen()),
              );
            },
          ),
          ListTile(
            title: Text('購入履歴'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PurchaseHistoryScreen()),
              );
            },
          ),
          ListTile(
            title: Text('チャット履歴'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatHistoryScreen()),
              );
            },
          ),
          ListTile(
            title: Text('ログアウト'),
            onTap: () async {
              await _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('email');
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}
