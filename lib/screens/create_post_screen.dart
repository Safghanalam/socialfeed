import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/providers/user_provider.dart';

import '../models/post_model.dart';
import '../providers/post_provider.dart';


class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  File? _selectedImage;
  bool _isGenerating = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _generateCaption() async {
    setState(() => _isGenerating = true);

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final quote = data['quote']?.toString() ?? "Couldn’t fetch caption";
        _captionController.text = quote;
      } else {
        _captionController.text = "Failed to fetch caption";
      }
    } catch (e) {
      _captionController.text = "Error fetching caption";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating caption: $e')),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }


  void _submitPost() {
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a caption')),
      );
      return;
    }

    final currentUser = context.read<UserProvider>().currentUser;

    final newPost = Post(
      username: currentUser ?? '', // dynamic
      caption: _captionController.text.trim(),
      imagePath: _selectedImage?.path,
      timestamp: DateTime.now(),
    );


    context.read<PostProvider>().addPost(newPost);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: "Caption",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200, fit: BoxFit.cover),

            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text("Pick Image"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateCaption,
                  icon: _isGenerating
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.auto_awesome),
                  label: Text(_isGenerating ? "Generating..." : "AI Caption"),
                ),

              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitPost,
              icon: const Icon(Icons.send),
              label: const Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
