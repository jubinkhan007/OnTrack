import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/models/user_response.dart';
import 'package:tmbi/screens/home_screen.dart';

import '../data/data.dart';
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
      String name = userResponse != null ? userResponse.users![0].staffName! : "";
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


/*extension StatusFlagExtension on Status {
  String getFlag() {
    switch (this) {
      case Status.:
        return "1";
      case Status.PENDING:
        return "2";
      case Status.UPCOMING:
        return "3";
      case Status.COMPLETED:
      default:
        return "4"; // Default flag value for unknown or unhandled statuses
    }
  }
}*/


