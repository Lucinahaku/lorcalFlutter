import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewScreen extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  Future<User?> _getUserProfile() async {
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
        title: Text('プロフィール閲覧'),
      ),
      body: FutureBuilder<User?>(
        future: _getUserProfile(),
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
                  Row(
                    children: [
                      if (user.profileImage.isNotEmpty)
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.profileImage),
                        )
                      else
                        CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.thumb_up, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                'x${user.likeCount}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '自己紹介',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(user.bio),
                  SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 6, // この部分はデータソースの長さに変更してください
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Image.network(
                              'https://example.com/your-image-url', // 実際の画像URLに置き換えてください
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 4),
                            Text('5000¥'),
                            Text('SOLD OUT',
                                style: TextStyle(color: Colors.red)),
                          ],
                        );
                      },
                    ),
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
