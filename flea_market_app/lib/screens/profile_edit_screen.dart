import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db_helper.dart';
import '../models/user.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  String _username = '';
  String _bio = '';
  String? _profileImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      final user = await dbHelper.fetchUserByEmail(email);
      if (user != null) {
        setState(() {
          _username = user.username;
          _bio = user.bio;
          _profileImagePath = user.profileImage;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (email != null) {
        final user = User()
          ..username = _username
          ..email = email
          ..bio = _bio
          ..profileImage = _profileImagePath ?? ''
          ..address = ''
          ..phoneNumber = ''
          ..likeCount = 0;
        await dbHelper.updateUser(user);
        Navigator.of(context).pop();
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
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
              SizedBox(height: 10),
              _profileImagePath != null
                  ? Image.file(File(_profileImagePath!))
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
