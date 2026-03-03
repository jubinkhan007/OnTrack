import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/config/app_theme.dart';
import 'package:tmbi/widgets/new_task/bs_assigns.dart';
import 'package:tmbi/widgets/new_task/dropdown_type.dart';

import '../../config/converts.dart';
import '../../viewmodel/new_task/new_task_dashboard_viewmodel.dart';

class BsTaskEntry extends StatelessWidget {
  final Function(String value) onCreate;

  const BsTaskEntry({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.transparent, // To preserve the rounded corners
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        // rounded top corners
        child: Consumer<NewTaskDashboardViewmodel>(
            builder: (context, provider, _) {
          return SafeArea(
            bottom: false,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _handle(context, provider),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // editable task
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  TextField(
                                    maxLines: 2,
                                    minLines: 2,
                                    onChanged: (value) {
                                      provider.onTaskTextChanged(value);
                                    },
                                    controller: provider.taskTextEdit,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      labelText: 'Title*',
                                      hintText: 'Tap to add a title',
                                      hintStyle: TextStyle(
                                          color: AppColors.muted,
                                          fontSize: Converts.c16),
                                    ),
                                    style: TextStyle(
                                      fontSize: Converts.c16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    maxLines: 5,
                                    minLines: 3,
                                    onChanged: (value) {
                                      //provider.onTaskTextChanged(value);
                                    },
                                    controller: provider.taskDetailTextEdit,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      hintText: 'Tap to add a description...',
                                      hintStyle:
                                          TextStyle(color: AppColors.muted),
                                    ),
                                    style: TextStyle(
                                      fontSize: Converts.c16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24.0),
                                    child: Container(
                                      height: 1,
                                      color: AppColors.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // add assignees
                            ListTile(
                                leading: Icon(
                                  Icons.account_circle_outlined,
                                  color: AppColors.muted,
                                  size: Converts.c16,
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add assignee',
                                      style: TextStyle(
                                          color: AppColors.muted,
                                          fontSize: Converts.c16 - 2),
                                    ),
                                    provider.selectedStaffs.isEmpty
                                        ? const SizedBox.shrink()
                                        : Text(
                                            provider.selectedStaffs
                                                .map((staff) => staff.userName)
                                                .join(', '),
                                            style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: Converts.c16 - 2,
                                                fontWeight: FontWeight.w500),
                                          )
                                  ],
                                ),
                                onTap: () {
                                  final vm =
                                      context.read<NewTaskDashboardViewmodel>();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (_) {
                                      return ChangeNotifierProvider.value(
                                        value: vm,
                                        child: const BsAssigns(),
                                      );
                                    },
                                  );
                                }),

                            Padding(
                              padding: const EdgeInsets.only(left: 38.0),
                              child: Container(
                                height: 1,
                                color: AppColors.outline,
                              ),
                            ),

                            // set start date
                            ListTile(
                              leading: Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.muted,
                                size: Converts.c16,
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start date',
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: Converts.c16 - 2,
                                    ),
                                  ),
                                  provider.selectedStartDate == null
                                      ? const SizedBox.shrink()
                                      : Text(
                                          _formatDisplayDate(
                                              provider.selectedStartDate!),
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: Converts.c16 - 2,
                                              fontWeight: FontWeight.w500),
                                        )
                                ],
                              ),
                              onTap: () => _pickStartDate(context, provider),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 38.0),
                              child: Container(
                                height: 1,
                                color: AppColors.outline,
                              ),
                            ),

                            // set end date
                            ListTile(
                              leading: Icon(
                                Icons.event_available_outlined,
                                color: AppColors.muted,
                                size: Converts.c16,
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End date',
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: Converts.c16 - 2,
                                    ),
                                  ),
                                  provider.selectedEndDate == null
                                      ? const SizedBox.shrink()
                                      : Text(
                                          _formatDisplayDate(
                                              provider.selectedEndDate!),
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: Converts.c16 - 2,
                                              fontWeight: FontWeight.w500),
                                        )
                                ],
                              ),
                              onTap: () => _pickEndDate(context, provider),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Container(
                                height: 1,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // create button view
                    Padding(
                      padding: EdgeInsets.only(
                        right: 16.0,
                        bottom: 8 + MediaQuery.of(context).viewPadding.bottom,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 120,
                            // fixed width avoids unbounded width
                            child: DropdownType(
                              selected: provider.selectedDropdownOption ??
                                  DropdownOption(
                                    id: 1,
                                    icon: Icons.circle_outlined,
                                    label: 'TO DO',
                                  ),
                              onTap: () async {
                                final selected =
                                    await DropdownType.showOptionBottomSheet(
                                  context: context,
                                  options: [
                                    DropdownOption(
                                        id: 1,
                                        icon: Icons.circle_outlined,
                                        label: 'TO DO'),
                                    DropdownOption(
                                        id: 2,
                                        icon: Icons.folder_outlined,
                                        label: 'Project'),
                                  ],
                                );

                                if (selected != null) {
                                  provider.setDropDownValue(selected);
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // priority
                              IconButton(
                                onPressed: () async {
                                  final selected =
                                      await DropdownType.showOptionBottomSheet(
                                    context: context,
                                    options: [
                                      DropdownOption(
                                          id: 1,
                                          icon: Icons.flag_outlined,
                                          label: 'Urgent',
                                          color: Colors.red),
                                      DropdownOption(
                                          id: 2,
                                          icon: Icons.flag_outlined,
                                          label: 'High',
                                          color: Colors.orange.shade200),
                                      DropdownOption(
                                          id: 3,
                                          icon: Icons.flag_outlined,
                                          label: 'Normal',
                                          color: Colors.blue),
                                      DropdownOption(
                                          id: 4,
                                          icon: Icons.flag_outlined,
                                          label: 'Low'),
                                    ],
                                  );
                                  if (selected != null) {
                                    provider.setPriorityDropDownValue(selected);
                                  }
                                },
                                icon: Icon(
                                  provider.selectedPriorityDropdownOption ==
                                          null
                                      ? Icons.flag_outlined
                                      : Icons.flag,
                                  color:
                                      provider.selectedPriorityDropdownOption ==
                                              null
                                          ? Colors.black38
                                          : provider
                                              .selectedPriorityDropdownOption!
                                              .color,
                                ),
                              ),
                              // line
                              Text(
                                "|",
                                style: TextStyle(
                                    fontSize: Converts.c16,
                                    color: Colors.grey.shade300),
                              ),
                              // button
                              const SizedBox(
                                width: 16,
                              ),
                              provider.uiStateTask == UiState.loading
                                  ? SizedBox(
                                      height: Converts.c40,
                                      width: Converts.c40,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : SizedBox(
                                      height: Converts.c40,
                                      child: FilledButton(
                                        //onPressed: () => Navigator.pop(context),
                                        onPressed: provider.canCreate
                                            ? () async {
                                                final rootContext = context;
                                                onCreate(
                                                    provider.taskTextEdit.text);
                                                await provider.saveTask();
                                                if (!rootContext.mounted) return;
                                                if (provider.isSuccessTask) {
                                                  final wasOfflineSave =
                                                      provider
                                                          .isOfflineTaskSaved;
                                                  provider.resetTaskEntry();
                                                  if (!rootContext.mounted) {
                                                    return;
                                                  }
                                                  Navigator.pop(rootContext);
                                                  ScaffoldMessenger.of(
                                                          rootContext)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        wasOfflineSave
                                                            ? "Task saved offline. It will sync automatically when internet returns."
                                                            : "Task created successfully.",
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                          rootContext)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Colors.red.shade700,
                                                      content: Text(
                                                        provider.message ??
                                                            "Failed to create task. Please try again.",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            : null,
                                        child: Text(
                                          'Create',
                                          style: textTheme.labelLarge?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _handle(BuildContext context, NewTaskDashboardViewmodel provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: Converts.c48),
        Container(
          width: Converts.c48,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: AppColors.muted,
          ),
          onPressed: () {
            provider.resetTaskEntry();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Future<void> _pickStartDate(
      BuildContext context, NewTaskDashboardViewmodel provider) async {
    provider.ensureDateRangeDefaults();
    final DateTime initialDate = provider.startDateTime;
    final DateTime firstDate = provider.todayDate;
    final DateTime lastDate = DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      provider.setStartDate(pickedDate);
    }
  }

  Future<void> _pickEndDate(
      BuildContext context, NewTaskDashboardViewmodel provider) async {
    provider.ensureDateRangeDefaults();
    final DateTime initialDate = provider.endDateTime;
    final DateTime firstDate = provider.minEndDate;
    final DateTime lastDate = DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      provider.setEndDate(pickedDate);
    }
  }

  String _formatDisplayDate(String isoDate) {
    // Convert from yyyy-MM-dd to dd-MM-yyyy
    try {
      final parts = isoDate.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
      return isoDate;
    } catch (_) {
      return isoDate;
    }
  }
}
