import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/data/counter_item.dart';
import 'package:tmbi/screens/comment_screen.dart';
import 'package:tmbi/screens/create_inquiry_screen.dart';
import 'package:tmbi/screens/inquiry_view.dart';
import 'package:tmbi/viewmodel/viewmodel.dart';
import 'package:tmbi/widgets/feature_status.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../models/models.dart';
import '../network/ui_state.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInquiries();
    });

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
                Icons.folder_open,
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
            backgroundColor: Palette.mainColor,
            automaticallyImplyLeading: false,
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
                  onPressed: (value) async {
                    await _getInquiries(inquiryViewModel);
                    debugPrint(value);
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
                child: Center(
                  child: Text("Error: ${inquiryViewModel.message}"),
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
                              arguments:
                                  inquiryResponse, // Pass the list as arguments
                            );
                          },
                          onCommentTap: (id) {
                            Navigator.pushNamed(
                              context,
                              CommentScreen.routeName,
                              arguments: id, // Pass the list as arguments
                            );
                          },
                          onAttachmentTap: (id) {},
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
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/ic_empty_2.png',
                              height: Converts.c120,
                              width: Converts.c120,
                            ),
                            TextViewCustom(
                                text: Strings.no_data_found,
                                fontSize: Converts.c16,
                                tvColor: Palette.semiTv,
                                isBold: false)
                          ],
                        ),
                      ),
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

  Future<void> _getInquiries(InquiryViewModel inquiryViewModel) async {
    await inquiryViewModel.getInquiries();
  }
}
