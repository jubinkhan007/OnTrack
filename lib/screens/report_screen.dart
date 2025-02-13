import 'package:flutter/material.dart';
import 'package:tmbi/config/palette.dart';

import '../config/converts.dart';
import '../config/strings.dart';
import '../widgets/widgets.dart';

class ReportScreen extends StatelessWidget {
  static const String routeName = '/report_screen';

  const ReportScreen({super.key});

  Widget customCard(Color color, String imagePath, String title, String count) {
    return Container(
      width: Converts.c144,
      height: Converts.c104,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: Converts.c8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        //clipBehavior: Clip.none, // Ensures the carving image goes beyond card's boundary
        children: [
          Positioned(
            top: 0, // Carve effect, adjusts the image to create the carve
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewCustom(
                      text: count,
                      fontSize: Converts.c24,
                      tvColor: Palette.normalTv,
                      isRubik: true,
                      isBold: false),
                  TextViewCustom(
                      text: title,
                      fontSize: Converts.c12,
                      tvColor: Palette.normalTv,
                      isRubik: true,
                      isBold: false),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0, // Carve effect, adjusts the image to create the carve
            left: 0,
            right: 0,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        centerTitle: false,
        title: TextViewCustom(
          text: Strings.reportDashboard,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
          isRubik: false,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          // Customize icon color
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          /// Part 1
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.all(Converts.c12),
                child: Row(
                  children: [
                    customCard(Palette.progressColor,
                        "assets/ic_card_progress.png", "In progress", "10"),
                    SizedBox(
                      width: Converts.c8,
                    ),
                    customCard(Palette.reviewColor, "assets/ic_card_review.png",
                        "In review", "0"),
                    SizedBox(
                      width: Converts.c8,
                    ),
                    customCard(Palette.topBuyerColor.withOpacity(0.5),
                        "assets/ic_card_buyer.png", "Top Buyer", "50"),
                  ],
                ),
              ),
            ),
          ),

          /// Part 2
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: Converts.c12, right: Converts.c12),
                child: Row(
                  children: [
                    customCard(Palette.onHoldColor, "assets/ic_card_hold.png",
                        "Hold", "50"),
                    SizedBox(
                      width: Converts.c8,
                    ),
                    customCard(Palette.completedColor,
                        "assets/ic_card_completed.png", "Completed", "100"),
                    SizedBox(
                      width: Converts.c8,
                    ),
                    customCard(Palette.delayedColor.withOpacity(0.5),
                        "assets/ic_card_delayed.png", "Delayed", "3"),
                  ],
                ),
              ),
            ),
          ),

          /// Task pie chart
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Converts.c12,),
                Padding(
                  padding: EdgeInsets.only(
                      left: Converts.c12,
                      right: Converts.c12,
                      top: Converts.c16,
                      bottom: Converts.c12),
                  child: TextViewCustom(
                    text: "Tasks Statistics",
                    fontSize: Converts.c20,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isRubik: true,
                    isBold: false,
                  ),
                ),
                const ReportPieChart(
                  dataMap: {
                    "Pending": 5,
                    "Delayed": 3,
                    "Completed": 2,
                    "Upcoming": 5
                  },
                  colorList: [
                    Color(0xffFA4A42),
                    Color(0xffFE9539),
                    Color(0xff3EE094),
                    Color(0xff3398F6),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
