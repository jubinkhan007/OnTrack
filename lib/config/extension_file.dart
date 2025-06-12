import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/config/strings.dart';

import '../data/data.dart';
import '../models/user_response.dart';
import '../widgets/widgets.dart';
import 'converts.dart';

extension DateTimeFormatter on DateTime {
  String toFormattedString({isFullYear = false, format = "dd MMM, yy"}) {
    String fullYearFormat = "dd MMM, yyyy";
    DateFormat dateFormat =
        isFullYear ? DateFormat(fullYearFormat) : DateFormat(format);
    return dateFormat.format(this);
  }
}

/*extension DateCheckExtension on String {
  bool isOverdue() {
    final dateFormat = DateFormat("d MMM, yy");
    final DateTime targetDate = dateFormat.parse(this);
    final DateTime currentDate = DateTime.now();
    debugPrint("DATE::$targetDate");
    debugPrint("CDATE::$currentDate");
    return currentDate.isAfter(targetDate);
  }
}*/

extension DateCheckExtension on String {
  bool isOverdue() {
    final dateFormat = DateFormat("d MMM, yy");
    final DateTime targetDate = dateFormat.parse(this);

    // Get the current date with no time component
    final DateTime currentDate = DateTime.now().toLocal();
    final DateTime currentDateOnly =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    //debugPrint("TARGET DATE: $targetDate");
    //debugPrint("CURRENT DATE: $currentDateOnly");

    return currentDateOnly.isAfter(targetDate);
  }
}

/*extension DateFormatExtension on String {
  /// Converts "yyyy-MM-dd" to "dd MMM, yy"
  String toFormattedDate() {
    try {
      DateTime date = DateTime.parse(this);
      return DateFormat('dd MMM, yy').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
}*/


extension DateFormatExtension on String {
  /// Converts "yyyy-MM-dd" to "dd MMM, yy" safely
  String toFormattedDate() {
    try {
      // Try parsing as ISO (e.g. "2025-06-12")
      DateTime date = DateTime.parse(this);
      return DateFormat('dd MMM, yy').format(date);
    } catch (_) {
      try {
        // Check if it's already in "dd MMM, yy" format
        DateFormat('dd MMM, yy').parseStrict(this);
        return this;
      } catch (_) {
        return 'Invalid date';
      }
    }
  }
}


extension SnackbarExtension on BuildContext {
  void showMessage(String message) {
    final snackBar = SnackBar(
      content: TextViewCustom(
        text: message,
        tvColor: Colors.white,
        fontSize: Converts.c16,
        isBold: false,
        isRubik: true,
        isTextAlignCenter: false,
      ),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}

extension StatusColor on String {
  Color get statusColor {
    // Priority list initialization
    String started = PriorityList().priorities[0].name ?? "";
    String progress = PriorityList().priorities[1].name ?? "";
    String hold = PriorityList().priorities[2].name ?? "";
    String completed = PriorityList().priorities[3].name ?? "";

    // Check the status and return the appropriate color
    if (this == started) {
      return Colors.blue;
    } else if (this == progress) {
      return Colors.yellow;
    } else if (this == hold) {
      return Colors.redAccent;
    } else if (this == completed) {
      return Colors.green;
    } else {
      return Colors.grey; // Default color if status is unknown
    }
  }
}

extension ShimmerLoadingExtension on BuildContext {
  // Shimmer loading extension method
  Shimmer shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.red[100]!,
      highlightColor: Colors.red[50]!,
      child: Padding(
        padding: EdgeInsets.all(Converts.c8),
        child: ListView.builder(
          itemCount: 5, // Number of shimmering items
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Converts.c208,
                  height: Converts.c16,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: Converts.c16,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: Converts.c296,
                  height: Converts.c16,
                  color: Colors.white,
                ),
                SizedBox(height: Converts.c16),
              ],
            );
          },
        ),
      ),
    );
  }
}

extension UserInfoExtension on SPHelper {
  Future<String> getUserInfo({bool isName = false}) async {
    try {
      UserResponse? userResponse = await getUser();
      String id = userResponse != null ? userResponse.users![0].staffId! : "";
      String name =
          userResponse != null ? userResponse.users![0].staffName! : "";
      return isName ? name : id;
    } catch (e) {
      return "";
    }
  }
}

extension HideKeyboard on BuildContext {
  void hideKeyboard() {
    FocusScope.of(this).requestFocus(FocusNode());
  }
}

extension StatusFlagExtension on StatusFlag {
  String get getFlag {
    switch (this) {
      /*case StatusFlag.delayed:
        return "1";*/
      case StatusFlag.pending:
        return "2";
      /*case StatusFlag.upcoming:
        return "3";*/
      case StatusFlag.completed:
      default:
        return "4"; // Default flag value for unknown or unhandled statuses
    }
  }
}

extension GreetingExtension on DateTime {
  String getGreeting() {
    // current hour of the day
    int currentHour = hour;
    // determine the greeting based on the time of day
    if (currentHour >= 5 && currentHour < 12) {
      return Strings.good_morning;
    } else if (currentHour >= 12 && currentHour < 18) {
      return Strings.good_afternoon;
    } else {
      return Strings.good_night;
    }
  }
}
