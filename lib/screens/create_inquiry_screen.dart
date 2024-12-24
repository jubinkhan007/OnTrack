import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/screens/screens.dart';
import 'package:tmbi/viewmodel/inquiry_create_viewmodel.dart';
import 'package:tmbi/widgets/date_selection_view.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/sp_helper.dart';
import '../config/strings.dart';
import '../models/models.dart';
import '../models/user_response.dart';
import '../network/ui_state.dart';
import '../widgets/widgets.dart';

class CreateInquiryScreen extends StatefulWidget {
  static const String routeName = '/create_inquiry_screen';
  final String staffId;

  const CreateInquiryScreen({super.key, required this.staffId});

  @override
  State<CreateInquiryScreen> createState() => _CreateInquiryScreenState();
}

class _CreateInquiryScreenState extends State<CreateInquiryScreen> {
  List<Discussion> discussionList = [
    /*Discussion(
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
    ),*/
  ];

  /*List<Customer> getStaffs() {
    return [
      Customer(id: '340553', name: 'Md. Salauddin', isVerified: true),
      Customer(id: '397820', name: 'Md. Imrul Kayesh', isVerified: false),
      Customer(id: '397690', name: 'Subrato Ghosh', isVerified: true),
      Customer(id: '30940', name: 'Md. Elias Hossain', isVerified: false),
      Customer(id: '486133', name: 'Adeepta Shushil Shuvo', isVerified: true),
    ];
  }*/

  // customer list
  List<Customer> customers = [];
  bool isTaskEntryModeEnable = false;

  // title & description & customer name
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();

  // selected date
  String isSample = "N";

