import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/data/counter_item.dart';
import 'package:tmbi/data/home_flag_item.dart';
import 'package:tmbi/data/inquiry_response.dart';
import 'package:tmbi/screens/create_inquiry_screen.dart';
import 'package:tmbi/screens/inquiry_view.dart';
import 'package:tmbi/widgets/feature_status.dart';
import 'package:tmbi/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            CreateInquiryScreen.routeName,
          );
        },
        mini: true,
        backgroundColor: Palette.mainColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 48,
        color: Colors.grey[200],
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: false,
            backgroundColor: Colors.red,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextViewCustom(
                  text: "Good Morning Salauddin",
                  fontSize: Converts.c20,
                  tvColor: Colors.white,
                  isRubik: false,
                  isTextAlignCenter: false,
                  isBold: true,
                ),
                TextViewCustom(
                  text: "08 Oct,2024",
                  fontSize: Converts.c16,
                  isTextAlignCenter: false,
                  tvColor: Colors.white,
                  isBold: false,
                ),
              ],
            ),
            floating: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: Converts.c20,
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: Converts.c16,
                    top: Converts.c24,
                  ),
                  child: TextViewCustom(
                    text: Strings.summary,
                    fontSize: Converts.c20,
                    tvColor: Colors.black,
                    isBold: true,
                  ),
                ),
                CounterCard(
                  counters: CounterItem().counters,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Converts.c16,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: Converts.c16,
                    top: Converts.c24,
                  ),
                  child: TextViewCustom(
                    text: Strings.inquiry,
                    fontSize: Converts.c20,
                    tvColor: Colors.black,
                    isBold: true,
                  ),
                ),
                SizedBox(
                  height: Converts.c16,
                ),
                FeatureStatus(
                  homeFlags: HomeFlagItem().homeFlagItems,
                  onPressed: (value) {
                    debugPrint(value);
                  },
                )
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final inquiryResponse = _getDemoTasks()[index];

              return InquiryList(
                inquiryResponse: inquiryResponse,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    InquiryView.routeName,
                    arguments: inquiryResponse, // Pass the list as arguments
                  );
                },
              );
            },
            childCount:
                _getDemoTasks().length, // Provide the total count of items
          )),
        ],
      ),
    );
  }

  List<InquiryResponse> _getDemoTasks() {
    const jsonString = '''[
    {
        "id": "123C321",
        "title": "Need shoe sample for walker",
        "description": "Lorem Ipsum is simply dummy text of the printingand  typesetting industry. Lorem Ipsum has  ... ",
        "company": "Walker",
        "end_date": "Oct 8, 2024",
        "status": "pending",
        "comment_count": "6",
        "attachemnt_count": "2",
        "posted_by": {
            "id": "1",
            "name": "Mr. Fahad Alam",
            "is_owner": true
        },
        "buyer_info": {
            "id": "12",
            "name": "Mr. Alan John",
            "is_verified": true
        },
        "tasks": [
            {
                "id": "1",
                "name": "Collect materials to create a sample from the store.",
                "date": "19 Oct, 2024 - 21 Oct, 2024",
                "total_time": "2",
                "has_access": false,
                "is_updated": false,
                "assigned_person": "Mr. Rtotn"
            },
            {
                "id": "2",
                "name": "Create a sample using that material.",
                "date": "22 Oct, 2024 - 26 Oct, 2024",
                "total_time": "4",
                "has_access": true,
                "is_updated": true,
                "assigned_person": "Mr. Alamgir Hossain"
            },
            {
                "id": "3",
                "name": "Gate Pass.",
                "date": "27 Oct, 2024 - 27 Oct, 2024",
                "total_time": "1",
                "has_access": false,
                "is_updated": true,
                "assigned_person": "Mr. Hossain"
            }
        ]
    },
    {
        "id": "123C322",
        "title": "Need shirt sample for Winner",
        "description": "Lorem Ipsum is simply dummy text of the printingand  typesetting industry. Lorem Ipsum has  ... ",
        "company": "Winner",
        "end_date": "Oct 29, 2024",
        "status": "pending",
        "comment_count": "1",
        "attachemnt_count": "1",
        "posted_by": {
            "id": "2",
            "name": "Mr. Alam",
            "is_owner": false
        },
        "buyer_info": {
            "id": "13",
            "name": "Mr. John",
            "is_verified": false
        },
        "tasks": [
            {
                "id": "2",
                "name": "Create a sample using that material.",
                "date": "22 Oct, 2024 - 26 Oct, 2024",
                "total_time": "4",
                "has_access": false,
                "is_updated": false,
                "assigned_person": "Mr. Alamgir Hossain"
            },
            {
                "id": "3",
                "name": "Gate Pass.",
                "date": "27 Oct, 2024 - 27 Oct, 2024",
                "total_time": "1",
                "has_access": true,
                "is_updated": false,
                "assigned_person": "Mr. Alamgir Hossain"
            }
        ]
    },
    {
        "id": "123C322",
        "title": "Need shirt sample for Winner",
        "description": "Lorem Ipsum is simply dummy text of the printingand  typesetting industry. Lorem Ipsum has  ... ",
        "company": "Winner",
        "end_date": "Oct 29, 2024",
        "status": "pending",
        "comment_count": "1",
        "attachemnt_count": "1",
        "posted_by": {
            "id": "2",
            "name": "Mr. Alam",
            "is_owner": false
        },
        "buyer_info": {
            "id": "13",
            "name": "Mr. John",
            "is_verified": false
        },
        "tasks": [
            {
                "id": "2",
                "name": "Create a sample using that material.",
                "date": "22 Oct, 2024 - 26 Oct, 2024",
                "total_time": "4",
                "has_access": false,
                "is_updated": false,
                "assigned_person": "Mr. Alamgir Hossain"
            },
            {
                "id": "3",
                "name": "Gate Pass.",
                "date": "27 Oct, 2024 - 27 Oct, 2024",
                "total_time": "1",
                "has_access": true,
                "is_updated": false,
                "assigned_person": "Mr. Alamgir Hossain"
            }
        ]
    }
]''';
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => InquiryResponse.fromJson(json)).toList();
  }
}
