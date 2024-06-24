import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/product_grid_screen.dart';
import 'screens/product_upload_screen.dart';
import 'screens/my_page_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_view_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/sales_management_screen.dart';
import 'screens/purchase_history_screen.dart';
import 'screens/chat_history_screen.dart';
import 'db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase(); // データベースを初期化
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flea Market App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              return MainScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainScreen(),
        '/profile_view': (context) => ProfileViewScreen(),
        '/profile_edit': (context) => ProfileEditScreen(),
        '/personal_info': (context) => PersonalInfoScreen(),
        '/sales_management': (context) => SalesManagementScreen(),
        '/purchase_history': (context) => PurchaseHistoryScreen(),
        '/chat_history': (context) => ChatHistoryScreen(),
        '/product_upload': (context) => ProductUploadScreen(),
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    ProductGridScreen(),
    ProductUploadScreen(), // 出品ページを追加
    MyPageScreen(),
    LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera,
              color: _currentIndex == 1 ? Colors.blue : Colors.grey,
            ),
            label: '出品',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            label: 'マイページ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.login,
              color: _currentIndex == 3 ? Colors.blue : Colors.grey,
            ),
            label: 'ログイン',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
