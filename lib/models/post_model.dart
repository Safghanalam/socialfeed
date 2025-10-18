import 'package:hive/hive.dart';
import 'package:social_media/models/comment_model.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String caption;

  @HiveField(2)
  String? imagePath;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  int likes;

  @HiveField(5)
  bool isLiked = false;

  @HiveField(6)
  List<String> likedBy; // non-nullable now

  @HiveField(7)
  List<Comment> comments; // add this to Post class

  Post({
    required this.username,
    required this.caption,
    this.imagePath,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
    List<String>? likedBy,
    List<Comment>? comments, // optional
  })  : likedBy = likedBy ?? [],
        comments = comments ?? [];
}

