import 'package:flutter/material.dart';

import '../../config/converts.dart';
import '../../config/strings.dart';

class FilterSection extends StatelessWidget {
  final String selectedBU;
  final List<String> buOptions;
  final String staffName;
  final Function(String?) onBUChanged;
  final Function(String) onStaffChanged;

  const FilterSection({
    super.key,
    required this.selectedBU,
    required this.buOptions,
    required this.staffName,
    required this.onBUChanged,
    required this.onStaffChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(Converts.c12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // --- BU Wise Dropdown - Wrap Content --- \\
            IntrinsicWidth(
              child: DropdownButtonFormField<String>(
                value: selectedBU,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                items: buOptions
                    .map((bu) => DropdownMenuItem(
                        value: bu,
                        child: Text(
                          bu,
                          style: const TextStyle(fontSize: 14),
                        )))
                    .toList(),
                onChanged: onBUChanged,
              ),
            ),

            // --- Divider  --- \\
            Container(
                width: 1,
                height: 32,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 8)),

            // --- Staff Name Search Box --- \\
            Expanded(
              child: TextFormField(
                initialValue: staffName,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: Strings.staff_name,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  suffixIcon: Icon(
                    Icons.search,
                    size: 18,
                  ),
                ),
                onChanged: onStaffChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
