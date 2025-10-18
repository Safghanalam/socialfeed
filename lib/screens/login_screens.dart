import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'feed_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = ["Safghan", "Alice", "Bob"];

    return Scaffold(
      appBar: AppBar(title: const Text("SocialFeed+ Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select User to Login",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...users.map(
                  (username) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Set current user in provider
                    context.read<UserProvider>().login(username);
                    // Navigate to feed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const FeedScreen()),
                    );
                  },
                  child: Text(username),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
