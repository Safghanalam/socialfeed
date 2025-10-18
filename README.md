# 🌐 SocialFeed+ — A Mini Social Media App with AI Caption Generator

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Hive](https://img.shields.io/badge/Database-Hive-yellow)
![Provider](https://img.shields.io/badge/State-Provider-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📘 Overview

**SocialFeed+** is a lightweight social media feed app built with **Flutter**.  
It allows users to log in with dummy credentials, create and view posts, generate **AI-powered captions**, like, and comment on posts — all persisted **locally using Hive**.

The app showcases **Flutter fundamentals**, **state management**, **offline storage**, and **UI/UX design** best practices.

---

## 🚀 Features

| Feature | Description |
|----------|-------------|
| 🔐 **Login System** | Dummy users (`Safghan`, `Alice`, `Bob`) with preset credentials. |
| 📰 **Feed Screen** | Displays all user posts, images, likes, and comments. |
| ✍️ **Create Post** | Add caption, upload an image, or use AI Caption Generator. |
| 🤖 **AI Caption Generator** | Fetches mock AI captions from an online API. |
| ❤️ **Like System** | Interactive like/unlike button with animation. |
| 💬 **Comments** | Add and view comments on each post. |
| 💾 **Local Persistence** | Uses Hive to store posts, comments, and likes. |
| 🌙 **Theme Consistency** | Clean light theme across all screens. |
| ⚡ **Animations** | Smooth like scaling animation for UX polish. |
| 🧹 **Debug Utility** | Clear all posts for quick testing. |

---

## 🧩 Architecture

```
lib/
├── main.dart
├── models/
│   ├── post_model.dart
│   └── comment_model.dart
├── providers/
│   ├── post_provider.dart
│   └── user_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── feed_screen.dart
│   ├── create_post_screen.dart
│   └── post_item.dart
└── utils/
    └── api_service.dart
```

---

## 🧠 Core Components

### 🗂️ `Post` Model
Represents a user post stored in Hive.

```dart
@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0) String username;
  @HiveField(1) String caption;
  @HiveField(2) String? imagePath;
  @HiveField(3) DateTime timestamp;
  @HiveField(4) int likes;
  @HiveField(5) bool isLiked;
  @HiveField(6) List<String> likedBy;
  @HiveField(7) List<Comment> comments;
}
```

### 💬 `Comment` Model
Represents individual comments on posts.

```dart
@HiveType(typeId: 1)
class Comment extends HiveObject {
  @HiveField(0) String username;
  @HiveField(1) String text;
  @HiveField(2) DateTime timestamp;
}
```

---

## 🧠 Providers

### 🧩 `PostProvider`
Handles creation, liking, commenting, and deletion of posts.

```dart
class PostProvider extends ChangeNotifier {
  List<Post> posts = [];
  void addPost(Post post);
  void toggleLike(int index, String user);
  void addComment(int index, String user, String text);
  void clearPosts();
}
```

### 👤 `UserProvider`
Manages user authentication state.

```dart
class UserProvider extends ChangeNotifier {
  String _currentUser = "Alice";
  void login(String username);
}
```

---

## 🖥️ UI Screens

### 🔐 **Login Screen**
- Allows users to input or autofill credentials.
- Dummy users: `John`, `Alice`, `Bob`.
- Uses copy icon to auto-fill email/password fields.

### 🏠 **Feed Screen**
- Displays list of posts from `PostProvider`.
- Each post includes username, caption, image, like button, and comments.

### ✍️ **Create Post Screen**
- Input caption and upload optional image.
- Use AI Caption Generator button for automatic captions.

### 🧩 **Post Item Widget**
- Displays each post card.
- Handles like animation, comment modal, and display layout.

---

## 🤖 AI Caption Generator

- Located in `utils/ai_caption_service.dart`
- Fetches mock AI captions from:
  ```
  https://dummyjson.com/quotes
  ```
- Demonstrates async network call and error handling.

---

## 💾 Local Storage (Hive)

- **Boxes Used:**
    - `postsBox` → Stores all posts, comments, likes.
- Data persists even after app restarts.

✅ **Why Hive?**
- Super-fast NoSQL database.
- Perfect for local offline apps.
- No need for backend setup.

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|-------------|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | Provider |
| Local Storage | Hive |
| Networking | HTTP |
| Image Picker | image_picker |
| Date Formatting | intl |
| Animations | Flutter built-in (ScaleTransition) |

---

## 🧪 Debugging & Developer Utilities

- `clearPosts()` in `PostProvider` to delete all stored posts.
- Dummy users allow switching accounts easily.

---

## 🧾 Summary

**SocialFeed+** demonstrates:
- ✅ Strong understanding of Flutter state management.
- ✅ Offline persistence using Hive.
- ✅ Smooth animations and intuitive UI.
- ✅ Local feed system with comments and likes.
- ✅ API integration for simulated AI captions.

---

## 🛠️ Setup & Run

### 📦 Install Dependencies
```bash
flutter pub get
```

### 🧱 Generate Hive Adapters
```bash
flutter packages pub run build_runner build
```

### ▶️ Run App (Debug)
```bash
flutter run
```

### 🏗️ Build Release (Android)
```bash
flutter build apk --release
```

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).

---

### 👨‍💻 Author
**Safghan Alam**  
Software Developer | Flutter Enthusiast  
🚀 *“Building clean, fast, and delightful mobile experiences.”*
