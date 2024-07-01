import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 2)
class Order extends HiveObject {
  @HiveField(0)
  late int productId;

  @HiveField(1)
  late String buyerEmail;

  @HiveField(2)
  late String buyerName;

  @HiveField(3)
  late String buyerAddress;

  @HiveField(4)
  late String buyerPhone;

  @HiveField(5)
  late String purchaseDate;
}
