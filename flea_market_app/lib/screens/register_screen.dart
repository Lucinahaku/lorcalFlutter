import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../db_helper.dart';
import '../models/user.dart';
import 'dart:io';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  String _name = '';
  String _password = '';
  String _email = '';
  String _address = '';
  String _phone = '';
  String _bio = '';
  String? _profileImageUrl;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var user = User()
          ..username = _name
          ..email = _email
          ..password = _password
          ..profileImage = _profileImageUrl ?? ''
          ..bio = _bio
          ..address = _address
          ..phoneNumber = _phone
          ..likeCount = 0;
        await dbHelper.insertUser(user);
        _showSuccessDialog();
      } catch (e) {
        _showErrorDialog('登録に失敗しました。もう一度お試しください。');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('登録成功'),
          content: Text('新規登録が完了しました！'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // ログイン画面に戻る
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('登録失敗'),
          content: Text(message),
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final url = await _uploadImage(File(pickedFile.path));
      if (url != null) {
        setState(() {
          _profileImageUrl = url;
        });
      }
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('YOUR_SERVER_UPLOAD_URL'), // 画像をアップロードするサーバーのURL
    );
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      return jsonResponse['url']; // サーバーから返された画像のURLを取得
    } else {
      _showErrorDialog('画像のアップロードに失敗しました。');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規登録'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'ユーザー名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ユーザー名を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'パスワードを入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '住所'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '住所を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '電話番号'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '電話番号を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '自己紹介'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '自己紹介を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bio = value!;
                },
              ),
              SizedBox(height: 10),
              _profileImageUrl != null
                  ? Image.network(_profileImageUrl!)
                  : Icon(Icons.person, size: 100),
              TextButton(
                onPressed: _pickImage,
                child: Text('アカウント画像を選択'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _register();
                        }
                      },
                      child: Text('登録'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
