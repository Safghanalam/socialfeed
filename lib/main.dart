import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_media/models/comment_model.dart';
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/screens/login_screens.dart';
import 'models/post_model.dart';
import 'providers/post_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CommentAdapter());
  await Hive.openBox<Post>('postsBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SocialFeed+',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: LoginScreen(),
      ),
    );
  }
}
