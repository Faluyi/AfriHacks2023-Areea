import 'package:get/get.dart';

class PostController extends GetxController {
  // Your logic for managing posts goes here

  // Example: List to hold posts
  RxList<String> posts = <String>[].obs;

  // Method to add a new post
  void addPost(String post) {
    posts.add(post);
  }
}
