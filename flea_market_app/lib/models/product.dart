import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late double price;

  @HiveField(3)
  late String imageUrl;

  @HiveField(4)
  late String sellerEmail;
}
