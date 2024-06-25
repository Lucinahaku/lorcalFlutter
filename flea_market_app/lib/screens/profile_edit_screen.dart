import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db_helper.dart';
import '../models/user.dart';
import 'dart:convert'; // for base64 encoding

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  String _username = '';
  String _bio = '';
  String? _profileImageBase64;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      final user = await dbHelper.fetchUserByEmail(email);
      if (user != null) {
        setState(() {
          _username = user.username;
          _bio = user.bio;
          _profileImageBase64 = user.profileImage;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        _profileImageBase64 = base64Image;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email');
        if (email != null) {
          final user = User()
            ..email = email
            ..username = _username
            ..bio = _bio
            ..profileImage = _profileImageBase64 ?? ''
            ..password = ''; // パスワードを空の文字列として初期化

          await dbHelper.updateUser(user);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('プロフィールが更新されました')),
          );

          Navigator.of(context).pop();
        } else {
          throw Exception('ユーザーのメールアドレスが見つかりません');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新中にエラーが発生しました: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィール更新'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey[300],
                  child: _profileImageBase64 == null
                      ? Icon(Icons.camera_alt, size: 50)
                      : Image.memory(base64Decode(_profileImageBase64!),
                          fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'ユーザー名'),
                initialValue: _username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ユーザー名を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '自己紹介'),
                initialValue: _bio,
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
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _updateProfile();
                        }
                      },
                      child: Text('更新'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
