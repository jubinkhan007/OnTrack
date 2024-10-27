import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/models/init_data_create_inq.dart';
import 'package:tmbi/viewmodel/inquiry_viewmodel.dart';
import 'package:tmbi/widgets/date_selection_view.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../network/ui_state.dart';
import '../widgets/widgets.dart';

class CreateInquiryScreen extends StatelessWidget {
  static const String routeName = '/create_inquiry_screen';

  const CreateInquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInitDataForCreateInquiry();
    });

    // customer list
    List<Customer> customers = [];
    // title & description
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<InquiryViewModel>(
          builder: (context, inquiryViewModel, child) {
        if (inquiryViewModel.uiState == UiState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (inquiryViewModel.uiState == UiState.error) {
          return Center(child: Text("Error: ${inquiryViewModel.message}"));
        }

        return CustomScrollView(
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
                    TextFieldInquiry(
                        fontSize: Converts.c20,
                        fontColor: Colors.black,
                        hintColor: Palette.semiTv,
                        hint: "Example: Want some sample",
                        controller: titleController),
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
                    TextFieldInquiry(
                      fontSize: Converts.c16,
                      fontColor: Palette.normalTv,
                      hintColor: Palette.semiTv,
                      hint: Strings.enter_brief_description,
                      controller: descriptionController,
                      maxLine: 5,
                      hasBorder: true,
                    ),
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
                    ComboBoxCompany(
                      hintName: Strings.select_company,
                      items: inquiryViewModel.initDataCreateInq != null
                          ? inquiryViewModel.initDataCreateInq!.company != null
                              ? inquiryViewModel.initDataCreateInq!.company!
                              : []
                          : [],
                      onChanged: (companyId) {
                        if (customers.isNotEmpty) customers.clear();
                        customers.addAll(_getCustomers(
                            inquiryViewModel.initDataCreateInq!.company!,
                            companyId));
                        debugPrint("COMPANY_ID# $companyId");
                      },
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
                    CustomerAddView(
                      customers: customers,
                      onCustomerSelected: (customer) {
                        if (customer != null) {
                          debugPrint("CUSTOMER#${customer.name}");
                        }
                        //_showCustomerDialog(context, _customers);
                      },
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
                    ComboBoxInquiryType(
                      hintName: Strings.inquiry_type,
                      items: inquiryViewModel.initDataCreateInq != null
                          ? inquiryViewModel.initDataCreateInq!.inquiryType !=
                                  null
                              ? inquiryViewModel.initDataCreateInq!.inquiryType!
                              : []
                          : [],
                      onChanged: (inquiryId) {
                        debugPrint("COMPANY_ID# $inquiryId");
                      },
                    ),
                    SizedBox(
                      height: Converts.c8,
                    ),

                    /// priority
                    TextViewCustom(
                        text: Strings.priority,
                        fontSize: Converts.c16,
                        tvColor: Palette.normalTv,
                        isRubik: false,
                        isBold: true),
                    SizedBox(
                      height: Converts.c8,
                    ),
                    ComboBoxPriority(
                      hintName: Strings.select_priority,
                      items: inquiryViewModel.initDataCreateInq != null
                          ? inquiryViewModel.initDataCreateInq!.priority != null
                              ? inquiryViewModel.initDataCreateInq!.priority!
                              : []
                          : [],
                      onChanged: (priorityId) {
                        debugPrint("PRIORITY_ID# $priorityId");
                      },
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
                      onTap: () {
                        debugPrint("TITLE#${titleController.text}");
                        debugPrint("DESCRIPTION#${descriptionController.text}");
                      },
                    ),
                    SizedBox(
                      height: Converts.c16,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  List<Customer> _getCustomers(List<Company> companies, String companyId) {
    List<Customer> customers = [];
    for (var company in companies) {
      if (company.id.toString() == companyId) {
        customers.addAll(company.customer!);
        break;
      }
    }
    return customers;
  }
}
