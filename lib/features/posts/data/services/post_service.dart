import 'package:dio/dio.dart';
import 'package:postapp/core/api/api_service.dart';
import 'package:postapp/features/posts/data/modals/post.dart';

class PostService {
  final ApiService apiService;
  PostService(this.apiService);

  // Fetch all posts
  Future<List<Post>> fetchPosts() async {
    final response = await apiService.getRequest('posts');
    return (response.data as List).map((item) => Post.fromJson(item)).toList();
  }

  // Create a new post
  Future<Response?> createPost(String title, String description) async {
    try {
      final response = await apiService.postRequest(
        'posts',
        body: {
          "userId": 1,
          'title': title,
          'body': description,
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Update an existing post
  Future<Response?> updatePost(int postId, String title, String description) async {
    try {
      final response = await apiService.putRequest(
        '/posts/$postId',
        body: {
          'title': title,
          'description': description,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // Delete a post
  Future<Response?> deletePost(int postId) async {
    try {
      final response = await apiService.deleteRequest(
        '/posts/$postId',
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
