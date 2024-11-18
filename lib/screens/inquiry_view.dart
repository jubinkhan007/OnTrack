import 'package:flutter/material.dart';
import 'package:tmbi/config/strings.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class InquiryView extends StatelessWidget {
  static const String routeName = '/inquiry_screen';
  final InquiryResponse inquiryResponse;
  final String flag;

  const InquiryView({super.key, required this.inquiryResponse, required this.flag});

  int _countPendingTask() {
    int count = 0;
    for (var value in inquiryResponse.tasks) {
      if (value.isUpdated) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Palette.mainColor,
            title: TextViewCustom(
              text: Strings.inquiry_view,
              fontSize: Converts.c20,
              tvColor: Colors.white,
              isTextAlignCenter: false,
              isBold: true,
            ),
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              // Customize icon color
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Converts.c16,
              right: Converts.c16,
              top: Converts.c16,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _iconView(Icons.folder_open_outlined, "${Strings.project}:",
                      inquiryResponse.title),
                  const SizedBox(
                    height: 4,
                  ),
                  _iconView(Icons.account_circle_outlined, "${Strings.owner}:",
                      "${inquiryResponse.postedBy.name} & ${inquiryResponse.customer.name}"),
                  const SizedBox(
                    height: 4,
                  ),
                  _iconView(Icons.note_outlined, "${Strings.overview}:", ""),
                  const SizedBox(
                    height: 4,
                  ),
                  TextViewCustom(
                    text: inquiryResponse.description,
                    fontSize: Converts.c16,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isBold: false,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  _iconView(Icons.timer_outlined, "${Strings.date}:",
                      inquiryResponse.endDate),
                  const SizedBox(
                    height: 4,
                  ),
                  _iconView(Icons.label_outline, "${Strings.company}:",
                      inquiryResponse.company),
                  SizedBox(
                    height: Converts.c20,
                  ),
                  Row(
                    children: [
                      ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c96,
                          radius: 8,
                          bgColor: Palette.iconColor,
                          hasOpacity: false,
                          text: flag,
                          fontSize: Converts.c16,
                          tvColor: Colors.white,
                          onTap: () {}),
                      SizedBox(
                        width: Converts.c8,
                      ),
                      /*ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c96,
                          radius: 8,
                          bgColor: Colors.black,
                          hasOpacity: false,
                          text: inquiryResponse.endDate.split(",")[0],
                          fontSize: Converts.c16,
                          iconData: Icons.flag_outlined,
                          tvColor: Colors.white,
                          onTap: () {}),
                      SizedBox(
                        width: Converts.c8,
                      ),*/
                      ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c152,
                          radius: 8,
                          bgColor: Colors.purple,
                          hasOpacity: false,
                          text: "Attachment",
                          fontSize: Converts.c16,
                          iconData: Icons.attach_file,
                          tvColor: Colors.white,
                          onTap: () {}),
                    ],
                  ),
                  SizedBox(
                    height: Converts.c20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextViewCustom(
                        text: Strings.tasks,
                        fontSize: Converts.c20,
                        tvColor: Colors.black,
                        isTextAlignCenter: false,
                        isRubik: false,
                        isBold: true,
                      ),
                      ButtonCircularIcon(
                          height: Converts.c32,
                          width: Converts.c40,
                          radius: 8,
                          bgColor: Palette.tabColor,
                          hasOpacity: false,
                          text:
                              "${_countPendingTask()}/${inquiryResponse.tasks.length}",
                          fontSize: Converts.c12,
                          tvColor: Colors.white,
                          isTvBold: true,
                          onTap: () {})
                    ],
                  ),
                  SizedBox(
                    height: Converts.c20,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final task = inquiryResponse.tasks[index];
              return TaskList(
                task: task,
                inquiryId: inquiryResponse.id.toString(),
              );
            },
            childCount: inquiryResponse
                .tasks.length, // Provide the total count of items
          )),
        ],
      ),
    );
  }

  Widget _iconView(IconData icon, String text, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: Palette.normalTv,
          size: 18,
        ),
        SizedBox(
          width: Converts.c12,
        ),
        TextViewCustom(
          text: text,
          fontSize: Converts.c16,
          tvColor: Palette.normalTv,
          isBold: true,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: TextViewCustom(
            text: title,
            fontSize: Converts.c16,
            tvColor: Palette.normalTv,
            isTextAlignCenter: false,
            isBold: false,
          ),
        ),
      ],
    );
  }
}
