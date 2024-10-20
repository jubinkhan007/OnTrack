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
              border: Border.all(
                color: Palette.semiTv, // Border color
                width: 0.5, // Border width
              ),
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
                    tvColor: Palette.semiTv,
                    isBold: false),
                TextViewCustom(
                    text: counters[index].count.toString(),
                    fontSize: Converts.c24,
                    tvColor: counters[index].isDelayed
                        ? Palette.errorColor
                        : Colors.black,
                    isBold: false)
              ],
            ),
          );
        },
      ),
    );
  }
}
