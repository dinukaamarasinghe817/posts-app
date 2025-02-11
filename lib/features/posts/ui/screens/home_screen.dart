import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postapp/common/theme/colors.dart';
import 'package:postapp/common/theme/fonts.dart';
import 'package:postapp/common/widgets/input_field.dart';
import 'package:postapp/features/posts/providers/post_provider.dart';
import 'package:postapp/common/widgets/button.dart';
import 'package:postapp/features/posts/ui/widgets/postcard.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _showAddPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 16, bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: PostColors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                        height: 4,
                        width: 32,
                        decoration: const BoxDecoration(
                          color: PostColors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter Post Details',
                          style: PostFonts.headingSmall,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: IconButton.styleFrom(
                                hoverColor: Colors.transparent,
                                padding: EdgeInsets.zero),
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(children: [
                  const SizedBox(height: 20),
                  InputField(
                    labelText: 'Title',
                    controller: _titleController,
                    placeholderText: 'Enter the title',
                    type: InputType.separateTitle,
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    labelText: 'Description',
                    controller: _descriptionController,
                    placeholderText: 'Enter the description',
                    type: InputType.separateTitle,
                    isTextArea: true,
                  ),
                  const SizedBox(height: 20),
                  Button(
                    buttonText: 'Submit',
                    onPressed: () async {
                      final title = _titleController.text;
                      final description = _descriptionController.text;

                      final postService = ref.read(postServiceProvider);
                      final response =
                          await postService.createPost(title, description);

                      if (response != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Post created successfully!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to create post.')),
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsAsyncValue = ref.watch(postsProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Posts', style: PostFonts.headingMedium)),
      body: postsAsyncValue.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostBottomSheet(context),
        backgroundColor: PostColors.primaryColor,
        foregroundColor: PostColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(54.0), // Adjust the radius if needed
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
