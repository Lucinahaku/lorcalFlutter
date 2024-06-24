import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db_helper.dart';
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProductUploadScreen extends StatefulWidget {
  @override
  _ProductUploadScreenState createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _productDescription = '';
  double _productPrice = 0.0;
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (email != null && _image != null) {
        final product = Product()
          ..name = _productName
          ..description = _productDescription
          ..price = _productPrice
          ..imageUrl = _image!.path
          ..sellerEmail = email;

        await DatabaseHelper().insertProduct(product);
        _showSuccessDialog();
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('出品完了'),
          content: Text('商品が正常に出品されました！'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 出品ページを閉じて前の画面に戻る
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('出品ページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  child: _image == null
                      ? Icon(Icons.camera_alt, size: 50)
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: '商品名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '商品名を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '商品の説明'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '商品の説明を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productDescription = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '販売価格'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '販売価格を入力してください';
                  }
                  if (double.tryParse(value) == null) {
                    return '有効な数字を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productPrice = double.parse(value!);
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('販売手数料 (50円 + 5%)'),
                trailing: Text(
                    '¥ ${(50 + (_productPrice * 0.05)).toStringAsFixed(2)}'),
              ),
              ListTile(
                title: Text('販売利益'),
                trailing: Text(
                    '¥ ${(_productPrice - 50 - (_productPrice * 0.05)).toStringAsFixed(2)}'),
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _uploadProduct();
                        }
                      },
                      child: Text('出品'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
