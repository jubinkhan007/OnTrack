import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/counter.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

class CounterCard extends StatelessWidget {
  final List<Counter> counters;

  const CounterCard({super.key, required this.counters});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Converts.c72,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: counters.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              //color: _getColor(counters[index].title),
              gradient: Palette.createRoomGradient,
              /*border: Border.all(
                color: Palette.normalTv, // Border color
                width: 0.5, // Border width
              ),*/
              borderRadius: BorderRadius.circular(4),
            ),
            padding:
                const EdgeInsets.only(left: 8, right: 16, top: 2, bottom: 2),
            //color: Colors.green,
            margin: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextViewCustom(
                    text: counters[index].title,
                    fontSize: Converts.c12,
                    tvColor: counters[index].isDelayed
                        ? Colors.white
                        : Palette.normalTv,
                    isRubik: false,
                    isBold: false),
                TextViewCustom(
                    text: counters[index].count.toString(),
                    fontSize: Converts.c24,
                    tvColor: counters[index].isDelayed
                        ? Colors.white
                        : Palette.normalTv,
                    isBold: true)
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getColor(String name) {
    switch (name) {
      case "Delayed Inquiry":
        return Palette.delayedCardColor; // Color for Pending
      case "Pending Inquiry":
        return Palette.pendingCardColor; // Color for Approved
      case "Completed Inquiry":
        return Palette.completedCardColor; // Color for Rejected
      default:
        return Palette.grayColor; // Default color
    }
  }
}
