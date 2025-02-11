import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postapp/core/api/api_service_provider.dart';
import 'package:postapp/features/posts/data/modals/post.dart';
import 'package:postapp/features/posts/data/services/post_service.dart';

final postServiceProvider = Provider<PostService>((ref) {
  final apiService = ref.read(apiServiceProvider); // Access ApiService
  return PostService(apiService);
});

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final postService = ref.read(postServiceProvider);
  return await postService.fetchPosts();
});
