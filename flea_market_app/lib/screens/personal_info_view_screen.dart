import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db_helper.dart';
import '../models/user.dart';
import 'personal_info_edit_screen.dart';

class PersonalInfoViewScreen extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  Future<User?> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      return await dbHelper.fetchUserByEmail(email);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('個人情報確認'),
      ),
      body: FutureBuilder<User?>(
        future: _getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('データがありません'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('メール: ${user.email}'),
                  SizedBox(height: 8),
                  Text('住所: ${user.address}'),
                  SizedBox(height: 8),
                  Text('電話番号: ${user.phoneNumber}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoEditScreen(),
                        ),
                      );
                    },
                    child: Text('情報を更新する'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
