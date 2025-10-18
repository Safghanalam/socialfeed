import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_media/models/comment_model.dart';
import '../models/post_model.dart';
import 'user_provider.dart';

class PostProvider extends ChangeNotifier {
  List<Post> posts = [];
  late Box<Post> _postBox;

  final List<String> simulatedUsers = ["Safghan", "Alice", "Bob"];

  PostProvider() {
    _init();
  }

  /// Initialize Hive box and migrate old posts
  Future<void> _init() async {
    _postBox = Hive.box<Post>('postsBox');

    posts = _postBox.values.map((post) {
      post.likedBy = post.likedBy ?? [];
      post.comments = post.comments ?? [];
      return post;
    }).toList();

    notifyListeners();
  }

  /// Add new post (Hive + local list)
  void addPost(Post post) {
    _postBox.add(post); // persist
    post.comments = post.comments ?? [];
    posts.insert(0, post); // add to top of local list
    notifyListeners();
  }

  /// Toggle like for current user
  void toggleLike(int index, String currentUser) {
    final post = posts[index];

    // Ensure likedBy list is initialized
    post.likedBy = post.likedBy ?? [];

    if (post.likedBy.contains(currentUser)) {
      post.likedBy.remove(currentUser);
      post.isLiked = false;
    } else {
      post.likedBy.add(currentUser);
      post.isLiked = true;
    }

    post.likes = post.likedBy.length;

    post.save(); // persist in Hive
    notifyListeners();
  }

  /// Clear all posts (for development)
  void clearPosts() {
    _postBox.clear();
    posts.clear();
    notifyListeners();
  }

  void addComment(int index, String username, String text) {
    final post = posts[index];
    final comment = Comment(
      username: username,
      text: text,
      timestamp: DateTime.now(),
    );

    post.comments.add(comment);
    post.save(); // now persists correctly
    notifyListeners();
  }


}
