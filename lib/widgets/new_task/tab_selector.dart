import 'package:flutter/material.dart';

import '../../config/converts.dart';
import '../../config/strings.dart';

class TabSelector extends StatelessWidget {
  final bool createdSelected;
  final VoidCallback onCreatedTap;
  final VoidCallback onAssignedTap;

  const TabSelector({
    super.key,
    required this.createdSelected,
    required this.onCreatedTap,
    required this.onAssignedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Converts.c8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Converts.c12),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onCreatedTap,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(vertical: Converts.c8),
                  decoration: BoxDecoration(
                    color: createdSelected
                        ? Colors.blueAccent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Converts.c12),
                  ),
                  child: Center(
                      child: Text(
                    Strings.createdByMe,
                    style: TextStyle(
                        fontSize: Converts.c12,
                        color: !createdSelected ? Colors.black : Colors.white),
                  )),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onAssignedTap,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(vertical: Converts.c8),
                  decoration: BoxDecoration(
                    color: !createdSelected
                        ? Colors.blueAccent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Converts.c12),
                  ),
                  child: Center(
                      child: Text(
                    Strings.assignedToMe,
                    style: TextStyle(
                        fontSize: Converts.c12,
                        color: !createdSelected ? Colors.white : Colors.black),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
