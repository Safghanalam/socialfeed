import 'package:hive/hive.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 1) // unique typeId
class Comment extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime timestamp;

  Comment({
    required this.username,
    required this.text,
    required this.timestamp,
  });
}