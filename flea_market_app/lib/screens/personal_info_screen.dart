import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db_helper.dart';
import '../models/user.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  String _address = '';
  String _phoneNumber = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPersonalInfo();
  }

  Future<void> _loadPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      final user = await dbHelper.fetchUserByEmail(email);
      if (user != null) {
        setState(() {
          _address = user.address;
          _phoneNumber = user.phoneNumber;
        });
      }
    }
  }

  Future<void> _updatePersonalInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (email != null) {
        final user = User()
          ..username = ''
          ..email = email
          ..bio = ''
          ..profileImage = ''
          ..address = _address
          ..phoneNumber = _phoneNumber
          ..likeCount = 0;
        await dbHelper.updateUser(user);
        Navigator.of(context).pop();
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('個人情報確認＆更新'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '住所'),
                initialValue: _address,
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
                initialValue: _phoneNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '電話番号を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _updatePersonalInfo();
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
