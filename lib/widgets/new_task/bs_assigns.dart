import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/app_theme.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/viewmodel/new_task/new_task_dashboard_viewmodel.dart';

class BsAssigns extends StatefulWidget {
  const BsAssigns({super.key});

  @override
  State<BsAssigns> createState() => _BsAssignsState();
}

class _BsAssignsState extends State<BsAssigns> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _query = ValueNotifier('');

  @override
  void dispose() {
    _controller.dispose();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskDashboardViewmodel>(
      builder: (context, provider, child) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _handle(),
                  const SizedBox(height: 8),
                  Text(
                    'Assignee',
                    style: TextStyle(
                      fontSize: Converts.c16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _controller,
                      onChanged: (v) => _query.value = v,
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.muted,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),

                  // Selected staff chip
                  if (provider.selectedStaffs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Assignee (only one member can be added)',
                          style: TextStyle(
                            fontSize: Converts.c16 - 2,
                            color: AppColors.muted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Wrap(
                    spacing: 2,
                    children: provider.selectedStaffs.map((staff) {
                      return Chip(
                        backgroundColor: AppColors.accent.withOpacity(0.12),
                        side: BorderSide(
                            color: AppColors.accent.withOpacity(0.25)),
                        label: Text(
                          staff.displayName,
                          style: TextStyle(
                            fontSize: Converts.c16 - 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => provider.remove(staff),
                      );
                    }).toList(),
                  ),

                  if (provider.selectedStaffs.isNotEmpty) const Divider(),

                  // Filtered staff list
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _query,
                      builder: (context, query, _) {
                        final all = provider.availableStaffs;
                        final filtered = query.isEmpty
                            ? all
                            : all
                                .where((s) => s.searchName
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text(
                              'No staff found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, index) {
                            final staff = filtered[index];
                            final initial = staff.displayName.isNotEmpty
                                ? staff.displayName.characters.first
                                    .toUpperCase()
                                : '?';
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    AppColors.accent.withOpacity(0.12),
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                              title: Text(
                                staff.displayName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Converts.c16 - 2,
                                ),
                              ),
                              onTap: () {
                                if (provider.selectedStaffs.isEmpty) {
                                  provider.add(staff);
                                }
                                _controller.clear();
                                _query.value = '';
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _handle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.outline,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
