import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/counter.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';
import '../network/ui_state.dart';
import '../screens/home_screen.dart';
import '../viewmodel/viewmodel.dart';

class CounterCard extends StatefulWidget {
  final List<Counter> counters;
  final String staffId;

  const CounterCard({super.key, required this.counters, required this.staffId});

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> {
  @override
  Widget build(BuildContext context) {
    final counterViewModel = Provider.of<CounterViewModel>(context);

    return SizedBox(
      height: Converts.c72,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: widget.counters.length,
        itemBuilder: (BuildContext context, int index) {
          //String mCounter = widget.counters[index].count;
          final counter = widget.counters[index];
          return GestureDetector(
            onTap: () async {
              setState(() {
                counter.isLoading = true;
              });
              // call the getCount function to fetch the count
              await counterViewModel.getCount(
                  widget.staffId, _getFlag(counter.flag));

              // update the state based on the uiState
              if (counterViewModel.uiState == UiState.success &&
                  counterViewModel.counter != null) {
                setState(() {
                  counter.isLoading = false;
                  counter.isSelected = true;
                  counter.count = counterViewModel.counter!;
                  debugPrint("Total inquiries count: ${counter.count}");
                  // hide counter value
                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      counter.isSelected = false;
                    });
                  });
                });
              } else {
                if (context.mounted) {
                  context.showMessage(Strings.available_soon);
                }
                setState(() {
                  counter.isLoading = false;
                  counter.isSelected = false;
                  if (counterViewModel.uiState == UiState.error) {
                    debugPrint("${counterViewModel.message}");
                  }
                });
              }
            },
            child: Container(
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
                      text: widget.counters[index].title,
                      fontSize: Converts.c12,
                      tvColor: widget.counters[index].isDelayed
                          ? Colors.white
                          : Palette.normalTv,
                      isRubik: false,
                      isBold: false),
                  counter.isLoading
                      ? Padding(
                          padding: EdgeInsets.all(Converts.c8),
                          child: SizedBox(
                            height: Converts.c16,
                            width: Converts.c16,
                            child: const CircularProgressIndicator(
                              strokeWidth:
                                  2, // Smaller stroke for a finer spinner
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : counter.isSelected
                          ? TextViewCustom(
                              text: counter.count,
                              fontSize: Converts.c24,
                              tvColor: counter.isDelayed
                                  ? Colors.white
                                  : Palette.normalTv,
                              isBold: true)
                          : Row(
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  size: Converts.c24,
                                  color: counter.isDelayed
                                      ? Colors.white
                                      : Palette.normalTv,
                                ),
                                TextViewCustom(
                                    text: Strings.tap,
                                    fontSize: Converts.c24,
                                    tvColor: counter.isDelayed
                                        ? Colors.white
                                        : Palette.normalTv,
                                    isBold: true),
                              ],
                            )
                ],
              ),
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

  String _getFlag(Status status) {
    switch (status) {
      case Status.delayed:
        return "1";
      case Status.pending:
        return "2";
      case Status.upcoming:
        return "3";
      case Status.completed:
      default:
        return "4"; // Default flag value for unknown or unhandled statuses
    }
  }
}
