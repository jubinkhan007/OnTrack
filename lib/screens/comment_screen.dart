import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/comment_response.dart';

import '../config/converts.dart';
import '../config/strings.dart';
import '../widgets/widgets.dart';

class CommentScreen extends StatefulWidget {
  static const String routeName = '/comment_screen';
  final String commentId;

  const CommentScreen({super.key, required this.commentId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _bodyController = TextEditingController();

  final List<Comments> comments = [
    Comments(
        id: "1",
        body:
            "Lorem Ipsum is simply dummy text, Lorem Ipsum is simply dummy text, Lorem Ipsum is simply dummy text",
        date: "9 Oct, 24",
        time: "7:12 AM",
        owner: Owner(id: "101", name: "Mr. Alan")),
    Comments(
        id: "2",
        body: "Sample looks good",
        date: "9 Oct, 24",
        time: "8:12 AM",
        owner: Owner(id: "102", name: "Akash")),
    Comments(
        id: "3",
        body: "Need more sample",
        time: "9:12 AM",
        date: "9 Oct, 24",
        owner: Owner(id: "103", name: "Md. Alamgir")),
  ];

  void _addComment() {
    if (_bodyController.text.isNotEmpty) {
      setState(() {
        comments.add(Comments(
            id: "1",
            body: _bodyController.text,
            date: "29 Oct, 24",
            time: "4:12 PM",
            owner: Owner(id: "101", name: "Md. Salauddin")));

        _bodyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        centerTitle: false,
        title: TextViewCustom(
          text: Strings.post_comment,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          // Customize icon color
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentList(comments: comments[index]);
              },
            ),
          ),
          const Divider(
            thickness: 0.5, // Thickness of the line
            color: Palette.semiNormalTv, // Color of the line
          ),
          Padding(
            padding: EdgeInsets.only(left: Converts.c8, right: Converts.c8),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldInquiry(
                    fontSize: Converts.c16,
                    fontColor: Palette.normalTv,
                    hintColor: Palette.semiNormalTv,
                    hint: Strings.type_a_comment,
                    controller: _bodyController,
                    maxLine: 1,
                    hasBorder: false,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Palette.mainColor,
                  ),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
