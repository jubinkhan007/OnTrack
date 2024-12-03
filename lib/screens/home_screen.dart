import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/data/counter_item.dart';
import 'package:tmbi/models/user_response.dart';
import 'package:tmbi/screens/screens.dart';
import 'package:tmbi/viewmodel/viewmodel.dart';
import 'package:tmbi/widgets/feature_status.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../models/models.dart';
import '../network/ui_state.dart';

enum Status { DELAYED, PENDING, UPCOMING, COMPLETED }

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';
  final String staffId;
  String selectedFlag = HomeFlagItem().homeFlagItems[1].title;
  String isAssigned = "1";

  HomeScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    String selectedFlagValue = getFlag(Status.PENDING);
    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInquiries(selectedFlagValue, staffId, isAssigned);
    });

    List<Discussion> discussionList = [
      Discussion(
        name: "Task 1",
        staffId: "340553",
        dateTime: "2024-12-01 10:00",
        body: "Complete the report by the end of the day.",
      ),
      Discussion(
        name: "Task 2",
        staffId: "340553",
        dateTime: "2024-12-02 14:00",
        body: "Review the presentation slides for the meeting.",
      ),
      Discussion(
        name: "Task 3",
        staffId: "340553",
        dateTime: "2024-12-03 09:00",
        body: "Attend the team meeting and provide updates.",
      ),
      Discussion(
        name: "Task 4",
        staffId: "340553",
        dateTime: "2024-12-04 16:00",
        body: "Prepare budget analysis for the next quarter.",
      ),
    ];


    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.pushNamed(context, CreateInquiryScreen.routeName, arguments: staffId);
          // test start
          Navigator.pushNamed(context, AddTaskToStaffScreen.routeName,
              arguments: {
                'staffId': staffId,
                'individual_task': discussionList
                    .map((discussion) => discussion.toJson())
                    .toList(),
              });
          // test end
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
        color: Palette.mainColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: false,
            backgroundColor: Palette.mainColor,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      return TextViewCustom(
                        text: "${getGreeting()} ${snapshot.data}",
                        fontSize: Converts.c20,
                        tvColor: Colors.white,
                        isRubik: false,
                        isTextAlignCenter: false,
                        isBold: true,
                      );
                    }),
                TextViewCustom(
                  text: DateTime.now().toFormattedString(),
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
                onPressed: () {
                  context.showMessage(Strings.available_soon);
                },
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
                /*Padding(
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
                ),*/
                SizedBox(
                  height: Converts.c8,
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
                Padding(
                  padding: EdgeInsets.only(
                    left: Converts.c16,
                    top: Converts.c8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextViewCustom(
                          text: Strings.inquiry,
                          fontSize: Converts.c20,
                          tvColor: Colors.black,
                          isTextAlignCenter: false,
                          isBold: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: Converts.c16),
                        child: SwitchContainer(
                          onSwitchTap: (value) async {
                            isAssigned = value ? "1" : "0";
                            await _getInquiries(inquiryViewModel,
                                selectedFlagValue, isAssigned);
                            debugPrint("IS_ASSIGNED:: $isAssigned");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Converts.c8,
                ),
                FeatureStatus(
                  homeFlags: HomeFlagItem().homeFlagItems,
                  onPressed: (value, flag) async {
                    selectedFlag = value;
                    selectedFlagValue = getFlag(flag);
                    await _getInquiries(
                        inquiryViewModel, getFlag(flag), isAssigned);
                    //debugPrint(value);
                  },
                )
              ],
            ),
          ),
          Consumer<InquiryViewModel>(
              builder: (context, inquiryViewModel, child) {
            if (inquiryViewModel.uiState == UiState.loading) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: Converts.c120,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            } else if (inquiryViewModel.uiState == UiState.error) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: Converts.c120,
                  ),
                  child: ErrorContainer(
                      message: inquiryViewModel.message != null
                          ? inquiryViewModel.message!
                          : Strings.something_went_wrong),
                ),
              );
            }
            // null check
            if (inquiryViewModel.inquiries?.isEmpty ?? true) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: Converts.c120,
                  ),
                  child: ErrorContainer(
                      message: inquiryViewModel.message != null
                          ? inquiryViewModel.message!
                          : Strings.no_data_found),
                ),
              );
            }

            return inquiryViewModel.inquiries != null &&
                    inquiryViewModel.inquiries!.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final inquiryResponse =
                            inquiryViewModel.inquiries![index];
                        return InquiryList(
                          inquiryResponse: inquiryResponse,
                          onTap: () {
                            /*Navigator.pushNamed(
                              context,
                              InquiryView.routeName,
                              arguments:
                                  inquiryResponse,
                            );*/
                            Navigator.pushNamed(
                              context,
                              InquiryView.routeName,
                              arguments: {
                                'inquiryResponse': inquiryResponse,
                                'flag': selectedFlag,
                              },
                            );
                          },
                          onCommentTap: (id) {
                            Navigator.pushNamed(
                              context,
                              CommentScreen.routeName,
                              arguments: id,
                            );
                          },
                          onAttachmentTap: (id) {
                            Navigator.pushNamed(
                              context,
                              AttachmentViewScreen.routeName,
                              arguments: {
                                'inquiryId': id,
                                'taskId': "0",
                              },
                            );
                          },
                        );
                      },
                      childCount: inquiryViewModel.inquiries!
                          .length, // Provide the total count of items
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Converts.c120,
                      ),
                      child: ErrorContainer(
                          message: inquiryViewModel.message != null
                              ? inquiryViewModel.message!
                              : Strings.something_went_wrong),
                    ),
                  );
          }),
          SliverPadding(
            padding: EdgeInsets.only(bottom: Converts.c24),
          ),
        ],
      ),
    );
  }

  Future<void> _getInquiries(
      InquiryViewModel inquiryViewModel, String flag, String isAssigned) async {
    await inquiryViewModel.getInquiries(flag, staffId, isAssigned);
  }

  Future<String> _getUserName() async {
    try {
      UserResponse? userResponse = await SPHelper().getUser();
      String name =
          userResponse != null ? userResponse.users![0].staffName! : "";
      return name;
    } catch (e) {
      return "";
    }
  }

  String getGreeting() {
    // current hour of the day
    int currentHour = DateTime.now().hour;
    // determine the greeting based on the time of day
    if (currentHour >= 5 && currentHour < 12) {
      return Strings.good_morning;
    } else if (currentHour >= 12 && currentHour < 18) {
      return Strings.good_afternoon;
    } else {
      return Strings.good_night;
    }
  }

  String getFlag(Status status) {
    switch (status) {
      case Status.DELAYED:
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

  Future<void> _showLogoutDialog(BuildContext context) async {
    bool? logoutConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.logout),
          content: const Text(Strings.are_you_sure_you_want_to_logout),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // return false to indicate cancellation
              },
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Removes all previous routes
                );
              },
              child: const Text(Strings.yes),
            ),
          ],
        );
      },
    );
  }
}