  //String selectedDate = "";
  String selectedDate = DateTime.now().toFormattedString(format: "yyyy-MM-dd");
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
    //selectedDate = "";
    mCompanyId = "";
    mInquiryId = "";
    mPriorityId = "";
    mCustomer = null;
    imageFiles.clear();
  }

  @override
  void initState() {
    super.initState();
    final inquiryViewModel =
        Provider.of<InquiryCreateViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getInitDataForCreateInquiry(widget.staffId);
      // reset individual tasks, files if any
      inquiryViewModel.removeAllTask();
      inquiryViewModel.removeFiles();
      // reset all
      resetFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<InquiryCreateViewModel>(
          builder: (context, inquiryViewModel, child) {
        if (inquiryViewModel.uiState == UiState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (inquiryViewModel.uiState == UiState.error) {
          /*WidgetsBinding.instance.addPostFrameCallback((_) {
            showMessage("Error: ${inquiryViewModel.message}");
          });*/
          return ErrorContainer(
              message: inquiryViewModel.message != null
                  ? inquiryViewModel.message!
                  : Strings.something_went_wrong);
        }
        //remove the previous task
        // and save any new tasks
        if (discussionList.isNotEmpty) {
          discussionList.clear();
        }
        discussionList.addAll(inquiryViewModel.discussions);
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
              actions: [
                isTaskEntryModeEnable
                    ? IconButton(
                        icon: Padding(
                          padding: EdgeInsets.only(right: Converts.c8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: Converts.c16,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              TextViewCustom(
                                text: Strings.tasks,
                                fontSize: Converts.c16,
                                tvColor: Colors.white,
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                        // Customize icon color
                        onPressed: () async {
                          String userId = await _getUserInfo();
                          if (mCompanyId != "") {
                            Navigator.pushNamed(
                                context, AddTaskToStaffScreen.routeName,
                                arguments: {
                                  'staffId': userId,
                                  'companyId': mCompanyId,
                                  //'individual_task': discussionList
                                  'individual_task': inquiryViewModel
                                      .discussions
                                      .map((discussion) => discussion.toJson())
                                      .toList(),
                                  'description':
                                      descriptionController.text.toString()
                                  /*'staff_list': getStaffs()
                                      .map((discussion) => discussion.toJson())
                                      .toList(),*/
                                });
                          } else {
                            showMessage(Strings.company_name_is_missing);
                          }
                          debugPrint(
                              "INDEX:: ${inquiryViewModel.discussions.length}");
                        },
                      )
                    : const SizedBox.shrink(),
              ],
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
                    SizedBox(
                      height: Converts.c8,
                    ),

                    /// title & is sample
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldInquiry(
                              fontSize: Converts.c20,
                              fontColor: Colors.black,
                              hintColor: Palette.grayColor,
                              hasBorder: true,
                              hint: Strings.type_title_here,
                              controller: titleController),
                        ),
                        CheckBox(
                            title: Strings.is_sample,
                            isTitleBold: true,
                            isChecked: false,
                            onChecked: (value) {
                              isSample = value ?? "N";
                            }),
                      ],
                    ),

                    SizedBox(
                      height: Converts.c8,
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
                      hintColor: Palette.grayColor,
                      hint: Strings.enter_brief_description,
                      controller: descriptionController,
                      maxLine: 5,
                      hasBorder: true,
                    ),
                    SizedBox(
                      height: Converts.c8,
                    ),

                    /// company name && inquiry type
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// company name
                          SizedBox(
                            width: Converts.c192,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  items:
                                      inquiryViewModel.initDataCreateInq != null
                                          ? inquiryViewModel.initDataCreateInq!
                                                      .company !=
                                                  null
                                              ? inquiryViewModel
                                                  .initDataCreateInq!.company!
                                              : []
                                          : [],
                                  onChanged: (companyId) {
                                    if (customers.isNotEmpty) customers.clear();
                                    customers.addAll(_getCustomers(
                                        inquiryViewModel
                                            .initDataCreateInq!.company!,
                                        companyId));
                                    debugPrint("COMPANY_ID# $companyId");
                                    //mCompanyId = companyId;
                                    setState(() {
                                      mCompanyId = companyId;
                                      // remove tasks (if any)
                                      Provider.of<InquiryCreateViewModel>(
                                              context,
                                              listen: false)
                                          .removeAllTask();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: Converts.c8,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Converts.c8,
                          ),

                          /// inquiry type
                          SizedBox(
                            width: Converts.c192,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  items:
                                      inquiryViewModel.initDataCreateInq != null
                                          ? inquiryViewModel.initDataCreateInq!
                                                      .inquiryType !=
                                                  null
                                              ? inquiryViewModel
                                                  .initDataCreateInq!
                                                  .inquiryType!
                                              : []
                                          : [],
                                  onChanged: (inquiryId) {
                                    debugPrint("INQUIRY_ID# $inquiryId");
                                    mInquiryId = inquiryId;
                                    setState(() {
                                      // clear previous task
                                      Provider.of<InquiryCreateViewModel>(
                                              context,
                                              listen: false)
                                          .removeAllTask();
                                      if (mInquiryId == "0") {
                                        isTaskEntryModeEnable = true;
                                      } else {
                                        isTaskEntryModeEnable = false;
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: Converts.c8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

                    /// priority && end date
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// priority
                          SizedBox(
                            width: Converts.c192,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  items:
                                      inquiryViewModel.initDataCreateInq != null
                                          ? inquiryViewModel.initDataCreateInq!
                                                      .priority !=
                                                  null
                                              ? inquiryViewModel
                                                  .initDataCreateInq!.priority!
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
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Converts.c8,
                          ),

                          /// end date
                          SizedBox(
                            width: Converts.c192,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            ),
                          ),
                        ],
                      ),
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
                          if (mInquiryId == "0" &&
                              inquiryViewModel.discussions.isEmpty) {
                            showMessage(Strings.please_enter_the_task);
                          } else {
                            // get user id
                            String userId = await _getUserInfo();
                            // upload files, if any are selected
                            if (imageFiles.isNotEmpty) {
                              await inquiryViewModel.saveFiles(imageFiles);
                            }
                            // save inquiry
                            await inquiryViewModel.saveInquiry(
                                mCompanyId,
                                mInquiryId,
                                //titleController.text,
                                //descriptionController.text,
                                Uri.encodeComponent(titleController.text),
                                Uri.encodeComponent(descriptionController.text),
                                isSample,
                                selectedDate,
                                mPriorityId,
                                mCustomer!.id.toString(),
                                mCustomer!.id != "0"
                                    ? mCustomer!.name.toString()
                                    : customerNameController.text.toString(),
                                userId,
                                _tasksToString(),
                                inquiryViewModel.files);

                            // check the status of the request
                            if (inquiryViewModel.isSavedInquiry != null) {
                              if (inquiryViewModel.isSavedInquiry!) {
                                showMessage(Strings.data_saved_successfully);
                                Navigator.pop(context);
                              } else {
                                showMessage(Strings.failed_to_save_the_data);
                              }
                            } else {
                              showMessage(Strings.data_is_missing);
                            }
                            // reset all values to default
                            resetFields();
                          }
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

  Future<String> _getUserInfo({bool isName = false}) async {
    try {
      UserResponse? userResponse = await SPHelper().getUser();
      String id = userResponse != null ? userResponse.users![0].staffId! : "";
      String name =
          userResponse != null ? userResponse.users![0].staffName! : "";
      return isName ? name : id;
    } catch (e) {
      return "";
    }
  }

  String _tasksToString() {
    if (discussionList.isNotEmpty) {
      List<Map<String, dynamic>> tasksJson =
          discussionList.map((task) => task.toJson()).toList();
      return jsonEncode(tasksJson);
    }
    return "";
  }
}
