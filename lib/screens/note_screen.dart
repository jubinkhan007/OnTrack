import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/extension_file.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../network/ui_state.dart';
import '../viewmodel/viewmodel.dart';
import '../widgets/widgets.dart';

class NoteScreen extends StatelessWidget {
  static const String routeName = '/note_screen';
  final String inquiryId;
  final String taskId;

  const NoteScreen({super.key, required this.inquiryId, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getNotes(inquiryId, taskId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        centerTitle: false,
        title: TextViewCustom(
          text: Strings.notes,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          // Customize icon color
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Consumer<InquiryViewModel>(
          builder: (context, inquiryViewModel, child) {
        if (inquiryViewModel.uiState == UiState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (inquiryViewModel.uiState == UiState.error) {
          return Center(
            child: ErrorContainer(
                message: inquiryViewModel.message != null
                    ? inquiryViewModel.message!
                    : Strings.something_went_wrong),
          );
        }
        // null check for noteResponse and notes
        if (inquiryViewModel.noteResponse?.isEmpty ?? true) {
          return Center(
            child: ErrorContainer(
                message: inquiryViewModel.message != null
                    ? inquiryViewModel.message!
                    : Strings.no_data_found),
          );
        }

        return ListView.separated(
          itemCount: inquiryViewModel.noteResponse != null
              ? inquiryViewModel.noteResponse!.length
              : 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: Converts.c8,
                bottom: Converts.c8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: Converts.c8),
                              child: Icon(
                                Icons.date_range,
                                color: Palette.normalTv,
                                size: Converts.c16,
                              ),
                            ),
                            SizedBox(
                              width: Converts.c8,
                            ),
                            TextViewCustom(
                                text: inquiryViewModel
                                        .noteResponse![index]!.dateTime!
                                        .split("T")[0] ??
                                    "",
                                fontSize: Converts.c16,
                                tvColor: Palette.normalTv,
                                isBold: true),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                height: 4,
                                width: 4,
                                decoration: const BoxDecoration(
                                  color: Palette.semiNormalTv,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            TextViewCustom(
                                text: inquiryViewModel
                                        .noteResponse![index]!.dateTime!
                                        .split("T")[1] ??
                                    "",
                                fontSize: Converts.c16,
                                tvColor: Palette.normalTv,
                                isBold: true),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: Converts.c12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: inquiryViewModel!
                                .noteResponse![index]!.status!.statusColor,
                            borderRadius: BorderRadius.circular(
                                Converts.c12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: TextViewCustom(
                              text: inquiryViewModel!
                                      .noteResponse![index]!.status ??
                                  "",
                              fontSize: Converts.c12,
                              tvColor: Colors.black,
                              isTextAlignCenter: false,
                              isRubik: false,
                              isBold: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Converts.c8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Converts.c16, right: Converts.c16),
                    child: TextViewCustom(
                        text:
                            inquiryViewModel.noteResponse![index]!.description!,
                        fontSize: Converts.c16,
                        tvColor: Palette.normalTv,
                        isTextAlignCenter: false,
                        isRubik: false,
                        isBold: false),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(); // Add a separator between items
          },
        );
      }),
    );
  }
}
