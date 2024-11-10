import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/models/init_data_create_inq.dart';
import 'package:tmbi/viewmodel/inquiry_create_viewmodel.dart';
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
        Provider.of<InquiryCreateViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInitDataForCreateInquiry();
    });

    // customer list
    List<Customer> customers = [];
    // title & description & customer name
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController customerNameController =
        TextEditingController();
    // selected date
    String isSample = "N";
    String selectedDate = "";
    String mCompanyId = "";
    String mInquiryId = "";
    String mPriorityId = "";
    Customer? mCustomer;
    // files
    final List<ImageFile> imageFiles = [];
    // methods
    showMessage(String message) {
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

    resetFields() {
      isSample = "N";
      selectedDate = "";
      mCompanyId = "";
      mInquiryId = "";
      mPriorityId = "";
      mCustomer = null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<InquiryCreateViewModel>(
          builder: (context, inquiryViewModel, child) {
        if (inquiryViewModel.uiState == UiState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (inquiryViewModel.uiState == UiState.error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showMessage("Error: ${inquiryViewModel.message}");
          });
          //return Center(child: Text("Error: ${inquiryViewModel.message}"));
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
                    SizedBox(
                      height: Converts.c8,
                    ),

                    TextFieldInquiry(
                        fontSize: Converts.c20,
                        fontColor: Colors.black,
                        hintColor: Palette.semiTv,
                        hasBorder: true,
                        hint: "Type Title Here; Example: Need Sample ...",
                        controller: titleController),
                    CheckBox(onChecked: (value) {
                      isSample = value ?? "N";
                    }),
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
                        mCompanyId = companyId;
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
                      controller: customerNameController,
                      onCustomerSelected: (customer) {
                        if (customer != null) {
                          debugPrint("CUSTOMER#${customer.name}");
                          mCustomer = customer;
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
                        mInquiryId = inquiryId;
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
                        mPriorityId = priorityId;
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

                    DateSelectionView(
                      onDateSelected: (date) {
                        if (date != null) {
                          selectedDate = date;
                        }
                      },
                    ),

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

                    FileAttachment(
                      onFileAttached: (files) {
                        if (files != null) {
                          if (imageFiles.isNotEmpty) {
                            imageFiles.clear();
                          }
                          imageFiles.addAll(files);
                          debugPrint(imageFiles.length.toString());
                        }
                      },
                    ),
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
                      onTap: () async {
                        if (mCompanyId != "" &&
                            mInquiryId != "" &&
                            mPriorityId != "" &&
                            selectedDate != "" &&
                            titleController.value != null &&
                            descriptionController.value != null &&
                            mCustomer != null) {
                          // upload files, if any are selected
                          if (imageFiles.isNotEmpty) {
                            await inquiryViewModel.saveFiles(imageFiles);
                          }
                          // save inquiry
                          await inquiryViewModel.saveInquiry(
                              mCompanyId,
                              mInquiryId,
                              titleController.text,
                              descriptionController.text,
                              isSample,
                              selectedDate,
                              mPriorityId,
                              mCustomer!.id.toString(),
                              mCustomer!.id != 0
                                  ? mCustomer!.name.toString()
                                  : customerNameController.text.toString(),
                              "340553",
                              inquiryViewModel.files);

                          // check the status of the request
                          if (inquiryViewModel.isSavedInquiry != null) {
                            if (inquiryViewModel.isSavedInquiry!) {
                              showMessage(Strings.data_saved_successfully);
                              //Navigator.pop(context);
                            } else {
                              showMessage(Strings.failed_to_save_the_data);
                            }
                          } else {
                            showMessage(Strings.data_is_missing);
                          }
                          // reset all values to default
                          resetFields();
                        } else {
                          showMessage(Strings.some_values_are_missing);
                        }
                      },
                    ),
                    SizedBox(
                      height: Converts.c16,
                    ),
                  ],
                ),
              ),
            ),
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
