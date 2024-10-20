import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/models/models.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/converts.dart';

class IntroScreen extends StatefulWidget {
  static const String routeName = '/intro_screen';
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final itemIntro = IntroItem();
  final pageController = PageController();
  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: Converts.c16,
          horizontal: Converts.c8,
        ),
        child: _isLastPage
            ? _btnGetStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      pageController.jumpToPage(itemIntro.intros.length - 1);
                    },
                    child: TextViewCustom(
                      text: Strings.skip,
                      fontSize: Converts.c16,
                      tvColor: Palette.mainColor,
                      isBold: false,
                    ),
                  ),
                  SmoothPageIndicator(
                    onDotClicked: (index) => {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    },
                    effect: const WormEffect(
                      activeDotColor: Palette.mainColor,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                    controller: pageController,
                    count: itemIntro.intros.length,
                  ),
                  TextButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: TextViewCustom(
                      text: Strings.next,
                      fontSize: Converts.c16,
                      tvColor: Palette.mainColor,
                      isBold: false,
                    ),
                  ),
                ],
              ),
      ),
      body: Container(
        color: Colors.white,
        child: PageView.builder(
          itemCount: itemIntro.intros.length,
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              _isLastPage = itemIntro.intros.length - 1 == index;
            });
          },
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(itemIntro.intros[index].imagePath),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Converts.c16, right: Converts.c16),
                    child: Column(
                      children: [
                        TextViewCustom(
                            text: itemIntro.intros[index].title,
                            fontSize: Converts.c20,
                            tvColor: Colors.black,
                            isBold: true),
                        SizedBox(
                          height: Converts.c8,
                        ),
                        TextViewCustom(
                            text: itemIntro.intros[index].description,
                            fontSize: Converts.c16,
                            tvColor: Palette.semiTv,
                            isBold: false),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _btnGetStarted() {
    return Padding(
      padding: EdgeInsets.only(left: Converts.c16, right: Converts.c16),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.mainColor,
          borderRadius: BorderRadius.circular(Converts.c8),
        ),
        height: Converts.c48,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextViewCustom(
                text: Strings.lets_started,
                fontSize: Converts.c16,
                tvColor: Colors.white,
                isBold: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: Converts.c8),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
