import 'package:flea_market_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/product.dart';
import '../widgets/product_card.dart'; // ProductCard ウィジェットをインポート
import 'dart:io';

class ProductGridScreen extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品一覧'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // 通知ボタンの処理
            },
          ),
          IconButton(
            icon: Icon(Icons.login), // ログインアイコンを追加
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen()), // ログイン画面に遷移する
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    // 「マイリスト」ボタンの処理
                  },
                  child: Text(
                    'マイリスト',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 「オススメ」ボタンの処理
                  },
                  child: Text(
                    'オススメ',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Product>>(
          future: dbHelper.fetchProducts(), // ここで適切なFutureを渡します
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('エラーが発生しました'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('商品がありません'));
            } else {
              final products = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      _showProductDialog(context, product);
                    },
                    child: ProductCard(product: product),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _showProductDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(File(product.imageUrl)),
              SizedBox(height: 10),
              Text('価格: ¥${product.price.toStringAsFixed(0)}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}
