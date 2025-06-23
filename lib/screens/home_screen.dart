import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/models/user_response.dart';
import 'package:tmbi/screens/dialog/update_user_info_dialog.dart';
import 'package:tmbi/screens/screens.dart';
import 'package:tmbi/viewmodel/viewmodel.dart';
import 'package:tmbi/widgets/feature_status.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/enum.dart';
import '../data/counter_item.dart';
import '../models/models.dart';
import '../network/ui_state.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home_screen';
  final String staffId;

  const HomeScreen({super.key, required this.staffId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String isAssigned = "1";
  String selectedFlagValue = "";
  String selectedFlag = "";
  Customer? customer;

  // Keep track of the selected flag
  StatusFlag? status;

  // Track which flag is selected in the FeatureStatus widget
  int selectedFlagIndex = 0;

  UserResponse? _userResponse;

  bool _showWarningMessage = false;

  @override
  void initState() {
    super.initState();
    selectedFlagValue = StatusFlag.pending.getFlag;
    status = HomeFlagItem().homeFlagItems[0].status;
    selectedFlag = HomeFlagItem().homeFlagItems[0].title;

    _loadUserData();

    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    // test
    selectedFlagIndex = inquiryViewModel.tabSelectedFlag;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInquiries(
          selectedFlagValue, widget.staffId, isAssigned);
    });
    debugPrint("Called");
  }

  Future<void> _loadUserData() async {
    final data = await _getUserInfo();
    setState(() {
      _userResponse = data;
      if (_userResponse != null) {
        if (_userResponse!.users![0].mailId == "" || _userResponse!.users![0].mailId == null ||
            _userResponse!.users![0].mailId == "hrismail@notavailable.com") {
          _showWarningMessage = true;
          // timer for warning message
          Timer(const Duration(seconds: 20), () {
            if (mounted) {
              setState(() {
                _showWarningMessage = false;
              });
            }
          });
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: drawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await SPHelper().getFirstTaskEntryFlag()) {
            /*setState(() {
              selectedFlagIndex = 0;
              customer = null;
            });*/
            Navigator.pushNamed(context, TodoHomeScreen.routeName,
                arguments: widget.staffId);
          } else {
            Navigator.pushNamed(context, CreateInquiryScreen.routeName,
                arguments: widget.staffId);
          }
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
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _getInquiries(
            Provider.of<InquiryViewModel>(context, listen: false),
            selectedFlagValue,
            isAssigned,
            customer != null ? customer!.id! : widget.staffId,
          );
        },
        child: CustomScrollView(
          slivers: [
            /// app bar
            SliverAppBar(
              centerTitle: false,
              backgroundColor: Palette.mainColor,
              automaticallyImplyLeading: false,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewCustom(
                    text: DateTime.now().getGreeting(),
                    fontSize: Converts.c20,
                    tvColor: Colors.white,
                    isRubik: false,
                    isTextAlignCenter: false,
                    isBold: true,
                  ),
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
                    //context.showMessage(Strings.available_soon);
                    Navigator.pushNamed(context, NotificationScreen.routeName);
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (isAssigned == "1") {
                      _showCustomerDialog(
                          context,
                          Provider.of<InquiryViewModel>(context, listen: false),
                          selectedFlagValue);
                    } else {
                      context.showMessage(
                          "Please select 'Assigned' and then try again.");
                    }
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            /// counter view (tap view)
            SliverToBoxAdapter(
              child: Visibility(
                visible: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Converts.c8,
                    ),
                    CounterCard(
                      counters: CounterItem().counters,
                      staffId: widget.staffId,
                    ),
                  ],
                ),
              ),
            ),

            /// warning message
            SliverToBoxAdapter(
              child: warningMessage(),
            ),

            /// flag(pending, update), searched user, flag(created, assigned)
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
                        customer != null
                            ? userInfoCube()
                            : const SizedBox.shrink(),
                        Expanded(
                          child: TextViewCustom(
                            text: "",
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
                              // reset previous value
                              setState(() {
                                customer = null;
                              });
                              await _getInquiries(
                                  Provider.of<InquiryViewModel>(context,
                                      listen: false),
                                  selectedFlagValue,
                                  isAssigned,
                                  widget.staffId);
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
                    selectedFlagIndex: selectedFlagIndex,
                    onPressed: (value, flag) async {
                      // handle the flag press action
                      setState(() {
                        selectedFlag = value;
                        status = flag;
                        selectedFlagValue = flag.getFlag;
                        selectedFlagIndex = HomeFlagItem()
                            .homeFlagItems
                            .indexWhere((item) =>
                                item.title == value); // Update selected index
                        debugPrint(selectedFlagIndex.toString());
                      });
                      // test start
                      Provider.of<InquiryViewModel>(context, listen: false)
                          .tabSelectedFlag = selectedFlagIndex;
                      // test end
                      await _getInquiries(
                        Provider.of<InquiryViewModel>(context, listen: false),
                        selectedFlagValue,
                        isAssigned,
                        customer != null ? customer!.id! : widget.staffId,
                      );
                      debugPrint("Selected Flag: $value");
                    },
                  ),

                  /// Report: Pie Chart view
                  Visibility(
                    visible: false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            // Toggle the value of isOpenReportView
                            Provider.of<InquiryViewModel>(context,
                                        listen: false)
                                    .isOpenReportView =
                                !Provider.of<InquiryViewModel>(context,
                                        listen: false)
                                    .isOpenReportView;
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextViewCustom(
                                      text: "Reports from the last month",
                                      fontSize: Converts.c20,
                                      tvColor: Palette.tabColor,
                                      isRubik: false,
                                      isBold: true,
                                    ),
                                  ),
                                  // Use Consumer to rebuild the icon when the state changes
                                  Consumer<InquiryViewModel>(
                                    builder:
                                        (context, inquiryViewModel, child) {
                                      return inquiryViewModel.isOpenReportView
                                          ? const Icon(
                                              Icons.keyboard_arrow_down)
                                          : const Icon(Icons.keyboard_arrow_up);
                                    },
                                  ),
                                ],
                              ),
                              // Use Consumer to rebuild the pie chart when the state changes
                              Consumer<InquiryViewModel>(
                                builder: (context, inquiryViewModel, child) {
                                  return inquiryViewModel.isOpenReportView
                                      ? const ReportPieChart(
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
                                      : const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 16,
                  bottom: 8,
                ),
                child: TextViewCustom(
                  text:
                      "List of all $selectedFlag Tasks ${isAssigned == "1" ? "Assigned to you" : "Created by you"}",
                  fontSize: Converts.c16,
                  tvColor: Palette.grayColor,
                  isTextAlignCenter: false,
                  isRubik: false,
                  isBold: true,
                ),
              ),
            ),

            /// inquiry list
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

              // set data
              return inquiryViewModel.inquiries != null &&
                      inquiryViewModel.inquiries!.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final inquiryResponse =
                              inquiryViewModel.inquiries![index];
                          return InquiryList(
                            inquiryResponse: inquiryResponse,
                            selectedFlagIndex: selectedFlagIndex,
                            staffId: widget.staffId,

                            /// detail view
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                InquiryView.routeName,
                                arguments: {
                                  'inquiryResponse': inquiryResponse,
                                  'flag': selectedFlag,
                                  'staffId': widget.staffId
                                },
                              );
                            },

                            /// comment view
                            onCommentTap: (id) {
                              Navigator.pushNamed(
                                context,
                                CommentScreen.routeName,
                                arguments: id,
                              );
                            },

                            /// attachment view
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

                            /// delete tap
                            onDeleteTap: (id) async {
                              await inquiryViewModel.deleteInq(id);
                              //if (!context.mounted) return;
                              if (inquiryViewModel.uiState == UiState.error) {
                                _showMessage(
                                    "Error: ${inquiryViewModel.message}");
                              } else {
                                if (inquiryViewModel.isSavedInquiry != null) {
                                  if (inquiryViewModel.isSavedInquiry!) {
                                    setState(() {
                                      inquiryViewModel.inquiries!
                                          .removeAt(index);
                                    });
                                  } else {
                                    _showMessage(
                                        Strings.failed_to_delete_the_data);
                                  }
                                } else {
                                  _showMessage(Strings.data_is_missing);
                                }
                              }
                            },

                            /// add new member
                            /*onAddMemberTap: (id) async {
                              _showCustomerDialog(
                                  context,
                                  Provider.of<InquiryViewModel>(context,
                                      listen: false),
                                  selectedFlagValue,
                                  isAddMember: true,
                                  data: inquiryResponse);
                            },*/
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
      ),
    );
  }

  _showMessage(String message) {
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _getInquiries(InquiryViewModel inquiryViewModel, String flag,
      String isAssigned, String userid) async {
    await inquiryViewModel.getInquiries(flag, userid, isAssigned,
        vm: customer == null ? "INQALL" : "SINQALL");
  }

  Future<UserResponse?> _getUserInfo() async {
    try {
      UserResponse? userResponse = await SPHelper().getUser();
      return userResponse;
    } catch (e) {
      return null;
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

  void _showCustomerDialog(BuildContext context,
      InquiryViewModel inquiryViewModel, String selectedFlagValue,
      {bool isAddMember = false, InquiryResponse? data}) {
    getStaffs().then((staffResponse) {
      if (staffResponse != null && context.mounted) {
        List<Customer> customers = [];
        for (var staff in staffResponse!.staffs!) {
          customers.add(
              Customer(id: staff.code, name: staff.name, isVerified: false));
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: TextViewCustom(
                    text: Strings.search_by_name,
                    fontSize: Converts.c16,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true),
                content: CustomerSearchDialog(
                    customers: customers,
                    hintName: "",
                    onCustomerSelected: (customer) async {
                      if (customer != null) {
                        if (!isAddMember) {
                          setState(() {
                            this.customer = customer;
                          });
                          await _getInquiries(inquiryViewModel,
                              selectedFlagValue, isAssigned, customer!.id!);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } else {
                          if (data != null) {
                            await inquiryViewModel.addMember(data.id.toString(),
                                "0", customer.id!, "-1", widget.staffId);
                            //if (!context.mounted) return;
                            if (inquiryViewModel.uiState == UiState.error) {
                              _showMessage(
                                  "Error: ${inquiryViewModel.message}");
                            } else {
                              if (inquiryViewModel.isSavedInquiry != null) {
                                if (inquiryViewModel.isSavedInquiry!) {
                                  if (context.mounted) Navigator.pop(context);
                                  await _getInquiries(
                                    inquiryViewModel,
                                    selectedFlagValue,
                                    isAssigned,
                                    widget.staffId,
                                  );
                                } else {
                                  _showMessage(
                                      Strings.failed_to_delete_the_data);
                                }
                              } else {
                                _showMessage(Strings.data_is_missing);
                              }
                            }
                          }
                        }
                      }
                    }),
              );
            });
      }
    });
  }

  Widget userInfoCube() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Palette.navyBlueColor, // Border color
          width: 1, // Border width
        ),
      ),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: LoadImage(
                id: customer != null
                    ? customer!.id != null
                        ? customer!.id!
                        : ""
                    : "",
                height: Converts.c24,
                width: Converts.c24,
              ),
            ),
            SizedBox(
              width: Converts.c8,
            ),
            TextViewCustom(
              text: customer != null
                  ? customer!.name != null
                      ? (customer!.name.toString().length > 10)
                          ? '${customer!.name.toString().substring(0, 10)}...'
                          : customer!.name.toString()
                      : ""
                  : "",
              fontSize: Converts.c16,
              tvColor: Palette.semiTv,
              isBold: true,
            ),
            SizedBox(
              width: Converts.c8,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  customer = null;
                });
                await _getInquiries(
                    Provider.of<InquiryViewModel>(context, listen: false),
                    selectedFlagValue,
                    isAssigned,
                    widget.staffId);
              },
              child: Padding(
                padding: EdgeInsets.all(Converts.c8),
                child: Icon(
                  Icons.close,
                  color: Palette.semiTv,
                  size: Converts.c20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<StaffResponse?> getStaffs() async {
    await context
        .read<AddTaskViewModel>()
        .getStaffs(widget.staffId, "0", vm: "SSEARCH");
    return mounted ? context.read<AddTaskViewModel>().staffResponse : null;
  }

  /// DRAWER
  /*Widget drawerMenu() {
    return FutureBuilder<UserResponse?>(
      future: _getUserInfo(), // The Future that gets the user data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the future
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle error case
          return const Center(child: Text("Error loading user info"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Handle no data case
          return const Center(child: Text("No user info available"));
        } else {
          // Once the data is fetched, display the Drawer
          UserResponse userResponse = snapshot.data!;

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                /// Header
                DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Converts.c16, right: Converts.c16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoadImage(
                            id: userResponse.users![0]!.staffId!,
                            height: Converts.c56,
                            width: Converts.c56,
                          ),
                          TextViewCustom(
                              //text: userResponse.users![0]!.staffName!,
                              text: userResponse.users?.isNotEmpty == true
                                  ? userResponse.users![0].staffName ?? ''
                                  : '',
                              fontSize: Converts.c16,
                              tvColor: Palette.normalTv,
                              isRubik: false,
                              isBold: true),
                          userResponse.users?.isNotEmpty == true
                              ? userResponse.users![0].mobileNo != null
                                  ? TextViewCustom(
                                      text:
                                          userResponse.users![0].mobileNo ?? '',
                                      //'01675147741',
                                      fontSize: Converts.c12,
                                      tvColor: Palette.semiTv,
                                      isRubik: false,
                                      isBold: false)
                                  : const SizedBox.shrink()
                              : const SizedBox.shrink(),
                          TextViewCustom(
                              //text: userResponse.users![0]!.mailId!,
                              text: userResponse.users?.isNotEmpty == true
                                  ? userResponse.users![0].mailId ?? ''
                                  : '',
                              fontSize: Converts.c12,
                              tvColor: Palette.semiTv,
                              isRubik: false,
                              isBold: false),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.edit,
                                    size: Converts.c16,
                                    color: Colors.redAccent),
                                label: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: Converts.c16,
                                  ),
                                ),
                                onPressed: () async {
                                  */ /*await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UpdateUserInfoDialog(
                                          user: userResponse.users![0],
                                          onUpdate: (flag, email, mobileNo) {
                                            */ /**/ /*setState(() {
                                              userResponse.users![0].mailId = email;
                                              userResponse.users![0].mobileNo = mobileNo;
                                            });*/ /**/ /*
                                          },
                                        );
                                      });*/ /*
                                  final result = await showDialog<Map<String, String>>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdateUserInfoDialog(user: userResponse.users![0], onUpdate: (flag, email, mobilNo) {},);
                                    },
                                  );

                                  if (result != null) {
                                    setState(() {
                                      debugPrint(
                                        "Done: ${ result['email']!}"
                                      );
                                      userResponse.users![0].mailId = result['email']!;
                                      userResponse.users![0].mobileNo = result['mobileNo']!;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                /// Settings
                drawerItem(Icons.settings, Strings.setting, () {
                  Navigator.pushNamed(
                    context,
                    SettingScreen.routeName,
                  );
                }),

                /// add staff
                drawerItem(Icons.add_task, Strings.add_staff, () {
                  */ /*Navigator.pushNamed(
                    context,
                    SettingScreen.routeName,
                  );*/ /*
                  _showAddStaffDialog(context);
                }),

                /// Report
                drawerItem(Icons.dashboard, Strings.reportDashboard, () {
                  */ /*Navigator.pushNamed(
                    context,
                    ReportScreen.routeName,
                  );*/ /*
                  Navigator.pop(context);
                  context.showMessage(Strings.available_soon);
                }),
              ],
            ),
          );
        }
      },
    );
  }*/

  Widget drawerMenu() {
    if (_userResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = _userResponse!.users![0];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// Header
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Converts.c16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadImage(
                      id: user.staffId ?? '',
                      height: Converts.c56,
                      width: Converts.c56,
                    ),
                    TextViewCustom(
                      text: user.staffName ?? '',
                      fontSize: Converts.c16,
                      tvColor: Palette.normalTv,
                      isRubik: false,
                      isBold: true,
                    ),
                    if ((user.mobileNo ?? '').isNotEmpty)
                      TextViewCustom(
                        text: user.mobileNo!,
                        fontSize: Converts.c12,
                        tvColor: Palette.semiTv,
                        isRubik: false,
                        isBold: false,
                      ),
                    TextViewCustom(
                      text: user.mailId ?? '',
                      fontSize: Converts.c12,
                      tvColor: Palette.semiTv,
                      isRubik: false,
                      isBold: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.edit,
                              size: Converts.c16, color: Colors.redAccent),
                          label: Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: Converts.c16,
                            ),
                          ),
                          onPressed: () async {
                            final result =
                                await showDialog<Map<String, String>>(
                              context: context,
                              builder: (BuildContext context) {
                                return UpdateUserInfoDialog(
                                  user: user,
                                  onUpdate: (_, __, ___) {},
                                );
                              },
                            );

                            if (result != null) {
                              setState(() {
                                user.mailId = result['email']!;
                                user.mobileNo = result['mobileNo']!;
                              });
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          /// Settings
          drawerItem(Icons.settings, Strings.setting, () {
            Navigator.pushNamed(context, SettingScreen.routeName);
          }),

          /// Add staff
          drawerItem(Icons.add_task, Strings.add_staff, () {
            _showAddStaffDialog(context);
          }),

          /// Report
          drawerItem(Icons.dashboard, Strings.reportDashboard, () {
            Navigator.pop(context);
            context.showMessage(Strings.available_soon);
          }),
        ],
      ),
    );
  }

  Widget drawerItem(IconData icon, String title, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: Converts.c20,
              color: Palette.semiTv,
            ),
            SizedBox(
              width: Converts.c16,
            ),
            Expanded(
              child: TextViewCustom(
                  text: title,
                  fontSize: Converts.c20,
                  tvColor: Palette.semiTv,
                  isTextAlignCenter: false,
                  isRubik: false,
                  isBold: false),
            ),
          ],
        ),
      ),
    );
  }

  /*void _showAddStaffDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextViewCustom(
            text: Strings.add_staff,
            tvColor: Palette.normalTv,
            fontSize: Converts.c16,
            isTextAlignCenter: false,
            isBold: true,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: Strings.staff_id,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: Converts.c16 - 2,
                    ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // Handle the tap (e.g., trigger a search)
                      debugPrint("Right icon tapped: ${searchController.text}");
                    },
                    child: const Icon(Icons.search), // Or any other icon
                  ),
                  //border: OutlineInputBorder(),
                ),
              ),
              TextViewCustom(
                text: "Staff Info# Md: XYZ Hasan [123456]\nExport",
                tvColor: Palette.semiTv,
                fontSize: Converts.c16,
                isTextAlignCenter: false,
                isBold: false,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String searchTerm = searchController.text;
                print('Saved: $searchTerm');
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }*/

  void _showAddStaffDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Consumer<AddTaskViewModel>(
          builder: (context, provider, _) {
            return AlertDialog(
              title: TextViewCustom(
                text: Strings.add_staff,
                tvColor: Palette.normalTv,
                fontSize: Converts.c16,
                isTextAlignCenter: false,
                isBold: true,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: Strings.staff_id,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: Converts.c16 - 2,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // Trigger search using Provider
                          provider.searchStaffs(searchController.text);
                        },
                        child: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  provider.uiState == UiState.loading
                      ? const CircularProgressIndicator()
                      : TextViewCustom(
                          text: provider.decoText != null
                              ? provider.decoText!
                              : "",
                          tvColor: Palette.semiTv,
                          fontSize: Converts.c16,
                          isTextAlignCenter: false,
                          isBold: false,
                        )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    provider.resetSearchStaffs();
                    Navigator.pop(context);
                  },
                  child: const Text(Strings.cancel),
                ),
                provider.uiState == UiState.commentLoading
                    ? SizedBox(
                        height: Converts.c12,
                        width: Converts.c12,
                        child: const CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (provider.decoText != null) {
                            await provider.saveSearchedStaff(widget.staffId);
                            if (provider.isSavedStaff != null) {
                              if (provider.isSavedStaff!) {
                                provider.setMessage(
                                    Strings.data_saved_successfully);
                              }
                            }
                          }
                        },
                        child: const Text(Strings.add),
                      ),
                provider.message != null
                    ? TextViewCustom(
                        text: provider.message!,
                        tvColor: Palette.completedColor,
                        fontSize: Converts.c16,
                        isTextAlignCenter: false,
                        isBold: true,
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }

  Widget warningMessage() {
    return _showWarningMessage
        ? Padding(
            padding: EdgeInsets.all(Converts.c8),
            child: Container(
              padding: EdgeInsets.all(Converts.c8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2), // Semi-transparent red
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(Converts.c8),
              ),
              child: Text(
                "Your email ID is invalid or empty. Please update your email. Just go to the side menu and click \'Edit\'",
                style: TextStyle(color: Colors.red, fontSize: Converts.c12),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
