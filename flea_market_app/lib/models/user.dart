import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String email;

  @HiveField(2)
  String password = ''; // デフォルト値を設定

  @HiveField(3)
  late String profileImage;

  @HiveField(4)
  late String bio;

  @HiveField(5)
  late int likeCount;

  @HiveField(6)
  late String address;

  @HiveField(7)
  late String phoneNumber;
}
