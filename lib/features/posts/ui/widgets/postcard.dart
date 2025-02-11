import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postapp/common/theme/colors.dart';
import 'package:postapp/common/theme/fonts.dart';
import 'package:postapp/common/utils/extensions/capitalize.dart';
import 'package:postapp/common/widgets/input_field.dart';
import 'package:postapp/features/posts/data/modals/post.dart';
import 'package:postapp/features/posts/providers/post_provider.dart';
import 'package:postapp/common/widgets/button.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  void _showUpdatePostBottomSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: post.title);
    final descriptionController = TextEditingController(text: post.description);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only( left: 24, right: 24, top: 16, bottom: 8),
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
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Update Post Details',
                          style: PostFonts.headingSmall,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: IconButton.styleFrom(
                                hoverColor: Colors.transparent,
                                padding: EdgeInsets.zero
                            ),
                            icon: const Icon(
                                Icons.close
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    InputField(
                      labelText: 'Title',
                      controller: titleController,
                      placeholderText: 'Enter the title',
                      type: InputType.separateTitle,
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      labelText: 'Description',
                      controller: descriptionController,
                      placeholderText: 'Enter the description',
                      type: InputType.separateTitle,
                      isTextArea: true,
                    ),
                    const SizedBox(height: 20),
                    Button(
                      buttonText: 'Update',
                      onPressed: () async {
                        final updatedTitle = titleController.text;
                        final updatedDescription = descriptionController.text;
                        final postService = ref.read(postServiceProvider);
                        final response = await postService.updatePost(post.id, updatedTitle, updatedDescription);

                        // Handle the response (success/error)
                        if (response != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Post updated successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to update post.')),
                          );
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _deletePost(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Post', style: PostFonts.headingMedium,),
          content: Text('Are you sure you want to delete this post?', style: PostFonts.contentEmphasis,),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: PostFonts.contentEmphasis,),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete', style: PostFonts.contentEmphasis,),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final postService = ref.read(postServiceProvider);
      final response = await postService.deletePost(post.id);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete post.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: PostColors.neutral100, // Border color
          width: 1.5, // Border thickness
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.2),
        //     blurRadius: 16,
        //     offset: const Offset(0, 2),
        //     spreadRadius: 0,
        //   ),
        // ],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GestureDetector(
        onLongPress: () => _deletePost(context, ref),
        child: ListTile(
          title: Text(
              post.title.replaceAll('\n', ' ').capitalizeFirst(),
              style: PostFonts.highlightEmphasis),
          subtitle: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                post.description.replaceAll('\n', ' ').capitalizeFirst(),
                style: PostFonts.contentRegular.copyWith(
                color: PostColors.neutral400
              )),
            ],
          ),
          onTap: () => _showUpdatePostBottomSheet(context, ref),
        ),
      ),
    );
  }
}
