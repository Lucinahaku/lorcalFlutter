import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/product.dart';
import 'models/order.dart';

class DatabaseHelper {
  static const String userBoxName = 'users';
  static const String productBoxName = 'products';
  static const String orderBoxName = 'orders';

  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(OrderAdapter());
    await Hive.openBox<User>(userBoxName);
    await Hive.openBox<Product>(productBoxName);
    await Hive.openBox<Order>(orderBoxName);
  }

  Future<void> insertUser(User user) async {
    var box = Hive.box<User>(userBoxName);
    await box.put(user.email, user);
  }

  List<User> fetchUsers() {
    var box = Hive.box<User>(userBoxName);
    return box.values.toList();
  }

  Future<User?> fetchUserByEmail(String email) async {
    var box = Hive.box<User>(userBoxName);
    return box.get(email);
  }

  Future<void> insertProduct(Product product) async {
    var box = Hive.box<Product>(productBoxName);
    await box.add(product);
  }

  Future<List<Product>> fetchProducts() async {
    var box = Hive.box<Product>(productBoxName);
    return box.values.toList();
  }

  Future<Product?> fetchProductById(int id) async {
    var box = Hive.box<Product>(productBoxName);
    return box.get(id);
  }

  Future<void> insertOrder(Order order) async {
    var box = Hive.box<Order>(orderBoxName);
    await box.add(order);
  }

  Future<void> updateUser(User user) async {
    var box = Hive.box<User>(userBoxName);
    await box.put(user.email, user);
  }

  Future<void> deleteUser(String email) async {
    var box = Hive.box<User>(userBoxName);
    await box.delete(email);
  }
}
