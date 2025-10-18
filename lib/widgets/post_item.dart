import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

// Wrap IconButton with Stateful widget animation
class LikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.isAnimating) return;
    _controller.forward(from: 0.0).then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: IconButton(
        icon: Icon(
          widget.isLiked ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: _onTap,
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;
  final int index;

  const PostItem({super.key, required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUser = context.watch<UserProvider>().currentUser;

    // Ensure likedBy and comments lists are never null
    post.likedBy = post.likedBy ?? [];
    post.comments = post.comments ?? [];

    final commentController = TextEditingController();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + username + timestamp
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Text(post.username[0].toUpperCase()),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, h:mm a').format(post.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Caption
            Text(
              post.caption,
              style: const TextStyle(fontSize: 15, height: 1.3),
            ),

            const SizedBox(height: 10),

            // Image (optional)
            if (post.imagePath != null && File(post.imagePath!).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(post.imagePath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 10),

            // Like & Comment row
            Row(
              children: [
                LikeButton(
                  isLiked: post.likedBy.contains(currentUser),
                  onTap: () => postProvider.toggleLike(index, currentUser ?? ''),
                ),
                Text('${post.likes}'),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    final commentController = TextEditingController();

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ match app
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Comments',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView(
                                  children: [
                                    if (post.comments.isNotEmpty)
                                      ...post.comments.map(
                                            (comment) => ListTile(
                                          title: Text(comment.username,
                                              style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyLarge?.color)),
                                          subtitle: Text(comment.text,
                                              style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyMedium?.color)),
                                          trailing: Text(
                                              DateFormat('h:mm a').format(comment.timestamp),
                                              style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodySmall?.color)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        autofocus: true,
                                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                        decoration: InputDecoration(
                                          hintText: 'Add a comment...',
                                          hintStyle: TextStyle(color: Colors.grey.shade500),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () {
                                        if (commentController.text.trim().isEmpty) return;
                                        postProvider.addComment(
                                          index,
                                          context.read<UserProvider>().currentUser??'',
                                          commentController.text.trim(),
                                        );
                                        commentController.clear();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),


              ],
            ),

            // Display comments
            if (post.comments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: post.comments.map((comment) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        '${comment.username}: ${comment.text}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Optional: Show “Liked by” users
            if (post.likedBy.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Liked by: ${post.likedBy.join(", ")}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
