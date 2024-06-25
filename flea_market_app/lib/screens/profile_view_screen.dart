import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/user.dart';
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Base64デコード用

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

  Future<List<Product>> _getUserProducts(String email) async {
    final products = await dbHelper.fetchProducts();
    return products.where((product) => product.sellerEmail == email).toList();
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
                          backgroundImage:
                              MemoryImage(base64Decode(user.profileImage)),
                          onBackgroundImageError: (_, __) {
                            // Base64デコードエラー処理
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('画像のデコードに失敗しました')),
                            );
                          },
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
                    child: FutureBuilder<List<Product>>(
                      future: _getUserProducts(user.email),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Product>> productSnapshot) {
                        if (productSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (productSnapshot.hasError) {
                          return Center(child: Text('エラーが発生しました'));
                        } else if (!productSnapshot.hasData ||
                            productSnapshot.data!.isEmpty) {
                          return Center(child: Text('出品された商品がありません'));
                        } else {
                          final products = productSnapshot.data!;
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              final product = products[index];
                              return Column(
                                children: [
                                  Image.memory(
                                    base64Decode(product.imageUrl),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Base64デコードエラー処理
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey,
                                        child: Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 4),
                                  Text('${product.price}¥'),
                                  Text(
                                    'SOLD OUT',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              );
                            },
                          );
                        }
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
