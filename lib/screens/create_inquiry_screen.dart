import 'package:flutter/material.dart';
import 'package:tmbi/widgets/date_selection_view.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../widgets/widgets.dart';

class CreateInquiryScreen extends StatelessWidget {
  static const String routeName = '/create_inquiry_screen';

  const CreateInquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Palette.mainColor,
            title: TextViewCustom(
              text: Strings.create_new,
              fontSize: Converts.c20,
              tvColor: Colors.white,
              isTextAlignCenter: false,
              isBold: true,
            ),
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              // Customize icon color
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Converts.c16,
              right: Converts.c16,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// title
                  TextField(
                    style: TextStyle(
                      fontSize: Converts.c20, // Text size
                      color: Colors.black, // Text color
                    ),
                    decoration: InputDecoration(
                      hintText: "Example: Want some sample",
                      hintStyle: TextStyle(
                        fontSize: Converts.c20, // Hint text size
                        color: Palette.semiTv, // Hint text color
                      ),
                    ),
                  ),

                  SizedBox(
                    height: Converts.c16,
                  ),

                  /// description
                  TextViewCustom(
                      text: Strings.description,
                      fontSize: Converts.c16,
                      tvColor: Palette.normalTv,
                      isRubik: false,
                      isBold: true),
                  SizedBox(
                    height: Converts.c8,
                  ),
                  TextField(
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: Converts.c16, // Text size
                      color: Palette.normalTv, // Text color
                    ),
                    decoration: InputDecoration(
                      hintText: Strings.enter_brief_description,
                      hintStyle: TextStyle(
                        fontSize: Converts.c16, // Hint text size
                        color: Palette.semiTv, // Hint text color
                      ),
                      border: const OutlineInputBorder(), // Border style
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0), // Enabled border style
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Converts.c8,
                  ),

                  /// buyer/customer
                  TextViewCustom(
                      text: Strings.buyer_customer,
                      fontSize: Converts.c16,
                      tvColor: Palette.normalTv,
                      isRubik: false,
                      isBold: true),
                  SizedBox(
                    height: Converts.c8,
                  ),
                  const CustomerAddView(),
                  SizedBox(
                    height: Converts.c8,
                  ),

                  /// company name

                  TextViewCustom(
                      text: Strings.company,
                      fontSize: Converts.c16,
                      tvColor: Palette.normalTv,
                      isRubik: false,
                      isBold: true),
                  SizedBox(
                    height: Converts.c8,
                  ),
                  const ComboBoxCustom(
                    hintName: Strings.select_company,
                    items: ["Walker", "Winner"],
                  ),
                  SizedBox(
                    height: Converts.c8,
                  ),

                  /// inquiry type
                  TextViewCustom(
                      text: Strings.inquiry_type,
                      fontSize: Converts.c16,
                      tvColor: Palette.normalTv,
                      isRubik: false,
                      isBold: true),
                  SizedBox(
                    height: Converts.c8,
                  ),
                  const ComboBoxCustom(
                    hintName: Strings.inquiry_type,
                    items: ["Sample", "Query"],
                  ),
                  SizedBox(
                    height: Converts.c8,
                  ),

                  /// end date
                  TextViewCustom(
                      text: Strings.end_date,
                      fontSize: Converts.c16,
                      tvColor: Palette.normalTv,
                      isRubik: false,
                      isBold: true),

                  SizedBox(
                    height: Converts.c8,
                  ),

                  const DateSelectionView(),

                  SizedBox(
                    height: Converts.c8,
                  ),

                  /// file
                  TextViewCustom(
                      text: Strings.attachment,
                      fontSize: Converts.c16,
                      tvColor: Palette.normalTv,
                      isRubik: false,
                      isBold: true),
                  SizedBox(
                    height: Converts.c8,
                  ),

                  const FileAttachment(),
                  SizedBox(
                    height: Converts.c16,
                  ),

                  /// create button
                  ButtonCustom1(
                    btnText: Strings.create_new,
                    btnHeight: Converts.c48,
                    bgColor: Palette.mainColor,
                    btnWidth: double.infinity,
                    cornerRadius: 4,
                    stockColor: Palette.mainColor,
                    onTap: () {},
                  ),
                  SizedBox(
                    height: Converts.c16,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
