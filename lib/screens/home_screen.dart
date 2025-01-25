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

import '../config/enum.dart';
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

  @override
  void initState() {
    super.initState();
    selectedFlagValue = StatusFlag.pending.getFlag;
    status = HomeFlagItem().homeFlagItems[0].status;
    selectedFlag = HomeFlagItem().homeFlagItems[0].title;

    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInquiries(
          selectedFlagValue, widget.staffId, isAssigned);
    });
    debugPrint("Called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*Navigator.pushNamed(context, CreateInquiryScreen.routeName,
              arguments: widget.staffId);*/
          Navigator.pushNamed(context, TodoHomeScreen.routeName,
              arguments: widget.staffId);
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
              onPressed: () {
                context.showMessage(Strings.home);
              },
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
          SliverToBoxAdapter(
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
                      /// search by user
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
                    });

                    await _getInquiries(
                      Provider.of<InquiryViewModel>(context, listen: false),
                      selectedFlagValue,
                      isAssigned,
                      customer != null ? customer!.id! : widget.staffId,
                    );
                    debugPrint("Selected Flag: $value");
                  },
                ),
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

  Future<void> _getInquiries(InquiryViewModel inquiryViewModel, String flag,
      String isAssigned, String userid) async {
    await inquiryViewModel.getInquiries(flag, userid, isAssigned,
        vm: customer == null ? "INQALL" : "SINQALL");
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
      InquiryViewModel inquiryViewModel, String selectedFlagValue) {
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
                        setState(() {
                          this.customer = customer;
                        });
                        await _getInquiries(inquiryViewModel, selectedFlagValue,
                            isAssigned, customer!.id!);
                        if (context.mounted) {
                          Navigator.of(context).pop();
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
}
