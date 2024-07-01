import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/product.dart';
import '../models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class PurchaseScreen extends StatefulWidget {
  final int productId;

  PurchaseScreen({required this.productId});

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _buyerName = '';
  String _buyerAddress = '';
  String _buyerPhone = '';
  bool _isLoading = false;
  late Product _product;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
    });
    final product = await dbHelper.fetchProductById(widget.productId);
    setState(() {
      _product = product!;
      _isLoading = false;
    });
  }

  Future<void> _completePurchase() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // ダミーの決済プロセス
        await Future.delayed(Duration(seconds: 2)); // 2秒の遅延をシミュレーション

        _saveOrder();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('購入が完了しました')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('購入中にエラーが発生しました: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      final order = Order()
        ..productId = _product.key
        ..buyerEmail = email
        ..buyerName = _buyerName
        ..buyerAddress = _buyerAddress
        ..buyerPhone = _buyerPhone
        ..purchaseDate = DateTime.now().toString();

      await dbHelper.insertOrder(order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('購入画面'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Text(
                      _product.name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Image.file(
                      File(_product.imageUrl), // Use Image.file for file path
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '価格: ${_product.price}¥',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: '名前'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '名前を入力してください';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _buyerName = value!;
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
                        _buyerAddress = value!;
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
                        _buyerPhone = value!;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                _completePurchase();
                              }
                            },
                            child: Text('購入'),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
