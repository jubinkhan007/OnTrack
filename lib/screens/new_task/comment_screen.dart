import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';
import 'package:tmbi/repo/new_task/comment_repo.dart';
import 'package:tmbi/widgets/error_container.dart';

import '../../config/converts.dart';
import '../../config/palette.dart';
import '../../models/new_task/comment_response.dart';
import '../../network/api_service.dart';
import '../../network/ui_state.dart';
import '../../viewmodel/new_task/comment_provider.dart';

class CommentsScreen extends StatelessWidget {
  final String staffId;
  final String inqId;
  final SubTask? subTask;

  const CommentsScreen(
      {super.key, required this.staffId, required this.inqId, this.subTask});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommentProvider(
          commentRepo: CommentRepo(
              dio: ApiService(
                      "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                  .provideDio()),
          staffId,
          inqId,
          subTask),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Palette.mainColor,
          title: Text(
            "Comments",
            style: TextStyle(fontSize: Converts.c16),
          ),
        ),
        body: SafeArea(
          child: Consumer<CommentProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  //const _TodayLabel(),
                  Expanded(child: _CommentsList(staffId, provider)),
                  _InputBar(provider, staffId, inqId, subTask),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TodayLabel extends StatelessWidget {
  const _TodayLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Today',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

class _CommentsList extends StatelessWidget {
  final String staffId;
  final CommentProvider provider;

  const _CommentsList(this.staffId, this.provider);

  @override
  Widget build(BuildContext context) {
    if (provider.uiState == UiState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.uiState == UiState.error) {
      return Center(
        child: ErrorContainer(
            message: provider.message ?? "(Something went wrong!)"),
      );
    }

    if (provider.commentList.isEmpty) {
      return const Center(
        child: ErrorContainer(message: "(No comments found)"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.commentList.length,
      itemBuilder: (_, index) {
        final comment = provider.commentList[index];
        return _CommentBubble(
          comment: comment,
          staffId: staffId,
        );
      },
    );
  }
}

class _CommentBubble extends StatelessWidget {
  final Comment comment;
  final String staffId;

  const _CommentBubble({required this.comment, required this.staffId});

  @override
  Widget build(BuildContext context) {
    final isMe = (comment.staffId ?? '') == staffId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            _Avatar(
              imageUrl:
                  "HTTP://HRIS.PRANGROUP.COM:8686/CONTENT/EMPLOYEE/EMP/${comment.staffId}/${comment.staffId}-0.jpg",
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  '${comment.name} • ${comment.dateTime?.split("T")[0]} • ${comment.dateTime?.split("T")[1]}',
                  style: TextStyle(
                    fontSize: Converts.c16 - 4,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue.shade100 : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(comment.body?.decoded ?? ""),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String imageUrl;

  const _Avatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Converts.c20,
      backgroundColor: Colors.blue.shade50,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: Converts.c40,
          height: Converts.c40,
          placeholder: (_, __) =>
              const Icon(Icons.person_outline, color: Colors.blue),
          errorWidget: (_, __, ___) =>
              const Icon(Icons.person_outline, color: Colors.blue),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final CommentProvider provider;
  final String staffId;
  final SubTask? subTask;
  final String inqId;

  const _InputBar(this.provider, this.staffId, this.inqId, this.subTask);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          //const Icon(Icons.attach_file),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: provider.commentController,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                provider.saveComment(inqId, staffId, subTask);
              },
            ),
          ),
        ],
      ),
    );
  }
}
