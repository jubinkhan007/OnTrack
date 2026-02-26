import 'package:flutter/material.dart';

import '../../models/new_task/bu_response.dart';
import '../../config/app_theme.dart';

class FilterSection extends StatelessWidget {
  //final String selectedBU;
  final CompInfo? selectedBU;
  final List<CompInfo> buOptions;
  final TextEditingController staffController;
  final Function(CompInfo?) onBUChanged;
  final Function() onClean;
  final VoidCallback onStaffTap;

  const FilterSection({
    super.key,
    required this.selectedBU,
    required this.buOptions,
    required this.staffController,
    required this.onBUChanged,
    required this.onClean,
    required this.onStaffTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: DropdownButtonFormField<CompInfo>(
              isExpanded: true,
              value: selectedBU,
              decoration: InputDecoration(
                hintText: 'Business unit',
                prefixIcon: const Icon(Icons.apartment_rounded, size: 18),
                isDense: true,
                hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: buOptions.map((bu) {
                return DropdownMenuItem<CompInfo>(
                  value: bu,
                  child: Text(
                    bu.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onBUChanged,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: ValueListenableBuilder(
              valueListenable: staffController,
              builder: (context, _, __) {
                final hasValue = staffController.text.trim().isNotEmpty;
                return TextFormField(
                  controller: staffController,
                  readOnly: true,
                  onTap: onStaffTap,
                  decoration: InputDecoration(
                    hintText: 'Staff name',
                    prefixIcon:
                        const Icon(Icons.person_outline_rounded, size: 18),
                    isDense: true,
                    suffixIcon: hasValue
                        ? IconButton(
                            tooltip: 'Clear',
                            onPressed: () {
                              staffController.clear();
                              onClean();
                            },
                            icon: const Icon(Icons.close_rounded, size: 18),
                          )
                        : IconButton(
                            tooltip: 'Search',
                            onPressed: onStaffTap,
                            icon: const Icon(Icons.search_rounded, size: 18),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
