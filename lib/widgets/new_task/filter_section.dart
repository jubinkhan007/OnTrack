
import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final String selectedBU;
  final List<String> buOptions;
  final TextEditingController staffController;
  final Function(String?) onBUChanged;
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
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
                          child: Text(bu, style: const TextStyle(fontSize: 14)),
                        ))
                    .toList(),
                onChanged: onBUChanged,
              ),
            ),
            Container(
              width: 1,
              height: 32,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            Expanded(
              child: Stack(
                children: [
                  TextFormField(
                    controller: staffController,
                    readOnly: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Staff name",
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                  ),

                  // Overlay for detecting tap ONLY on text area
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: onStaffTap,
                    ),
                  ),

                  // Place the suffix icon ABOVE the overlay so it does NOT trigger onStaffTap
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ValueListenableBuilder(
                      valueListenable: staffController,
                      builder: (context, value, _) {
                        if (staffController.text.isEmpty) {
                          return GestureDetector(
                            onTap: onStaffTap,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.search, size: 18),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () => staffController.clear(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.close, size: 18),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
