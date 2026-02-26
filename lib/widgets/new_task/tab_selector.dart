import 'package:flutter/material.dart';

import '../../config/converts.dart';
import '../../config/strings.dart';
import '../../config/app_theme.dart';

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
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Converts.c8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white,
        border: const Border.fromBorderSide(BorderSide(color: AppColors.outline)),
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6)),
        ],
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
                    color: createdSelected ? cs.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                      child: Text(
                    Strings.createdByMe,
                    style: TextStyle(
                        fontSize: Converts.c12,
                        fontWeight: FontWeight.w700,
                        color: createdSelected ? Colors.white : AppColors.muted),
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
                    color: !createdSelected ? cs.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                      child: Text(
                    Strings.assignedToMe,
                    style: TextStyle(
                        fontSize: Converts.c12,
                        fontWeight: FontWeight.w700,
                        color:
                            !createdSelected ? Colors.white : AppColors.muted),
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
